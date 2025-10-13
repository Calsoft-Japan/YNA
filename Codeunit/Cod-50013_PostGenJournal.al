codeunit 50013 "CSGen. Jnl.-Post"
{
    EventSubscriberInstance = Manual;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Copy(Rec);

        //hcj begin
        IF GenJnlLine.FIND('-') THEN BEGIN
            REPEAT
                //new requirement check AP/Ar Account no. when Document Type = Invoice OR Credit Memo OR Blank? AND Account Type = Vendor
                IF ((GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice) OR
                    (GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo") OR
                    (GenJnlLine."Document Type" = GenJnlLine."Document Type"::" "))
                     AND (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) THEN BEGIN
                    IF GenJnlLine."AP/AR Account No." = '' THEN
                        ERROR('AP Account No. cannot be blank. (Document Type: ' + FORMAT(GenJnlLine."Document Type") + ', Document No.: ' +
                        GenJnlLine."Document No." + ', Vendor: ' + GenJnlLine."Account No." + ')');

                    IF (GenJnlLine."Journal Batch Name" <> 'MSR') AND (GenJnlLine."External Document No." = '') THEN
                        ERROR('External Document No. cannot be blank. (Document Type: ' + FORMAT(GenJnlLine."Document Type") + ', Document no: ' +
                        GenJnlLine."Document No." + ', Vendor: ' + GenJnlLine."Account No." + ')');

                END;
                // END new requirement

                tempGenJnlLine.INIT;
                tempGenJnlLine := GenJnlLine;
                tempGenJnlLine.INSERT;
            UNTIL GenJnlLine.NEXT = 0;
        END;
        //hcj end

        Code(GenJnlLine);
        Rec.Copy(GenJnlLine);

        OnAfterOnRun(Rec);
    end;

    var
        JournalErrorsMgt: Codeunit "Journal Errors Mgt.";
        JournalsScheduledMsg: Label 'Journal lines have been scheduled for posting.';
#pragma warning disable AA0074
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines?';
        Text003: Label 'The journal lines were successfully posted.';
#pragma warning disable AA0470
        Text004: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
        Text005: Label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?';
        Text006: Label '%1 in %2 must not be equal to %3 in %4.', Comment = 'Source Code in Genenral Journal Template must not be equal to Job G/L WIP in Source Code Setup.';
#pragma warning restore AA0470
#pragma warning restore AA0074
        GenJnlsScheduled: Boolean;
        PreviewMode: Boolean;

        tempGenJnlLine: Record "Gen. Journal Line" temporary;
        typeCount: Integer;

    local procedure "Code"(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        FALedgEntry: Record "FA Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlPostviaJobQueue: Codeunit "Gen. Jnl.-Post via Job Queue";
        GenJnlPostBatch: Codeunit "CS_Gen. Jnl.-Post Batch";
        ConfirmManagement: Codeunit "Confirm Management";
        TempJnlBatchName: Code[10];
        HideDialog: Boolean;
        IsHandled: Boolean;
        ShouldExit: Boolean;
        //CSV-------
        applyentry: Codeunit VendEntryApplyPostEn;
        VendorLedEntry: Record "Vendor Ledger Entry";
        Custapplyentry: Codeunit CustEntryApplyPostEn;
        CustLedEntry: Record "Cust. Ledger Entry";
    begin
        HideDialog := false;
        OnBeforeCode(GenJnlLine, HideDialog);

        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        if GenJnlTemplate.Type = GenJnlTemplate.Type::Jobs then begin
            SourceCodeSetup.Get();
            if GenJnlTemplate."Source Code" = SourceCodeSetup."Job G/L WIP" then
                Error(Text006, GenJnlTemplate.FieldCaption("Source Code"), GenJnlTemplate.TableCaption(),
                  SourceCodeSetup.FieldCaption("Job G/L WIP"), SourceCodeSetup.TableCaption());
        end;
        GenJnlTemplate.TestField("Force Posting Report", false);
        if GenJnlTemplate.Recurring and (GenJnlLine.GetFilter(GenJnlLine."Posting Date") <> '') then
            GenJnlLine.FieldError("Posting Date", Text000);

        OnCodeOnAfterCheckTemplate(GenJnlLine);

        IsHandled := false;
        ShouldExit := false;
        OnCodeOnBeforeConfirmPostJournalLinesResponse(GenJnlLine, IsHandled, ShouldExit);
        if ShouldExit then
            exit;

        if not IsHandled then
            if not (PreviewMode or HideDialog) then
                if not ConfirmManagement.GetResponseOrDefault(Text001, true) then
                    exit;

        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" then begin
            FALedgEntry.SetRange("FA No.", GenJnlLine."Account No.");
            FALedgEntry.SetRange("FA Posting Type", FALedgEntry."FA Posting Type"::Depreciation);
            if not FALedgEntry.IsEmpty() and GenJnlLine."Depr. Acquisition Cost" and not HideDialog then
                if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text005, GenJnlLine.FieldCaption(GenJnlLine."Depr. Acquisition Cost")), true) then
                    exit;
        end;

        if not HideDialog then
            if not GenJnlPostBatch.ConfirmPostingUnvoidableChecks(GenJnlLine."Journal Batch Name", GenJnlLine."Journal Template Name") then
                exit;

        OnCodeOnAfterConfirmPostingUnvoidableChecks(GenJnlLine);

        TempJnlBatchName := GenJnlLine."Journal Batch Name";

        GeneralLedgerSetup.Get();
        GenJnlPostBatch.SetPreviewMode(PreviewMode);
        if GeneralLedgerSetup."Post with Job Queue" and not PreviewMode then begin
            // Add job queue entry for each document no.
            GenJnlLine.SetCurrentKey("Document No.");
            while GenJnlLine.FindFirst() do begin
                GenJnlsScheduled := true;
                GenJnlPostviaJobQueue.EnqueueGenJrnlLineWithUI(GenJnlLine, false);
                GenJnlLine.SetFilter("Document No.", '>%1', GenJnlLine."Document No.");
            end;

            if GenJnlsScheduled then
                Message(JournalsScheduledMsg);
        end else begin
            IsHandled := false;
            OnBeforeGenJnlPostBatchRun(GenJnlLine, IsHandled, GenJnlPostBatch);
            if IsHandled then
                exit;

            GenJnlPostBatch.Run(GenJnlLine);

            OnCodeOnAfterGenJnlPostBatchRun(GenJnlLine);

            if PreviewMode then
                exit;

            ShowPostResultMessage(GenJnlLine, TempJnlBatchName);
        end;


        //hcj begin
        IF tempGenJnlLine.FIND('-') THEN BEGIN
            REPEAT
                IF tempGenJnlLine."External Document No." = '' THEN BEGIN
                    IF (tempGenJnlLine."Original Document No." <> '') AND
                    (tempGenJnlLine."Journal Template Name" = 'PURCHASES')
                           AND (tempGenJnlLine."Account Type" = tempGenJnlLine."Account Type"::Vendor) THEN BEGIN
                        VendorLedEntry.RESET;
                        VendorLedEntry.SETRANGE("Document No.", tempGenJnlLine."Document No.");
                        VendorLedEntry.SETRANGE("Vendor No.", tempGenJnlLine."Account No.");
                        VendorLedEntry.SETRANGE("External Document No.", tempGenJnlLine."External Document No.");
                        IF VendorLedEntry.FIND('-') THEN BEGIN
                            applyentry.RUN(VendorLedEntry);
                        END;
                    END
                END
                ELSE BEGIN
                    IF (tempGenJnlLine."Original Document No." <> '') AND
                    (tempGenJnlLine."Journal Template Name" = 'PURCHASES')
                           AND (tempGenJnlLine."Account Type" = tempGenJnlLine."Account Type"::Vendor) THEN BEGIN
                        VendorLedEntry.RESET;
                        VendorLedEntry.SETRANGE("Document No.", tempGenJnlLine."Document No.");
                        VendorLedEntry.SETRANGE("Vendor No.", tempGenJnlLine."Account No.");
                        VendorLedEntry.SETFILTER("External Document No.",
                             COPYSTR(tempGenJnlLine."External Document No.", 1, STRLEN(tempGenJnlLine."External Document No.") - 15) + '*');
                        VendorLedEntry.SETRANGE("AP Account No.", tempGenJnlLine."AP/AR Account No.");
                        VendorLedEntry.SETRANGE("Document Type", tempGenJnlLine."Document Type");
                        IF VendorLedEntry.FIND('-') THEN BEGIN
                            applyentry.RUN(VendorLedEntry);
                        END;
                    END

                END;
            UNTIL tempGenJnlLine.NEXT = 0;
        END;
        // hcj end


        //hcj begin Apply for sales
        IF tempGenJnlLine.FIND('-') THEN BEGIN
            REPEAT
                IF tempGenJnlLine."External Document No." = '' THEN BEGIN
                    IF (tempGenJnlLine."Original Document No." <> '') AND
                    (tempGenJnlLine."Journal Template Name" = 'SALES')
                           AND (tempGenJnlLine."Account Type" = tempGenJnlLine."Account Type"::Customer) THEN BEGIN
                        CustLedEntry.RESET;
                        CustLedEntry.SETRANGE("Document No.", tempGenJnlLine."Document No.");
                        CustLedEntry.SETRANGE("Customer No.", tempGenJnlLine."Account No.");
                        CustLedEntry.SETRANGE("External Document No.", tempGenJnlLine."External Document No.");
                        IF CustLedEntry.FIND('-') THEN BEGIN
                            Custapplyentry.RUN(CustLedEntry);
                        END;
                    END
                END
                ELSE BEGIN
                    IF (tempGenJnlLine."Original Document No." <> '') AND
                    (tempGenJnlLine."Journal Template Name" = 'SALES')
                           AND (tempGenJnlLine."Account Type" = tempGenJnlLine."Account Type"::Customer) THEN BEGIN
                        CustLedEntry.RESET;
                        CustLedEntry.SETRANGE("Document No.", tempGenJnlLine."Document No.");
                        CustLedEntry.SETRANGE("Customer No.", tempGenJnlLine."Account No.");
                        CustLedEntry.SETFILTER("External Document No.",
                             COPYSTR(tempGenJnlLine."External Document No.", 1, STRLEN(tempGenJnlLine."External Document No.") - 12) + '*');
                        CustLedEntry.SETRANGE("AR Account No.", tempGenJnlLine."AP/AR Account No.");
                        CustLedEntry.SETRANGE("Document Type", tempGenJnlLine."Document Type");
                        IF CustLedEntry.FIND('-') THEN BEGIN
                            Custapplyentry.RUN(CustLedEntry);
                        END;
                    END

                END;
            UNTIL tempGenJnlLine.NEXT = 0;
        END;
        // hcj end Sales


        if not GenJnlLine.Find('=><') or (TempJnlBatchName <> GenJnlLine."Journal Batch Name") or GeneralLedgerSetup."Post with Job Queue" then begin
            GenJnlLine.Reset();
            GenJnlLine.FilterGroup(2);
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", GenJnlLine."Journal Batch Name");
            OnGenJnlLineSetFilter(GenJnlLine);
            GenJnlLine.FilterGroup(0);
            GenJnlLine."Line No." := 1;
        end;
    end;

    local procedure ShowPostResultMessage(var GenJnlLine: Record "Gen. Journal Line"; TempJnlBatchName: Code[10])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowPostResultMessage(GenJnlLine, TempJnlBatchName, IsHandled);
        if IsHandled then
            exit;

        if GenJnlLine."Line No." = 0 then
            Message(JournalErrorsMgt.GetNothingToPostErrorMsg())
        else
            if TempJnlBatchName = GenJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(Text004, GenJnlLine."Journal Batch Name");
    end;

    procedure Preview(var GenJournalLineSource: Record "Gen. Journal Line")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        GenJnlPost: Codeunit "CSGen. Jnl.-Post";
    begin
        BindSubscription(GenJnlPost);
        GenJnlPostPreview.Preview(GenJnlPost, GenJournalLineSource);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGenJnlPostBatchRun(var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean; var GenJnlPostBatch: Codeunit "CS_Gen. Jnl.-Post Batch")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowPostResultMessage(var GenJnlLine: Record "Gen. Journal Line"; TempJnlBatchName: Code[10]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnAfterGenJnlPostBatchRun(var GenJnlLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnAfterCheckTemplate(var GenJnlLine: Record "Gen. Journal Line")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean; Subscriber: Variant; RecVar: Variant)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPost: Codeunit "CSGen. Jnl.-Post";
    begin
        GenJnlPost := Subscriber;
        GenJournalLine.Copy(RecVar);
        PreviewMode := true;
        Result := GenJnlPost.Run(GenJournalLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGenJnlLineSetFilter(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnBeforeConfirmPostJournalLinesResponse(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean; var ShouldExit: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRun(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnAfterConfirmPostingUnvoidableChecks(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
}

