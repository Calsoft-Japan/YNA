codeunit 50008 GenJnlPostPrintExt
{
    //CS 2025/1/10 Channing.Zhou FDD209
    var
        BatchPostingPrintMgt: Codeunit "Batch Posting Print Mgt.";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post+Print", OnAfterOnRun, '', false, false)]
    local procedure "Gen. Jnl.-Post+Print_OnAfterOnRun"(var GenJournalLine: Record "Gen. Journal Line")
    var
        applyentry: Codeunit VendEntryApplyPostEn;
        VendorLedEntry: Record "Vendor Ledger Entry";
        Custapplyentry: Codeunit CustEntryApplyPostEn;
        CustLedEntry: Record "Cust. Ledger Entry";
        tempGenJnlLine: Record GlobalGenJnlLine;
    begin
        //bobby begin
        tempGenJnlLine.Reset();
        tempGenJnlLine.SetRange("User ID", UserId);
        //booby end
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
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post+Print", OnBeforePostJournalBatch, '', false, false)]
    local procedure OnBeforePostJournalBatch(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        APACC: Code[10];
        GLACC_CIP: Boolean;
        GLACCNON_CIP: Boolean;
        Warning_CIP: Text;
        DocNo_CIP: Text;
        LastDocNo_CIP: Text;
        TempGenJnlLine: Record GlobalGenJnlLine;
        glreg: Record "G/L Register";
        LastTempGJLineno: Integer;
    begin

        //bobby begin
        TempGenJnlLine.Reset();
        TempGenJnlLine.SetRange("User ID", UserId);
        if TempGenJnlLine.FindFirst() then
            TempGenJnlLine.DeleteAll();
        //bobby end

        //hcj begin
        IF GenJournalLine.FindFirst() THEN BEGIN
            REPEAT
                //new requirement check AP/Ar Account no. when Document Type = Invoice OR Credit Memo OR Blank? AND Account Type = Vendor
                IF ((GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice) OR
                    (GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo") OR
                    (GenJournalLine."Document Type" = GenJournalLine."Document Type"::" "))
                     AND (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) THEN BEGIN
                    IF GenJournalLine."AP/AR Account No." = '' THEN
                        ERROR('the AP Account No. can not be blank when the Account type is Vendor. (Document no is ' +
                        GenJournalLine."Document No." + ' and Vendor is ' + GenJournalLine."Account No." + ')');
                END;
                // END new requirement
                //bobby begin                

                //hcj
                TempGenJnlLine.Reset();
                if TempGenJnlLine.FindLast() then
                    LastTempGJLineno := TempGenJnlLine."Entry No." + 1
                else
                    LastTempGJLineno := 1;
                TempGenJnlLine.Init();
                TempGenJnlLine."Entry No." := LastTempGJLineno;
                //hcj

                //TempGenJnlLine.Init();
                //TempGenJnlLine."Entry No." := 0;
                glreg.Reset();
                if glreg.FindLast() then
                    TempGenJnlLine."GLReg EntryNo" := glreg."No."
                else
                    TempGenJnlLine."GLReg EntryNo" := 0;
                TempGenJnlLine."User ID" := UserId;
                TempGenJnlLine."Account No." := GenJournalLine."Account No.";
                TempGenJnlLine."Account Type" := GenJournalLine."Account Type";
                TempGenJnlLine."AP/AR Account No." := GenJournalLine."AP/AR Account No.";
                TempGenJnlLine."Document No." := GenJournalLine."Document No.";
                TempGenJnlLine."Document Type" := GenJournalLine."Document Type";
                TempGenJnlLine."External Document No." := GenJournalLine."External Document No.";
                TempGenJnlLine."Journal Template Name" := GenJournalLine."Journal Template Name";
                TempGenJnlLine."Original Document No." := GenJournalLine."Original Document No.";
                TempGenJnlLine.Insert();
            //bobby end
            UNTIL GenJournalLine.NEXT = 0;
        END;
        //hcj end
        // Start [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
        APACC := '';
        GLACC_CIP := FALSE;
        GLACCNON_CIP := FALSE;
        Warning_CIP := '';
        DocNo_CIP := '';
        LastDocNo_CIP := '';
        // End [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
        if not GenJournalLine.IsEmpty() then begin
            GenJournalLine.FindSet();
            repeat
                // Start [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
                LastDocNo_CIP := DocNo_CIP;
                DocNo_CIP := FORMAT(GenJournalLine."Document No.");
                IF (LastDocNo_CIP <> '') AND (DocNo_CIP <> LastDocNo_CIP) THEN BEGIN
                    IF (APACC = '41510') AND GLACCNON_CIP THEN BEGIN
                        Warning_CIP := 'Balance account No. for 41510 is not 217xx. Do you want to continue? (Document No.: ' + LastDocNo_CIP + ')';
                        IF NOT CONFIRM(Warning_CIP, TRUE) THEN
                            ERROR('Please correct balance account No.')
                    END;

                    IF GLACC_CIP AND (APACC <> '41510') AND (APACC <> '') THEN BEGIN
                        Warning_CIP := 'AP Account No. for 217xx is not 41510. Do you want to continue? (Document No.: ' + LastDocNo_CIP + ')';
                        IF NOT CONFIRM(Warning_CIP, TRUE) THEN
                            ERROR('Please correct AP Account No.')
                    END;
                    APACC := '';
                    GLACC_CIP := FALSE;
                    GLACCNON_CIP := FALSE;
                END;

                IF (GenJournalLine."Journal Template Name" = 'PURCHASES') AND (GenJournalLine."Journal Batch Name" <> 'MSR') THEN BEGIN
                    IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::"Vendor" THEN
                        APACC := GenJournalLine."AP/AR Account No.";
                    IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") AND (FORMAT(GenJournalLine."Account No.", 3) = '217') THEN
                        GLACC_CIP := TRUE;
                    IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") AND (FORMAT(GenJournalLine."Account No.", 3) <> '217') THEN
                        GLACCNON_CIP := TRUE;
                END;
            // End [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
            until GenJournalLine.Next() = 0;
            // Start [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
            IF (APACC = '41510') AND GLACCNON_CIP THEN BEGIN
                Warning_CIP := 'Balance account No. for 41510 is not 217xx. Do you want to continue? (Document No.: ' + DocNo_CIP + ')';
                IF NOT CONFIRM(Warning_CIP, TRUE) THEN
                    ERROR('Please correct balance account No.')
            END;
            IF GLACC_CIP AND (APACC <> '41510') AND (APACC <> '') THEN BEGIN
                Warning_CIP := 'AP Account No. for 217xx is not 41510. Do you want to continue? (Document No.: ' + DocNo_CIP + ')';
                IF NOT CONFIRM(Warning_CIP, TRUE) THEN
                    ERROR('Please correct AP Account No.')
            END;
            // End [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
        end;
    end;
    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post+Print", OnAfterConfirmPostJournalBatch, '', false, false)]
        local procedure "Gen. Jnl.-Post+Print_OnAfterConfirmPostJournalBatch"(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
        var
            GeneralLedgerSetup: Record "General Ledger Setup";
            PrintGenJournalLine: Record "Gen. Journal Line";
            GenJnlsScheduled: Boolean;
            GenJnlPostviaJobQueue: Codeunit "Gen. Jnl.-Post via Job Queue";
            JournalsScheduledMsg: Label 'Journal lines have been scheduled for posting.';
            HideDialog: Boolean;
            JournalErrorsMgt: Codeunit "Journal Errors Mgt.";
            Text003: Label 'The journal lines were successfully posted.';
            TempJnlBatchName: Code[10];
            Text004: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
        begin
            HideDialog := false;
            GeneralLedgerSetup.Get();
            if GeneralLedgerSetup."Post & Print with Job Queue" then begin
                // Add job queue entry for each document no.
                GenJournalLine.SetCurrentKey(GenJournalLine."Document No.");
                while GenJournalLine.FindFirst() do begin
                    GenJnlsScheduled := true;
                    GenJournalLine."Print Posted Documents" := true;
                    GenJournalLine.Modify();
                    GenJnlPostviaJobQueue.EnqueueGenJrnlLineWithUI(GenJournalLine, false);
                    GenJournalLine.SetFilter("Document No.", '>%1', GenJournalLine."Document No.");
                end;

                if GenJnlsScheduled then
                    Message(JournalsScheduledMsg);
            end else begin
                PrintGenJournalLine := GenJournalLine;
                CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine);

                PrintJournal(GenJournalLine);

                if not HideDialog then
                    if GenJournalLine."Line No." = 0 then
                        Message(JournalErrorsMgt.GetNothingToPostErrorMsg())
                    else begin
                        IsHandled := false;
                        if not IsHandled then
                            if TempJnlBatchName = GenJournalLine."Journal Batch Name" then
                                Message(Text003)
                            else
                                Message(Text004, GenJournalLine."Journal Batch Name");
                    end;
            end;

            if not GenJournalLine.Find('=><') or (TempJnlBatchName <> GenJournalLine."Journal Batch Name") or GeneralLedgerSetup."Post & Print with Job Queue" then begin
                GenJournalLine.Reset();
                GenJournalLine.FilterGroup(2);
                GenJournalLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                GenJournalLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                GenJournalLine.FilterGroup(0);
                GenJournalLine."Line No." := 1;
            end;
            IsHandled := true;
        end;

        local procedure PrintJournal(var GenJnlLine: Record "Gen. Journal Line")
        var
            IsHandled: Boolean;
            RecRefToPrint: RecordRef;
        begin
            OnBeforePrintJournalBatch(GenJnlLine);
            IsHandled := false;
            if IsHandled then
                exit;

            RecRefToPrint.GetTable(GenJnlLine);
            BatchPostingPrintMgt.PrintJournal(RecRefToPrint);

        end;*/
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post+Print", OnBeforePrintJournalBatch, '', false, false)]
    local procedure "Gen. Jnl.-Post+Print_OnBeforePrintJournalBatch"(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        GLEntry: Record "G/L Entry";
        intEntryTo: Integer;
        intEntryFrom: Integer;
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GLReg: Record "G/L Register";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        TempGenJnlLine: Record GlobalGenJnlLine;
    begin

        //IF GLReg.GET(GenJournalLine."Line No.") then;
        //IF GLReg.GET(GenJournalLine."Line No.") then;
        intEntryFrom := 0;
        intEntryTo := 0;


        GenJnlTemplate.Get(GenJournalLine."Journal Template Name");

        GeneralLedgerSetup.Get();


        if GLReg.Get(GenJournalLine."Line No.") then
            intEntryTo := GLReg."To Entry No.";


        tempGenJnlLine.Reset();
        tempGenJnlLine.SetRange("User ID", UserId);
        IF TempGenJnlLine.FindFirst() THEN BEGIN
            GLReg.Reset();
            if GLReg.Get(TempGenJnlLine."GLReg EntryNo" + 1) then
                intEntryFrom := GLReg."From Entry No.";
        end;

        if intEntryFrom > 0 then begin

            // Bobby FDD201 20250214 BEGIN




            if GenJnlTemplate."Cust. Receipt Report ID" <> 0 then begin
                //CustLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No."); //original code
                CustLedgEntry.SetRange("Entry No.", intEntryFrom, intEntryTo); //FDD209
                if GeneralLedgerSetup."Post & Print with Job Queue" then
                    BatchPostingPrintMgt.SchedulePrintJobQueueEntry(GLReg, GenJnlTemplate."Cust. Receipt Report ID", GeneralLedgerSetup."Report Output Type".AsInteger())
                else
                    REPORT.Run(GenJnlTemplate."Cust. Receipt Report ID", false, false, CustLedgEntry);
            end;

            if GenJnlTemplate."Vendor Receipt Report ID" <> 0 then begin
                //VendLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");//original code
                VendLedgEntry.SetRange("Entry No.", intEntryFrom, intEntryTo);  //FDD209
                if GeneralLedgerSetup."Post & Print with Job Queue" then
                    BatchPostingPrintMgt.SchedulePrintJobQueueEntry(GLReg, GenJnlTemplate."Vendor Receipt Report ID", GeneralLedgerSetup."Report Output Type".AsInteger())
                else
                    REPORT.Run(GenJnlTemplate."Vendor Receipt Report ID", false, false, VendLedgEntry);
            end;

            IF (intEntryFrom > 0) AND (intEntryTo > 0) THEN BEGIN
                GLReg.RESET;
                GLReg.SETFILTER("From Entry No.", '>=' + FORMAT(intEntryFrom));
                // GLReg.SETFILTER("To Entry No." , '<='+FORMAT(intEntryTo));
                GLReg.SETRANGE("User ID", USERID); // added 8/8/2016
                IF GLReg.FINDFIRST THEN
                 ;
            END;

            if GenJnlTemplate."Posting Report ID" <> 0 then begin
                //GLReg.SetRecFilter();//original code
                // //IF (intEntryFrom > 0) AND (intEntryTo > 0) THEN BEGIN Bobby FDD201 2025/2/14
                // IF (intEntryFrom > 0) THEN BEGIN
                //     GLReg.RESET;
                //     //GLReg.SETFILTER("From Entry No.", '>=' + FORMAT(intEntryFrom));
                //     GLReg.SETFILTER("To Entry No.", '<=' + FORMAT(intEntryTo));
                //     GLReg.SETRANGE("User ID", USERID); // added 8/8/2016
                //     IF GLReg.FINDFIRST THEN;
                // END;
                if GeneralLedgerSetup."Post & Print with Job Queue" then
                    BatchPostingPrintMgt.SchedulePrintJobQueueEntry(GLReg, GenJnlTemplate."Posting Report ID", GeneralLedgerSetup."Report Output Type".AsInteger())
                else
                    //REPORT.Run(GenJnlTemplate."Posting Report ID", false, false, GLReg);
                    REPORT.Run(GenJnlTemplate."Posting Report ID", true, false, GLReg);
                IF GenJournalLine."Journal Template Name" = 'SALES' THEN BEGIN
                    //CustLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No."); //Original Code
                    CustLedgEntry.SETRANGE("Entry No.", intEntryFrom, intEntryTo); //FDD209
                    PrintCustomerReport(CustLedgEntry); // add hcj 11.09

                END
                ELSE BEGIN
                    //VendLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No."); //Original Code
                    VendLedgEntry.SETRANGE("Entry No.", intEntryFrom, intEntryTo);
                    PrintVendorReport(VendLedgEntry); // add hcj 11.09
                END;
            end;
        end;
        IsHandled := true;
    end;

    LOCAL PROCEDURE PrintVendorReport(VAR Rec: Record "Vendor Ledger Entry");
    VAR
        inVendLedgEntry: Record "Vendor Ledger Entry";
        GJL: Record "Gen. Journal Line" TEMPORARY;
        LineNo: Integer;
        SPreport: Report "Sale-Purch.Credit memo";
    BEGIN
        inVendLedgEntry.COPY(Rec);
        LineNo := 10000;
        IF inVendLedgEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF inVendLedgEntry."Print Debit/Credit Memo" THEN BEGIN
                    GJL.INIT;
                    GJL."Line No." := LineNo;
                    GJL."Account Type" := GJL."Account Type"::Vendor;
                    GJL."Account No." := inVendLedgEntry."Vendor No.";
                    inVendLedgEntry.CALCFIELDS(inVendLedgEntry.Amount);
                    GJL.Amount := inVendLedgEntry.Amount;
                    GJL."Document No." := inVendLedgEntry."Document No."; // No.
                    GJL."Posting Date" := inVendLedgEntry."Posting Date"; // Credit/debit memo date
                    GJL."Item No." := inVendLedgEntry."Item No.";
                    GJL."Item Description" := inVendLedgEntry."Item Description";
                    GJL."RMA No." := inVendLedgEntry."RMA No.";
                    GJL.Quantity1 := inVendLedgEntry.Quantity;
                    GJL."Unit Price" := inVendLedgEntry."Unit Price";
                    GJL."Print Debit/Credit Memo" := inVendLedgEntry."Print Debit/Credit Memo";
                    GJL.INSERT;
                    LineNo += 10000;
                END;
            UNTIL inVendLedgEntry.NEXT = 0;
            IF GJL.FINDFIRST THEN BEGIN
                SPreport.Settemptable(GJL);
                SPreport.PRINT('');
            END;
        END;
    END;

    LOCAL PROCEDURE PrintCustomerReport(VAR Rec: Record "Cust. Ledger Entry");
    VAR
        inCustLedgEntry: Record "Cust. Ledger Entry";
        GJL: Record "Gen. Journal Line" TEMPORARY;
        LineNo: Integer;
        SPreport: Report "Sale-Purch.Credit memo";
    BEGIN
        inCustLedgEntry.COPY(Rec);
        LineNo := 10000;
        IF inCustLedgEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF inCustLedgEntry."Print Debit/Credit Memo" THEN BEGIN
                    GJL.INIT;
                    GJL."Line No." := LineNo;
                    GJL."Account Type" := GJL."Account Type"::Customer;
                    GJL."Account No." := inCustLedgEntry."Customer No.";
                    inCustLedgEntry.CALCFIELDS(inCustLedgEntry.Amount);
                    GJL.Amount := inCustLedgEntry.Amount;
                    GJL."Document No." := inCustLedgEntry."Document No."; // No.
                    GJL."Posting Date" := inCustLedgEntry."Posting Date"; // Credit/debit memo date
                    GJL."Item No." := inCustLedgEntry."Item No.";
                    GJL."Item Description" := inCustLedgEntry."Item Description";
                    GJL."RMA No." := inCustLedgEntry."RMA No.";
                    GJL.Quantity1 := inCustLedgEntry.Quantity;
                    GJL."Unit Price" := inCustLedgEntry."Unit Price";
                    GJL."Print Debit/Credit Memo" := inCustLedgEntry."Print Debit/Credit Memo";
                    GJL.INSERT;
                    LineNo += 10000;
                END;
            UNTIL inCustLedgEntry.NEXT = 0;
            IF GJL.FINDFIRST THEN BEGIN
                SPreport.Settemptable(GJL);
                SPreport.PRINT('');
            END;
        END;
    END;

    procedure SchedulePrintJobQueueEntry(RecVar: Variant; ReportId: Integer; ReportOutputType: Option)
    var
        JobQueueEntry: Record "Job Queue Entry";
        RecRefToPrint: RecordRef;
    begin
        RecRefToPrint.GetTable(RecVar);
        Clear(JobQueueEntry.ID);
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Report;
        JobQueueEntry."Object ID to Run" := ReportId;
        JobQueueEntry."Report Output Type" := "Job Queue Report Output Type".FromInteger(ReportOutputType);
        JobQueueEntry."Record ID to Process" := RecRefToPrint.RecordId;
        JobQueueEntry.Description := Format(JobQueueEntry."Report Output Type");
        CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
        Commit();
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CSGen. Jnl.-Post+Print", OnAfterOnRun, '', false, false)]
    local procedure "CSGen. Jnl.-Post+Print_OnAfterOnRun"(var GenJournalLine: Record "Gen. Journal Line")
    var
        applyentry: Codeunit VendEntryApplyPostEn;
        VendorLedEntry: Record "Vendor Ledger Entry";
        Custapplyentry: Codeunit CustEntryApplyPostEn;
        CustLedEntry: Record "Cust. Ledger Entry";
        tempGenJnlLine: Record GlobalGenJnlLine;
    begin
        //bobby begin
        tempGenJnlLine.Reset();
        tempGenJnlLine.SetRange("User ID", UserId);
        //booby end
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
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CSGen. Jnl.-Post+Print", OnBeforePostJournalBatch, '', false, false)]
    local procedure CSOnBeforePostJournalBatch(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        APACC: Code[10];
        GLACC_CIP: Boolean;
        GLACCNON_CIP: Boolean;
        Warning_CIP: Text;
        DocNo_CIP: Text;
        LastDocNo_CIP: Text;
        TempGenJnlLine: Record GlobalGenJnlLine;
        glreg: Record "G/L Register";
        LastTempGJLineno: Integer;
    begin
        //bobby begin
        TempGenJnlLine.Reset();
        TempGenJnlLine.SetRange("User ID", UserId);
        if TempGenJnlLine.FindFirst() then
            TempGenJnlLine.DeleteAll();
        //bobby end

        //hcj begin
        IF GenJournalLine.FindFirst() THEN BEGIN
            REPEAT
                //new requirement check AP/Ar Account no. when Document Type = Invoice OR Credit Memo OR Blank? AND Account Type = Vendor
                IF ((GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice) OR
                    (GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo") OR
                    (GenJournalLine."Document Type" = GenJournalLine."Document Type"::" "))
                     AND (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) THEN BEGIN
                    IF GenJournalLine."AP/AR Account No." = '' THEN
                        ERROR('the AP Account No. can not be blank when the Account type is Vendor. (Document no is ' +
                        GenJournalLine."Document No." + ' and Vendor is ' + GenJournalLine."Account No." + ')');
                END;
                // END new requirement
                //bobby begin



                //hcj
                TempGenJnlLine.Reset();
                if TempGenJnlLine.FindLast() then
                    LastTempGJLineno := TempGenJnlLine."Entry No." + 1
                else
                    LastTempGJLineno := 1;
                TempGenJnlLine.Init();
                TempGenJnlLine."Entry No." := LastTempGJLineno;
                //hcj

                //TempGenJnlLine.Init();
                //TempGenJnlLine."Entry No." := 0;
                glreg.Reset();
                if glreg.FindLast() then
                    TempGenJnlLine."GLReg EntryNo" := glreg."No."
                else
                    TempGenJnlLine."GLReg EntryNo" := 0;
                TempGenJnlLine."User ID" := UserId;
                TempGenJnlLine."Account No." := GenJournalLine."Account No.";
                TempGenJnlLine."Account Type" := GenJournalLine."Account Type";
                TempGenJnlLine."AP/AR Account No." := GenJournalLine."AP/AR Account No.";
                TempGenJnlLine."Document No." := GenJournalLine."Document No.";
                TempGenJnlLine."Document Type" := GenJournalLine."Document Type";
                TempGenJnlLine."External Document No." := GenJournalLine."External Document No.";
                TempGenJnlLine."Journal Template Name" := GenJournalLine."Journal Template Name";
                TempGenJnlLine."Original Document No." := GenJournalLine."Original Document No.";
                TempGenJnlLine.Insert();
            //bobby end
            UNTIL GenJournalLine.NEXT = 0;
        END;
        //hcj end
        // Start [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
        APACC := '';
        GLACC_CIP := FALSE;
        GLACCNON_CIP := FALSE;
        Warning_CIP := '';
        DocNo_CIP := '';
        LastDocNo_CIP := '';
        // End [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
        if not GenJournalLine.IsEmpty() then begin
            GenJournalLine.FindSet();
            repeat
                // Start [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
                LastDocNo_CIP := DocNo_CIP;
                DocNo_CIP := FORMAT(GenJournalLine."Document No.");
                IF (LastDocNo_CIP <> '') AND (DocNo_CIP <> LastDocNo_CIP) THEN BEGIN
                    IF (APACC = '41510') AND GLACCNON_CIP THEN BEGIN
                        Warning_CIP := 'Balance account No. for 41510 is not 217xx. Do you want to continue? (Document No.: ' + LastDocNo_CIP + ')';
                        IF NOT CONFIRM(Warning_CIP, TRUE) THEN
                            ERROR('Please correct balance account No.')
                    END;

                    IF GLACC_CIP AND (APACC <> '41510') AND (APACC <> '') THEN BEGIN
                        Warning_CIP := 'AP Account No. for 217xx is not 41510. Do you want to continue? (Document No.: ' + LastDocNo_CIP + ')';
                        IF NOT CONFIRM(Warning_CIP, TRUE) THEN
                            ERROR('Please correct AP Account No.')
                    END;
                    APACC := '';
                    GLACC_CIP := FALSE;
                    GLACCNON_CIP := FALSE;
                END;

                IF (GenJournalLine."Journal Template Name" = 'PURCHASES') AND (GenJournalLine."Journal Batch Name" <> 'MSR') THEN BEGIN
                    IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::"Vendor" THEN
                        APACC := GenJournalLine."AP/AR Account No.";
                    IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") AND (FORMAT(GenJournalLine."Account No.", 3) = '217') THEN
                        GLACC_CIP := TRUE;
                    IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") AND (FORMAT(GenJournalLine."Account No.", 3) <> '217') THEN
                        GLACCNON_CIP := TRUE;
                END;
            // End [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
            until GenJournalLine.Next() = 0;
            // Start [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
            IF (APACC = '41510') AND GLACCNON_CIP THEN BEGIN
                Warning_CIP := 'Balance account No. for 41510 is not 217xx. Do you want to continue? (Document No.: ' + DocNo_CIP + ')';
                IF NOT CONFIRM(Warning_CIP, TRUE) THEN
                    ERROR('Please correct balance account No.')
            END;
            IF GLACC_CIP AND (APACC <> '41510') AND (APACC <> '') THEN BEGIN
                Warning_CIP := 'AP Account No. for 217xx is not 41510. Do you want to continue? (Document No.: ' + DocNo_CIP + ')';
                IF NOT CONFIRM(Warning_CIP, TRUE) THEN
                    ERROR('Please correct AP Account No.')
            END;
            // End [T20170613.0021] 41510-217* Restriction check logic. 6/15/2017 by J.WU
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CSGen. Jnl.-Post+Print", OnBeforePrintJournalBatch, '', false, false)]
    local procedure "CS_Gen. Jnl.-Post+Print_OnBeforePrintJournalBatch"(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        GLEntry: Record "G/L Entry";
        intEntryTo: Integer;
        intEntryFrom: Integer;
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GLReg: Record "G/L Register";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        TempGenJnlLine: Record GlobalGenJnlLine;
    begin

        //IF GLReg.GET(GenJournalLine."Line No.") then;
        intEntryFrom := 0;
        intEntryTo := 0;


        GenJnlTemplate.Get(GenJournalLine."Journal Template Name");

        GeneralLedgerSetup.Get();


        if GLReg.Get(GenJournalLine."Line No.") then
            intEntryTo := GLReg."To Entry No.";


        tempGenJnlLine.Reset();
        tempGenJnlLine.SetRange("User ID", UserId);
        IF TempGenJnlLine.FindFirst() THEN BEGIN
            GLReg.Reset();
            if GLReg.Get(TempGenJnlLine."GLReg EntryNo" + 1) then
                intEntryFrom := GLReg."From Entry No.";
        end;

        if intEntryFrom > 0 then begin

            // Bobby FDD201 20250214 BEGIN




            if GenJnlTemplate."Cust. Receipt Report ID" <> 0 then begin
                //CustLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No."); //original code
                CustLedgEntry.SetRange("Entry No.", intEntryFrom, intEntryTo); //FDD209
                if GeneralLedgerSetup."Post & Print with Job Queue" then
                    BatchPostingPrintMgt.SchedulePrintJobQueueEntry(GLReg, GenJnlTemplate."Cust. Receipt Report ID", GeneralLedgerSetup."Report Output Type".AsInteger())
                else
                    REPORT.Run(GenJnlTemplate."Cust. Receipt Report ID", false, false, CustLedgEntry);
            end;

            if GenJnlTemplate."Vendor Receipt Report ID" <> 0 then begin
                //VendLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");//original code
                VendLedgEntry.SetRange("Entry No.", intEntryFrom, intEntryTo);  //FDD209
                if GeneralLedgerSetup."Post & Print with Job Queue" then
                    BatchPostingPrintMgt.SchedulePrintJobQueueEntry(GLReg, GenJnlTemplate."Vendor Receipt Report ID", GeneralLedgerSetup."Report Output Type".AsInteger())
                else
                    REPORT.Run(GenJnlTemplate."Vendor Receipt Report ID", false, false, VendLedgEntry);
            end;

            IF (intEntryFrom > 0) AND (intEntryTo > 0) THEN BEGIN
                GLReg.RESET;
                GLReg.SETFILTER("From Entry No.", '>=' + FORMAT(intEntryFrom));
                // GLReg.SETFILTER("To Entry No." , '<='+FORMAT(intEntryTo));
                GLReg.SETRANGE("User ID", USERID); // added 8/8/2016
                IF GLReg.FINDFIRST THEN
                 ;
            END;


            if GenJnlTemplate."Posting Report ID" <> 0 then begin
                //GLReg.SetRecFilter();//original code
                // //IF (intEntryFrom > 0) AND (intEntryTo > 0) THEN BEGIN Bobby FDD201 2025/2/14
                // IF (intEntryFrom > 0) THEN BEGIN
                //     GLReg.RESET;
                //     //GLReg.SETFILTER("From Entry No.", '>=' + FORMAT(intEntryFrom));
                //     GLReg.SETFILTER("To Entry No.", '<=' + FORMAT(intEntryTo));
                //     GLReg.SETRANGE("User ID", USERID); // added 8/8/2016
                //     IF GLReg.FINDFIRST THEN;
                // END;
                if GeneralLedgerSetup."Post & Print with Job Queue" then
                    BatchPostingPrintMgt.SchedulePrintJobQueueEntry(GLReg, GenJnlTemplate."Posting Report ID", GeneralLedgerSetup."Report Output Type".AsInteger())
                else
                    //REPORT.Run(GenJnlTemplate."Posting Report ID", false, false, GLReg);
                    REPORT.Run(GenJnlTemplate."Posting Report ID", true, false, GLReg);
                IF GenJournalLine."Journal Template Name" = 'SALES' THEN BEGIN
                    //CustLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No."); //Original Code
                    CustLedgEntry.SETRANGE("Entry No.", intEntryFrom, intEntryTo); //FDD209
                    PrintCustomerReport(CustLedgEntry); // add hcj 11.09

                END
                ELSE BEGIN
                    //VendLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No."); //Original Code
                    VendLedgEntry.SETRANGE("Entry No.", intEntryFrom, intEntryTo);
                    PrintVendorReport(VendLedgEntry); // add hcj 11.09
                END;
            end;
        end;
        IsHandled := true;
    end;
}
