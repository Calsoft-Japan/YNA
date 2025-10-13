codeunit 50010 Eventsubscriber_and_CU227
{
    EventSubscriberInstance = Manual;
    Permissions = TableData "Vendor Ledger Entry" = rimd,
                  Tabledata "G/L Entry" = rimd,
                  Tabledata "G/L Register" = rimd,
                  tabledata "Gen. Journal Line" = rimd;
    TableNo = "Vendor Ledger Entry";

    trigger OnRun()
    var
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
    begin
        if PreviewMode then
            case RunOptionPreviewContext of
                RunOptionPreview::Apply:
                    Apply(Rec, ApplyUnapplyParametersContext);
                RunOptionPreview::Unapply:
                    PostUnApplyVendor(DetailedVendorLedgEntryPreviewContext, ApplyUnapplyParametersContext);
            end
        else begin
            Clear(ApplyUnapplyParameters);
            GLSetup.GetRecordOnce();
            if GLSetup."Journal Templ. Name Mandatory" then begin
                GLSetup.TestField("Apply Jnl. Template Name");
                GLSetup.TestField("Apply Jnl. Batch Name");
                ApplyUnapplyParameters."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
                ApplyUnapplyParameters."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
                GenJnlBatch.Get(GLSetup."Apply Jnl. Template Name", GLSetup."Apply Jnl. Batch Name");
            end;
            ApplyUnapplyParameters."Document No." := Rec."Document No.";

            Apply(Rec, ApplyUnapplyParameters);
        end;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GenJnlBatch: Record "Gen. Journal Batch";
        DetailedVendorLedgEntryPreviewContext: Record "Detailed Vendor Ledg. Entry";
        ApplyUnapplyParametersContext: Record "Apply Unapply Parameters";
        RunOptionPreview: Option Apply,Unapply;
        RunOptionPreviewContext: Option Apply,Unapply;
        PreviewMode: Boolean;

        PostingApplicationMsg: Label 'Posting application...';
        MustNotBeBeforeErr: Label 'The posting date entered must not be before the posting date on the vendor ledger entry.';
        NoEntriesAppliedErr: Label 'Cannot post because you did not specify which entry to apply. You must specify an entry in the %1 field for one or more open entries.', Comment = '%1 - Caption of "Applies to ID" field of Gen. Journal Line';
        UnapplyPostedAfterThisEntryErr: Label 'Before you can unapply this entry, you must first unapply all application entries that were posted after this entry.';
#pragma warning disable AA0470
        NoApplicationEntryErr: Label 'Vendor Ledger Entry No. %1 does not have an application entry.';
#pragma warning restore AA0470
        UnapplyingMsg: Label 'Unapplying and posting...';
#pragma warning disable AA0470
        UnapplyAllPostedAfterThisEntryErr: Label 'Before you can unapply this entry, you must first unapply all application entries in Vendor Ledger Entry No. %1 that were posted after this entry.';
#pragma warning restore AA0470
        NotAllowedPostingDatesErr: Label 'Posting date is not within the range of allowed posting dates.';
#pragma warning disable AA0470
        LatestEntryMustBeApplicationErr: Label 'The latest Transaction No. must be an application in Vendor Ledger Entry No. %1.';
        CannotUnapplyExchRateErr: Label 'You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed.';
        CannotUnapplyInReversalErr: Label 'You cannot unapply Vendor Ledger Entry No. %1 because the entry is part of a reversal.';
#pragma warning restore AA0470
        CannotApplyClosedEntriesErr: Label 'One or more of the entries that you selected is closed. You cannot apply closed entries.';

        //CSV lewis.------
        GLEntryNo: Integer;
        GlobalGLEntry: Record "G/L Entry";
        NextEntryNo: Integer;
        NextTransactionNo: Integer;
        //TransferCustomFields: Codeunit "Transfer Custom Fields";
        BalanceCheckAmount: Decimal;
        BalanceCheckAmount2: Decimal;
        BalanceCheckAddCurrAmount: Decimal;
        BalanceCheckAddCurrAmount2: Decimal;
        TempGLEntryBuf: Record "G/L Entry" TEMPORARY;
        GLReg: Record "G/L Register";
        VATEntry: Record "VAT Entry";
        "Posting Group": Code[10];

    procedure Apply(VendLedgEntry: Record "Vendor Ledger Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters"): Boolean
    var
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        IsHandled: Boolean;
    begin
        OnBeforeApply(VendLedgEntry, ApplyUnapplyParameters."Document No.", ApplyUnapplyParameters."Posting Date");

        IsHandled := false;
        OnApplyOnBeforePmtTolVend(VendLedgEntry, PaymentToleranceMgt, PreviewMode, IsHandled);
        if not IsHandled then
            if not PreviewMode then
                if not PaymentToleranceMgt.PmtTolVend(VendLedgEntry) then
                    exit(false);

        VendLedgEntry.Get(VendLedgEntry."Entry No.");

        if ApplyUnapplyParameters."Posting Date" = 0D then
            ApplyUnapplyParameters."Posting Date" := GetApplicationDate(VendLedgEntry)
        else
            if ApplyUnapplyParameters."Posting Date" < GetApplicationDate(VendLedgEntry) then begin
                IsHandled := false;
                OnApplyOnBeforePostingDateMustNotBeBeforeError(ApplyUnapplyParameters, VendLedgEntry, PreviewMode, IsHandled);
                if not IsHandled then
                    Error(MustNotBeBeforeErr);
            end;

        if ApplyUnapplyParameters."Document No." = '' then
            ApplyUnapplyParameters."Document No." := VendLedgEntry."Document No.";

        OnApplyOnBeforeVendPostApplyVendLedgEntry(VendLedgEntry, ApplyUnapplyParameters);
        VendPostApplyVendLedgEntry(VendLedgEntry, ApplyUnapplyParameters);
        exit(true);
    end;

    procedure GetApplicationDate(VendLedgEntry: Record "Vendor Ledger Entry") ApplicationDate: Date
    var
        ApplyToVendLedgEntry: Record "Vendor Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeGetApplicationDate(VendLedgEntry, ApplicationDate, IsHandled);
        if IsHandled then
            exit(ApplicationDate);

        ApplicationDate := 0D;
        ApplyToVendLedgEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
        ApplyToVendLedgEntry.SetRange("Vendor No.", VendLedgEntry."Vendor No.");
        ApplyToVendLedgEntry.SetRange("Applies-to ID", VendLedgEntry."Applies-to ID");
        OnGetApplicationDateOnAfterSetFilters(ApplyToVendLedgEntry, VendLedgEntry);
        ApplyToVendLedgEntry.FindSet();
        repeat
            if ApplyToVendLedgEntry."Posting Date" > ApplicationDate then
                ApplicationDate := ApplyToVendLedgEntry."Posting Date";
        until ApplyToVendLedgEntry.Next() = 0;
    end;

    local procedure VendPostApplyVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    var
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        Window: Dialog;
        EntryNoBeforeApplication: Integer;
        EntryNoAfterApplication: Integer;
        HideProgressWindow: Boolean;
        SuppressCommit: Boolean;
        IsHandled: Boolean;
        //lewis add-----------
        APVLE: Record "Vendor Ledger Entry";
        entrycount: Integer;
        GLEntry: Record "G/L Entry";
        DetailVLE: Record "Detailed Vendor Ledg. Entry";
        DetailVLE2: Record "Detailed Vendor Ledg. Entry";
        ApplicationNo: Integer;
        Vend: Record Vendor;
        VendpostingGr: Record "Vendor Posting Group";
        GenJnlLine2: Record "Gen. Journal Line";
    begin
        IsHandled := false;
        OnBeforeVendPostApplyVendLedgEntry(HideProgressWindow, VendLedgEntry, IsHandled);
        if IsHandled then
            exit;

        if not HideProgressWindow then
            Window.Open(PostingApplicationMsg);

        SourceCodeSetup.Get();

        GenJnlLine.Init();
        GenJnlLine."Document No." := ApplyUnapplyParameters."Document No.";
        GenJnlLine."Posting Date" := ApplyUnapplyParameters."Posting Date";
        GenJnlLine."Document Date" := GenJnlLine."Posting Date";
        GenJnlLine."VAT Reporting Date" := GenJnlLine."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine."Account No." := VendLedgEntry."Vendor No.";
        VendLedgEntry.CalcFields("Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
        GenJnlLine.Correction :=
            (VendLedgEntry."Debit Amount" < 0) or (VendLedgEntry."Credit Amount" < 0) or
            (VendLedgEntry."Debit Amount (LCY)" < 0) or (VendLedgEntry."Credit Amount (LCY)" < 0);
        GenJnlLine.CopyVendLedgEntry(VendLedgEntry);
        GenJnlLine."Source Code" := SourceCodeSetup."Purchase Entry Application";
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."External Document No." := VendLedgEntry."External Document No.";
        GenJnlLine."Journal Template Name" := ApplyUnapplyParameters."Journal Template Name";
        GenJnlLine."Journal Batch Name" := ApplyUnapplyParameters."Journal Batch Name";

        EntryNoBeforeApplication := FindLastApplDtldVendLedgEntry();

        OnBeforePostApplyVendLedgEntry(GenJnlLine, VendLedgEntry, GenJnlPostLine, ApplyUnapplyParameters);
        GenJnlPostLine.VendPostApplyVendLedgEntry(GenJnlLine, VendLedgEntry);
        OnAfterPostApplyVendLedgEntry(GenJnlLine, VendLedgEntry, GenJnlPostLine);

        EntryNoAfterApplication := FindLastApplDtldVendLedgEntry();


        if PreviewMode then
            GenJnlPostPreview.ThrowError();

        //if EntryNoAfterApplication = EntryNoBeforeApplication then
        //    Error(NoEntriesAppliedErr, GenJnlLine.FieldCaption("Applies-to ID"));

        // comment out by hcj 09/06/2016
        //IF EntryNoAfterApplication = EntryNoBeforeApplication THEN
        //  MESSAGE(NoEntriesAppliedErr + '(Entry No.:'+FORMAT(VendLedgEntry."Entry No.")+')');
        //ERROR(NoEntriesAppliedErr);
        // comment out by hcj 09/06/2016 End

        // if ap/ account no is not empty then using it to change account no.     ---hcj
        //IF DtldVendLedgEntry2."Document Type" = DtldVendLedgEntry2."Document Type"::Payment THEN
        BEGIN

            DetailVLE2.RESET;
            DetailVLE2.SETRANGE("Entry No.", EntryNoAfterApplication);
            DetailVLE2.SETRANGE("Document Type", DetailVLE."Document Type"::Payment);
            IF DetailVLE2.FIND('-') THEN BEGIN
                ApplicationNo := DetailVLE2."Application No.";
                DetailVLE.RESET;
                DetailVLE.SETCURRENTKEY("Initial Document Type", "Entry Type", "Vendor No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Posting Date");
                // DetailVLE.SETRANGE("Application No.", ApplicationNo);

                IF DetailVLE2."Transaction No." = 0 THEN BEGIN
                    DetailVLE.SETRANGE("Application No.", DetailVLE2."Application No.");
                END ELSE BEGIN
                    DetailVLE.SETRANGE("Transaction No.", DetailVLE2."Transaction No.");
                END;
                DetailVLE.SETFILTER(DetailVLE."Applied Vend. Ledger Entry No.", '<>0');

                IF DetailVLE.FIND('-') THEN BEGIN
                    REPEAT
                        APVLE.RESET;
                        APVLE.SETRANGE("Entry No.", DetailVLE."Vendor Ledger Entry No.");
                        IF APVLE.FIND('-') THEN BEGIN
                            //  TempGLEntryBuf.DELETEALL();
                            IF (APVLE."Entry No." = VendLedgEntry."Entry No.") THEN BEGIN
                                WITH APVLE DO BEGIN

                                    GenJnlLine2.RESET;
                                    GenJnlLine2.INIT;
                                    GenJnlLine2."Posting Date" := ApplyUnapplyParameters."Posting Date";

                                    CALCFIELDS(APVLE.Amount);
                                    CALCFIELDS(APVLE."Amount (LCY)");
                                    CALCFIELDS(APVLE."Remaining Amt. (LCY)");
                                    CALCFIELDS(APVLE."Original Amt. (LCY)");
                                    CopyVLEtoGenJnlLine(APVLE, GenJnlLine2);
                                    GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                                    IF APVLE."AP Account No." <> '' THEN
                                        GenJnlLine2."Account No." := APVLE."AP Account No.";

                                    GenJnlLine2."Source Line No." := APVLE."Entry No.";
                                    IF APVLE."Entry No." = VendLedgEntry."Entry No." THEN BEGIN
                                        Vend.GET(APVLE."Vendor No.");
                                        Vend.CheckBlockedVendOnJnls(Vend, "Document Type", TRUE);

                                        IF "Posting Group" = '' THEN BEGIN
                                            Vend.TESTFIELD("Vendor Posting Group");
                                            "Posting Group" := Vend."Vendor Posting Group";
                                        END;
                                        VendpostingGr.GET("Posting Group");
                                        GenJnlLine2."Account No." := VendpostingGr.GetPayablesAccount;

                                        GenJnlLine2."System-Created Entry" := TRUE;
                                        GenJnlLine2."Source Line No." := 0;

                                    END;

                                    //IF DetailVLE."Entry Type" = DetailVLE."Entry Type"::"Payment Discount" THEN
                                    BEGIN
                                        GenJnlLine2.Amount := DetailVLE.Amount;
                                        GenJnlLine2."Amount (LCY)" := DetailVLE."Amount (LCY)";
                                    END
                                    //   ELSE
                                    //   BEGIN
                                    //     GenJnlLine2.Amount := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                    //     GenJnlLine2."Amount (LCY)" := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                    //   END;
                                END;

                            END;

                            IF (APVLE."AP Account No." <> '') OR (APVLE."Entry No." = VendLedgEntry."Entry No.") THEN BEGIN
                                WITH APVLE DO BEGIN
                                    GenJnlLine2."Posting Date" := ApplyUnapplyParameters."Posting Date";
                                    CALCFIELDS(APVLE.Amount);
                                    CALCFIELDS(APVLE."Amount (LCY)");
                                    CALCFIELDS(APVLE."Remaining Amt. (LCY)");
                                    CALCFIELDS(APVLE."Original Amt. (LCY)");
                                    GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                                    IF APVLE."AP Account No." <> '' THEN
                                        GenJnlLine2."Account No." := APVLE."AP Account No.";

                                    GenJnlLine2."Source Line No." := APVLE."Entry No.";
                                    //  IF DetailVLE."Entry Type" = DetailVLE."Entry Type"::"Payment Discount" THEN
                                    //  BEGIN
                                    GenJnlLine2.Amount := DetailVLE.Amount;
                                    GenJnlLine2."Amount (LCY)" := DetailVLE."Amount (LCY)";
                                    //   END
                                    //   ELSE
                                    //   BEGIN
                                    //     GenJnlLine2.Amount := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                    //     GenJnlLine2."Amount (LCY)" := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                    //   END;


                                    PostGLAcc(GenJnlLine2);
                                END;
                                //COMMIT;
                            END;


                        END;
                    UNTIL DetailVLE.NEXT = 0;
                    FinishPosting();
                    COMMIT;
                END;
            END;
        END;



        SuppressCommit := false;
        OnVendPostApplyVendLedgEntryOnBeforeCommit(VendLedgEntry, SuppressCommit);
        if not SuppressCommit then
            Commit();
        if not HideProgressWindow then
            Window.Close();
        RunUpdateAnalysisView();
    end;

    local procedure RunUpdateAnalysisView()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeRunUpdateAnalysisView(IsHandled);
        if IsHandled then
            exit;

        UpdateAnalysisView.UpdateAll(0, true);
    end;

    local procedure FindLastApplDtldVendLedgEntry(): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.LockTable();
        exit(DtldVendLedgEntry.GetLastEntryNo());
    end;

    procedure FindLastApplEntry(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        ApplicationEntryNo: Integer;
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SetRange("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
        DtldVendLedgEntry.SetRange(Unapplied, false);
        OnFindLastApplEntryOnAfterSetFilters(DtldVendLedgEntry);
        ApplicationEntryNo := 0;
        if DtldVendLedgEntry.Find('-') then
            repeat
                if DtldVendLedgEntry."Entry No." > ApplicationEntryNo then
                    ApplicationEntryNo := DtldVendLedgEntry."Entry No.";
            until DtldVendLedgEntry.Next() = 0;
        exit(ApplicationEntryNo);
    end;

    local procedure FindLastTransactionNo(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SetRange(Unapplied, false);
        DtldVendLedgEntry.SetFilter(
            "Entry Type", '<>%1&<>%2',
            DtldVendLedgEntry."Entry Type"::"Unrealized Loss", DtldVendLedgEntry."Entry Type"::"Unrealized Gain");
        LastTransactionNo := 0;
        if DtldVendLedgEntry.FindSet() then
            repeat
                if LastTransactionNo < DtldVendLedgEntry."Transaction No." then
                    LastTransactionNo := DtldVendLedgEntry."Transaction No.";
            until DtldVendLedgEntry.Next() = 0;
        exit(LastTransactionNo);
    end;

    procedure UnApplyDtldVendLedgEntry(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        ApplicationEntryNo: Integer;
    begin
        DtldVendLedgEntry.TestField("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
        DtldVendLedgEntry.TestField(Unapplied, false);
        ApplicationEntryNo := FindLastApplEntry(DtldVendLedgEntry."Vendor Ledger Entry No.");

        if DtldVendLedgEntry."Entry No." <> ApplicationEntryNo then
            Error(UnapplyPostedAfterThisEntryErr);
        CheckReversal(DtldVendLedgEntry."Vendor Ledger Entry No.");
        UnApplyVendor(DtldVendLedgEntry);
    end;

    procedure UnApplyVendLedgEntry(VendLedgEntryNo: Integer)
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        CheckVendorLedgerEntryToUnapply(VendLedgEntryNo, DtldVendLedgEntry);
        UnApplyVendor(DtldVendLedgEntry);
    end;

    procedure CheckVendorLedgerEntryToUnapply(VendorLedgerEntryNo: Integer; var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        ApplicationEntryNo: Integer;
    begin
        CheckReversal(VendorLedgerEntryNo);
        ApplicationEntryNo := FindLastApplEntry(VendorLedgerEntryNo);
        if ApplicationEntryNo = 0 then
            Error(NoApplicationEntryErr, VendorLedgerEntryNo);
        DetailedVendorLedgEntry.Get(ApplicationEntryNo);
    end;

    local procedure UnApplyVendor(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        UnapplyVendEntries: Page "Unapply Vendor Entries";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUnApplyVendor(DtldVendLedgEntry, IsHandled);
        if not IsHandled then begin
            DtldVendLedgEntry.TestField("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
            DtldVendLedgEntry.TestField(Unapplied, false);
            UnapplyVendEntries.SetDtldVendLedgEntry(DtldVendLedgEntry."Entry No.");
            UnapplyVendEntries.LookupMode(true);
            UnapplyVendEntries.RunModal();
        end;

        OnAfterUnApplyVendor(DtldVendLedgEntry);
    end;

    procedure PostUnApplyVendor(DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    begin
        PostUnApplyVendorCommit(DtldVendLedgEntry2, ApplyUnapplyParameters, true);
    end;

    procedure PostUnApplyVendorCommit(DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters"; CommitChanges: Boolean)
    var
        GLEntry: Record "G/L Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        DateComprReg: Record "Date Compr. Register";
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        Window: Dialog;
        AddCurrChecked: Boolean;
        MaxPostingDate: Date;
        HideProgressWindow: Boolean;
        IsHandled: Boolean;

        //lewis add---------
        GenJnlLine2: Record "Gen. Journal Line";
        APVLE: Record "Vendor Ledger Entry";
        entrycount: Integer;
        DetailVLE: Record "Detailed Vendor Ledg. Entry";
        ApplicationNo: Integer;
        Vend: Record Vendor;
        VendpostingGr: Record "Vendor Posting Group";
    begin
        IsHandled := false;
        OnBeforePostUnApplyVendorCommit(
            HideProgressWindow, PreviewMode, DtldVendLedgEntry2, ApplyUnapplyParameters."Document No.", ApplyUnapplyParameters."Posting Date",
            CommitChanges, IsHandled);
        if IsHandled then
            exit;

        MaxPostingDate := 0D;
        GLEntry.LockTable();
        DtldVendLedgEntry.LockTable();
        VendLedgEntry.LockTable();
        VendLedgEntry.Get(DtldVendLedgEntry2."Vendor Ledger Entry No.");
        OnPostUnApplyVendorOnAfterGetVendLedgEntry(VendLedgEntry);
        if GenJnlBatch.Get(VendLedgEntry."Journal Templ. Name", VendLedgEntry."Journal Batch Name") then;
        CheckPostingDate(ApplyUnapplyParameters, MaxPostingDate);
        if ApplyUnapplyParameters."Posting Date" < DtldVendLedgEntry2."Posting Date" then begin
            IsHandled := false;
            OnPostUnApplyVendorCommitOnBeforePostingDateMustNotBeBeforeError(ApplyUnapplyParameters, DtldVendLedgEntry2, PreviewMode, IsHandled);
            if not IsHandled then
                Error(MustNotBeBeforeErr);
        end;

        OnPostUnApplyVendorCommitOnBeforeFilterDtldVendLedgEntry(DtldVendLedgEntry2, ApplyUnapplyParameters);
        if DtldVendLedgEntry2."Transaction No." = 0 then begin
            DtldVendLedgEntry.SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SetRange("Application No.", DtldVendLedgEntry2."Application No.");
        end else begin
            DtldVendLedgEntry.SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SetRange("Transaction No.", DtldVendLedgEntry2."Transaction No.");
        end;
        DtldVendLedgEntry.SetRange("Vendor No.", DtldVendLedgEntry2."Vendor No.");
        DtldVendLedgEntry.SetFilter("Entry Type", '<>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
        DtldVendLedgEntry.SetRange(Unapplied, false);
        OnPostUnApplyVendorOnAfterDtldVendLedgEntrySetFilters(DtldVendLedgEntry, DtldVendLedgEntry2);
        if DtldVendLedgEntry.Find('-') then
            repeat
                if not AddCurrChecked then begin
                    CheckAdditionalCurrency(ApplyUnapplyParameters."Posting Date", DtldVendLedgEntry."Posting Date");
                    AddCurrChecked := true;
                end;
                CheckReversal(DtldVendLedgEntry."Vendor Ledger Entry No.");
                if DtldVendLedgEntry."Transaction No." <> 0 then
                    CheckUnappliedEntries(DtldVendLedgEntry);
            until DtldVendLedgEntry.Next() = 0;

        DateComprReg.CheckMaxDateCompressed(MaxPostingDate, 0);

        GLSetup.GetRecordOnce();
        SourceCodeSetup.Get();
        VendLedgEntry.Get(DtldVendLedgEntry2."Vendor Ledger Entry No.");
        GenJnlLine."Document No." := ApplyUnapplyParameters."Document No.";
        GenJnlLine."Posting Date" := ApplyUnapplyParameters."Posting Date";
        GenJnlLine."VAT Reporting Date" := GenJnlLine."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine."Account No." := DtldVendLedgEntry2."Vendor No.";
        GenJnlLine.Correction := true;
        GenJnlLine.CopyVendLedgEntry(VendLedgEntry);
        GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Purch. Entry Appln.";
        GenJnlLine."Source Currency Code" := DtldVendLedgEntry2."Currency Code";
        GenJnlLine."System-Created Entry" := true;
        if GLSetup."Journal Templ. Name Mandatory" then begin
            GenJnlLine."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
            GenJnlLine."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
        end;
        if not HideProgressWindow then
            Window.Open(UnapplyingMsg);

        OnBeforePostUnapplyVendLedgEntry(GenJnlLine, VendLedgEntry, DtldVendLedgEntry2, GenJnlPostLine, ApplyUnapplyParameters);
        CollectAffectedLedgerEntries(TempVendorLedgerEntry, DtldVendLedgEntry2);
        GenJnlPostLine.UnapplyVendLedgEntry(GenJnlLine, DtldVendLedgEntry2);
        RunVendExchRateAdjustment(GenJnlLine, TempVendorLedgerEntry);
        OnAfterPostUnapplyVendLedgEntry(
            GenJnlLine, VendLedgEntry, DtldVendLedgEntry2, GenJnlPostLine, TempVendorLedgerEntry);

        if PreviewMode then
            GenJnlPostPreview.ThrowError();

        //hcj

        // if ap/ account no is not empty then using it to change account no.     ---hcj
        IF DtldVendLedgEntry2."Document Type" = DtldVendLedgEntry2."Document Type"::Payment THEN BEGIN
            DetailVLE.RESET;
            DetailVLE.SETRANGE("Entry No.", DtldVendLedgEntry2."Entry No.");
            IF DetailVLE.FIND('-') THEN BEGIN
                ApplicationNo := DetailVLE."Applied Vend. Ledger Entry No.";
                DetailVLE.RESET;
                DetailVLE.SETRANGE("Applied Vend. Ledger Entry No.", ApplicationNo);
                IF DtldVendLedgEntry2."Transaction No." = 0 THEN BEGIN
                    DetailVLE.SETCURRENTKEY("Application No.", "Vendor No.", "Entry Type");
                    DetailVLE.SETRANGE("Application No.", DtldVendLedgEntry2."Application No.");
                END ELSE BEGIN
                    DetailVLE.SETCURRENTKEY("Transaction No.", "Vendor No.", "Entry Type");
                    DetailVLE.SETRANGE("Transaction No.", DtldVendLedgEntry2."Transaction No.");
                END;

                DetailVLE.SETCURRENTKEY("Initial Document Type", "Entry Type", "Vendor No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Posting Date");
                IF DetailVLE.FIND('-') THEN BEGIN
                    REPEAT
                        APVLE.RESET;
                        APVLE.SETRANGE("Entry No.", DetailVLE."Vendor Ledger Entry No.");
                        IF APVLE.FIND('-') THEN BEGIN
                            IF (APVLE."Entry No." = VendLedgEntry."Entry No.") THEN BEGIN
                                WITH APVLE DO BEGIN

                                    GenJnlLine2.RESET;
                                    GenJnlLine2.INIT;
                                    //CALCFIELDS(APVLE.Amount);
                                    //CALCFIELDS(APVLE."Remaining Amt. (LCY)");
                                    //CALCFIELDS(APVLE."Original Amt. (LCY)");
                                    CopyVLEtoGenJnlLine(APVLE, GenJnlLine2);
                                    GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                                    IF APVLE."AP Account No." <> '' THEN
                                        GenJnlLine2."Account No." := APVLE."AP Account No.";

                                    GenJnlLine2."Source Line No." := APVLE."Entry No.";
                                    IF APVLE."Entry No." = VendLedgEntry."Entry No." THEN BEGIN
                                        Vend.GET(APVLE."Vendor No.");
                                        Vend.CheckBlockedVendOnJnls(Vend, "Document Type", TRUE);

                                        IF "Posting Group" = '' THEN BEGIN
                                            Vend.TESTFIELD("Vendor Posting Group");
                                            "Posting Group" := Vend."Vendor Posting Group";
                                        END;
                                        VendpostingGr.GET("Posting Group");
                                        GenJnlLine2."Account No." := VendpostingGr.GetPayablesAccount;

                                        GenJnlLine2."Source Type" := GenJnlLine."Source Type"::Vendor;
                                        GenJnlLine2."Source No." := "Vendor No.";
                                        GenJnlLine2."Source Code" := SourceCodeSetup."Purchase Entry Application";
                                        GenJnlLine2."System-Created Entry" := TRUE;
                                        GenJnlLine2."Source Line No." := 0;

                                    END;
                                    GenJnlLine2.Amount := DetailVLE.Amount * -1;
                                    GenJnlLine2."Amount (LCY)" := DetailVLE."Amount (LCY)" * -1;


                                END;
                                //  COMMIT;
                            END;


                            IF (APVLE."AP Account No." <> '') OR (APVLE."Entry No." = VendLedgEntry."Entry No.") THEN BEGIN
                                //                  CopyVLEtoGenJnlLine(APVLE,GenJnlLine2);
                                GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                                IF APVLE."AP Account No." <> '' THEN
                                    GenJnlLine2."Account No." := APVLE."AP Account No.";

                                GenJnlLine2.Amount := DetailVLE.Amount * -1;
                                GenJnlLine2."Amount (LCY)" := DetailVLE."Amount (LCY)" * -1;

                                PostGLAcc(GenJnlLine2);
                                //  COMMIT;
                            END;


                        END;
                    UNTIL DetailVLE.NEXT = 0;
                    FinishPosting();
                    COMMIT;
                END;
            END;
        END;  //the end of if payment
              //FDD210 End hcj


        if CommitChanges then
            Commit();
        if not HideProgressWindow then
            Window.Close();
    end;

    local procedure RunVendExchRateAdjustment(var GenJnlLine: Record "Gen. Journal Line"; var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary)
    var
        ExchRateAdjmtRunHandler: Codeunit "Exch. Rate Adjmt. Run Handler";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeRunVendExchRateAdjustment(GenJnlLine, TempVendorLedgerEntry, IsHandled);
        if IsHandled then
            exit;

        ExchRateAdjmtRunHandler.RunVendExchRateAdjustment(GenJnlLine, TempVendorLedgerEntry);
    end;

    local procedure CheckPostingDate(ApplyUnapplyParameters: Record "Apply Unapply Parameters"; var MaxPostingDate: Date)
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        GenJnlCheckLine.SetGenJnlBatch(GenJnlBatch);
        if GenJnlCheckLine.DateNotAllowed(ApplyUnapplyParameters."Posting Date") then
            Error(NotAllowedPostingDatesErr);

        if ApplyUnapplyParameters."Posting Date" > MaxPostingDate then
            MaxPostingDate := ApplyUnapplyParameters."Posting Date";
    end;

    local procedure CheckAdditionalCurrency(OldPostingDate: Date; NewPostingDate: Date)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if OldPostingDate = NewPostingDate then
            exit;
        GLSetup.GetRecordOnce();
        if GLSetup."Additional Reporting Currency" <> '' then
            if CurrExchRate.ExchangeRate(OldPostingDate, GLSetup."Additional Reporting Currency") <>
               CurrExchRate.ExchangeRate(NewPostingDate, GLSetup."Additional Reporting Currency")
            then
                Error(CannotUnapplyExchRateErr, NewPostingDate);
    end;

    procedure CheckReversal(VendLedgEntryNo: Integer)
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.Get(VendLedgEntryNo);
        if VendLedgEntry.Reversed then
            Error(CannotUnapplyInReversalErr, VendLedgEntryNo);
        OnAfterCheckReversal(VendLedgEntry);
    end;

    procedure ApplyVendEntryFormEntry(var ApplyingVendLedgEntry: Record "Vendor Ledger Entry")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendEntryApplID: Code[50];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeApplyVendEntryFormEntry(ApplyingVendLedgEntry, IsHandled);
        if IsHandled then
            exit;

        if not ApplyingVendLedgEntry.Open then
            Error(CannotApplyClosedEntriesErr);

        OnApplyVendEntryFormEntryOnAfterCheckEntryOpen(ApplyingVendLedgEntry);

        VendEntryApplID := UserId;
        if VendEntryApplID = '' then
            VendEntryApplID := '***';
        if ApplyingVendLedgEntry."Remaining Amount" = 0 then
            ApplyingVendLedgEntry.CalcFields("Remaining Amount");

        ApplyingVendLedgEntry."Applying Entry" := true;
        if ApplyingVendLedgEntry."Applies-to ID" = '' then
            ApplyingVendLedgEntry."Applies-to ID" := VendEntryApplID;
        ApplyingVendLedgEntry."Amount to Apply" := ApplyingVendLedgEntry."Remaining Amount";
        OnApplyVendEntryFormEntryOnBeforeRunVendEntryEdit(ApplyingVendLedgEntry);
        CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", ApplyingVendLedgEntry);
        Commit();

        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
        VendLedgEntry.SetRange("Vendor No.", ApplyingVendLedgEntry."Vendor No.");
        VendLedgEntry.SetRange(Open, true);
        //FDD210  ApplyingVendLedgEntry is Invoice and Credit memo can't apply to Payment
        IF (ApplyingVendLedgEntry."Document Type" = ApplyingVendLedgEntry."Document Type"::Invoice)
           OR (ApplyingVendLedgEntry."Document Type" = ApplyingVendLedgEntry."Document Type"::"Credit Memo") THEN
            VendLedgEntry.SETFILTER("Document Type", '<>Payment');

        IF ApplyingVendLedgEntry."Document Type" = ApplyingVendLedgEntry."Document Type"::Payment THEN
            VendLedgEntry.SETFILTER("Document Type", '<>Payment&<>Refund');
        //FDD210 end

        RunApplyVendEntries(VendLedgEntry, ApplyingVendLedgEntry, VendEntryApplID);
    end;

    local procedure RunApplyVendEntries(var VendLedgEntry: Record "Vendor Ledger Entry"; var ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; VendEntryApplID: Code[50])
    var
        ApplyVendEntries: Page "Apply Vendor Entries";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnApplyVendEntryFormEntryOnAfterVendLedgEntrySetFilters(VendLedgEntry, ApplyingVendLedgEntry, IsHandled, VendEntryApplID);
        if IsHandled then
            exit;

        if VendLedgEntry.FindFirst() then begin
            ApplyVendEntries.SetVendLedgEntry(ApplyingVendLedgEntry);
            ApplyVendEntries.SetRecord(VendLedgEntry);
            ApplyVendEntries.SetTableView(VendLedgEntry);
            if ApplyingVendLedgEntry."Applies-to ID" <> VendEntryApplID then
                ApplyVendEntries.SetAppliesToID(ApplyingVendLedgEntry."Applies-to ID");
            ApplyVendEntries.RunModal();
            Clear(ApplyVendEntries);
            ApplyingVendLedgEntry."Applying Entry" := false;
            ApplyingVendLedgEntry."Applies-to ID" := '';
            ApplyingVendLedgEntry."Amount to Apply" := 0;
        end;
    end;

    local procedure CollectAffectedLedgerEntries(var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry")
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        TempVendorLedgerEntry.DeleteAll();

        if DetailedVendorLedgEntry2."Transaction No." = 0 then begin
            DetailedVendorLedgEntry.SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
            DetailedVendorLedgEntry.SetRange("Application No.", DetailedVendorLedgEntry2."Application No.");
        end else begin
            DetailedVendorLedgEntry.SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
            DetailedVendorLedgEntry.SetRange("Transaction No.", DetailedVendorLedgEntry2."Transaction No.");
        end;
        DetailedVendorLedgEntry.SetRange("Vendor No.", DetailedVendorLedgEntry2."Vendor No.");
        DetailedVendorLedgEntry.SetFilter("Entry Type", '<>%1', DetailedVendorLedgEntry."Entry Type"::"Initial Entry");
        DetailedVendorLedgEntry.SetRange(Unapplied, false);
        OnCollectAffectedLedgerEntriesOnAfterSetFilters(DetailedVendorLedgEntry, DetailedVendorLedgEntry2);
        if DetailedVendorLedgEntry.FindSet() then
            repeat
                TempVendorLedgerEntry."Entry No." := DetailedVendorLedgEntry."Vendor Ledger Entry No.";
                if TempVendorLedgerEntry.Insert() then;
            until DetailedVendorLedgEntry.Next() = 0;
    end;

    local procedure FindLastApplTransactionEntry(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SetRange("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
        LastTransactionNo := 0;
        if DtldVendLedgEntry.Find('-') then
            repeat
                if (DtldVendLedgEntry."Transaction No." > LastTransactionNo) and not DtldVendLedgEntry.Unapplied then
                    LastTransactionNo := DtldVendLedgEntry."Transaction No.";
            until DtldVendLedgEntry.Next() = 0;
        exit(LastTransactionNo);
    end;

    procedure PreviewApply(VendorLedgerEntry: Record "Vendor Ledger Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        VendEntryApplyPostedEntries: Codeunit "Eventsubscriber_and_CU227";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    begin
        if not PaymentToleranceMgt.PmtTolVend(VendorLedgerEntry) then
            exit;

        BindSubscription(VendEntryApplyPostedEntries);
        VendEntryApplyPostedEntries.SetApplyContext(ApplyUnapplyParameters);
        GenJnlPostPreview.Preview(VendEntryApplyPostedEntries, VendorLedgerEntry);
    end;

    procedure PreviewUnapply(DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        VendEntryApplyPostedEntries: Codeunit "Eventsubscriber_and_CU227";
    begin
        BindSubscription(VendEntryApplyPostedEntries);
        VendEntryApplyPostedEntries.SetUnapplyContext(DetailedVendorLedgEntry, ApplyUnapplyParameters);
        GenJnlPostPreview.Preview(VendEntryApplyPostedEntries, VendorLedgerEntry);
    end;

    procedure SetApplyContext(ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    begin
        ApplyUnapplyParametersContext := ApplyUnapplyParameters;
        RunOptionPreviewContext := RunOptionPreview::Apply;
    end;

    procedure SetUnapplyContext(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    begin
        ApplyUnapplyParametersContext := ApplyUnapplyParameters;
        DetailedVendorLedgEntryPreviewContext := DetailedVendorLedgEntry;
        RunOptionPreviewContext := RunOptionPreview::Unapply;
    end;

    procedure GetAppliedVendLedgerEntries(var TempAppliedVendLedgerEntry: Record "Vendor Ledger Entry" temporary; VendLedgerEntryNo: Integer)
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        ApplnDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgerEntryNo);
        DtldVendLedgEntry.SetFilter("Applied Vend. Ledger Entry No.", '<>%1', 0);
        DtldVendLedgEntry.SetRange(Unapplied, false);
        if DtldVendLedgEntry.FindSet() then
            repeat
                if DtldVendLedgEntry."Vendor Ledger Entry No." =
                   DtldVendLedgEntry."Applied Vend. Ledger Entry No."
                then begin
                    ApplnDtldVendLedgEntry.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    ApplnDtldVendLedgEntry.SetRange(
                        "Applied Vend. Ledger Entry No.", DtldVendLedgEntry."Applied Vend. Ledger Entry No.");
                    ApplnDtldVendLedgEntry.SetRange("Entry Type", ApplnDtldVendLedgEntry."Entry Type"::Application);
                    ApplnDtldVendLedgEntry.SetRange(Unapplied, false);
                    if ApplnDtldVendLedgEntry.FindSet() then
                        repeat
                            if ApplnDtldVendLedgEntry."Vendor Ledger Entry No." <>
                               ApplnDtldVendLedgEntry."Applied Vend. Ledger Entry No."
                            then
                                if VendLedgerEntry.Get(ApplnDtldVendLedgEntry."Vendor Ledger Entry No.") then begin
                                    TempAppliedVendLedgerEntry := VendLedgerEntry;
                                    if TempAppliedVendLedgerEntry.Insert(false) then;
                                end;
                        until ApplnDtldVendLedgEntry.Next() = 0;
                end else
                    if VendLedgerEntry.Get(DtldVendLedgEntry."Applied Vend. Ledger Entry No.") then begin
                        TempAppliedVendLedgerEntry := VendLedgerEntry;
                        if TempAppliedVendLedgerEntry.Insert(false) then;
                    end;
            until DtldVendLedgEntry.Next() = 0;
    end;

    local procedure CheckUnappliedEntries(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        LastTransactionNo: Integer;
        IsHandled: Boolean;
    begin
        if DtldVendLedgEntry."Entry Type" = DtldVendLedgEntry."Entry Type"::Application then begin
            LastTransactionNo := FindLastApplTransactionEntry(DtldVendLedgEntry."Vendor Ledger Entry No.");
            IsHandled := false;
            OnCheckUnappliedEntriesOnBeforeUnapplyAllEntriesError(DtldVendLedgEntry, LastTransactionNo, IsHandled);
            if not IsHandled then
                if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") then
                    Error(UnapplyAllPostedAfterThisEntryErr, DtldVendLedgEntry."Vendor Ledger Entry No.");
        end;
        LastTransactionNo := FindLastTransactionNo(DtldVendLedgEntry."Vendor Ledger Entry No.");
        if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") then
            Error(LatestEntryMustBeApplicationErr, DtldVendLedgEntry."Vendor Ledger Entry No.");
    end;


    LOCAL PROCEDURE PostGLAcc(GenJnlLine: Record "Gen. Journal Line");
    VAR
        GLAcc: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        VATPostingSetup: Record "VAT Posting Setup";
    BEGIN
        GLAcc.GET(GenJnlLine."Account No.");
        // G/L entry
        InitGLEntry(GenJnlLine, GLEntry,
          GenJnlLine."Account No.", GenJnlLine."Amount (LCY)",
          GenJnlLine."Source Currency Amount", TRUE, GenJnlLine."System-Created Entry");
        GLEntry."Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
        GLEntry."No. Series" := GenJnlLine."Posting No. Series";
        IF GenJnlLine."Additional-Currency Posting" =
           GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only"
        THEN BEGIN
            GLEntry."Additional-Currency Amount" := GenJnlLine.Amount;
            GLEntry.Amount := 0;
        END;
        // Store Entry No. to global variable for return:
        //InitVAT(GenJnlLine,GLEntry,VATPostingSetup);
        // CS1.0 FDD209 sync the addition fields
        GLEntry."Voucher Group Code" := GenJnlLine."Voucher Group Code";
        GLEntry."System Code" := GenJnlLine."System Code";
        // CS1.0 sync end.
        IF (GLEntry.Amount <> 0) OR (GLEntry."Additional-Currency Amount" <> 0) OR
           (GenJnlLine."VAT Calculation Type" <> GenJnlLine."VAT Calculation Type"::"Sales Tax")
        THEN BEGIN
            InsertGLEntry(GenJnlLine, GLEntry, TRUE);
            //PostJob(GenJnlLine,GLEntry);
            //PostVAT(GenJnlLine,GLEntry,VATPostingSetup);
            //FinishPosting();
        END;
    END;

    LOCAL PROCEDURE InitGLEntry(GenJnlLine: Record "Gen. Journal Line"; VAR GLEntry: Record "G/L Entry"; GLAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean; SystemCreatedEntry: Boolean);
    VAR
        GLAcc: Record "G/L Account";
    BEGIN

        GlobalGLEntry.LOCKTABLE;

        IF GlobalGLEntry.FINDLAST THEN BEGIN
            IF NextEntryNo <= (GlobalGLEntry."Entry No." + 1) THEN BEGIN
                NextEntryNo := GlobalGLEntry."Entry No." + 1;
                NextTransactionNo := GlobalGLEntry."Transaction No." + 1;
                GLEntryNo := GlobalGLEntry."Entry No." + 1;
            END
        END ELSE BEGIN
            NextEntryNo := 1;
            NextTransactionNo := 1;
            GLEntryNo := 1;
        END;


        IF GLAccNo <> '' THEN BEGIN
            GLAcc.GET(GLAccNo);
            GLAcc.TESTFIELD(Blocked, FALSE);
            GLAcc.TESTFIELD("Account Type", GLAcc."Account Type"::Posting);

        END;

        GLEntry.INIT;
        GLEntry.CopyFromGenJnlLine(GenJnlLine);
        GLEntry."Entry No." := NextEntryNo;
        GLEntry."Transaction No." := NextTransactionNo;
        GLEntry."G/L Account No." := GLAccNo;
        GLEntry."System-Created Entry" := SystemCreatedEntry;
        GLEntry.Amount := Amount;
        GLEntry."GST/HST" := GenJnlLine."GST/HST";
        GLEntry."STE Transaction ID" := GenJnlLine."STE Transaction ID";
        GLEntry.CopyFromGenJnlLine(GenJnlLine);
        //.GenJnlLineTOGenLedgEntry(GenJnlLine, GLEntry);
        //GLEntry."Additional-Currency Amount" :=
        //  GLCalcAddCurrency(Amount,AmountAddCurr,GLEntry."Additional-Currency Amount",UseAmountAddCurr,GenJnlLine);
    END;

    PROCEDURE InsertGLEntry(GenJnlLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; CalcAddCurrResiduals: Boolean);
    BEGIN
        GLEntry.TESTFIELD("G/L Account No.");


        UpdateCheckAmounts(
          GLEntry."Posting Date", GLEntry.Amount, GLEntry."Additional-Currency Amount",
          BalanceCheckAmount, BalanceCheckAmount2, BalanceCheckAddCurrAmount, BalanceCheckAddCurrAmount2);

        GLEntry.UpdateDebitCredit(GenJnlLine.Correction);

        TempGLEntryBuf := GLEntry;
        TempGLEntryBuf.INSERT;

        NextEntryNo := NextEntryNo + 1;
    END;

    LOCAL PROCEDURE UpdateCheckAmounts(PostingDate: Date; Amount: Decimal; AddCurrAmount: Decimal; VAR BalanceCheckAmount: Decimal; VAR BalanceCheckAmount2: Decimal; VAR BalanceCheckAddCurrAmount: Decimal; VAR BalanceCheckAddCurrAmount2: Decimal);
    BEGIN
        IF PostingDate = NORMALDATE(PostingDate) THEN BEGIN
            BalanceCheckAmount :=
              BalanceCheckAmount + Amount * ((PostingDate - 00000101D) MOD 99 + 1);
            BalanceCheckAmount2 :=
              BalanceCheckAmount2 + Amount * ((PostingDate - 00000101D) MOD 98 + 1);
        END ELSE BEGIN
            BalanceCheckAmount :=
              BalanceCheckAmount + Amount * ((NORMALDATE(PostingDate) - 00000101D + 50) MOD 99 + 1);
            BalanceCheckAmount2 :=
              BalanceCheckAmount2 + Amount * ((NORMALDATE(PostingDate) - 00000101D + 50) MOD 98 + 1);
        END;


        IF PostingDate = NORMALDATE(PostingDate) THEN BEGIN
            BalanceCheckAddCurrAmount :=
              BalanceCheckAddCurrAmount + AddCurrAmount * ((PostingDate - 00000101D) MOD 99 + 1);
            BalanceCheckAddCurrAmount2 :=
              BalanceCheckAddCurrAmount2 + AddCurrAmount * ((PostingDate - 00000101D) MOD 98 + 1);
        END ELSE BEGIN
            BalanceCheckAddCurrAmount :=
              BalanceCheckAddCurrAmount +
              AddCurrAmount * ((NORMALDATE(PostingDate) - 00000101D + 50) MOD 99 + 1);
            BalanceCheckAddCurrAmount2 :=
              BalanceCheckAddCurrAmount2 +
              AddCurrAmount * ((NORMALDATE(PostingDate) - 00000101D + 50) MOD 98 + 1);
        END
    END;

    PROCEDURE CopyVLEtoGenJnlLine(VLE: Record "Vendor Ledger Entry"; VAR GenJnlLine: Record "Gen. Journal Line");
    BEGIN
        GenJnlLine."Account No." := VLE."Vendor No.";
        GenJnlLine."Posting Date" := VLE."Posting Date";
        GenJnlLine."Document Date" := VLE."Document Date";
        GenJnlLine."Document Type" := VLE."Document Type";
        GenJnlLine."Document No." := VLE."Document No.";
        GenJnlLine."External Document No." := VLE."External Document No.";
        GenJnlLine.Description := VLE.Description;
        GenJnlLine."Currency Code" := VLE."Currency Code";
        GenJnlLine."Sales/Purch. (LCY)" := VLE."Purchase (LCY)";
        GenJnlLine."Inv. Discount (LCY)" := VLE."Inv. Discount (LCY)";
        GenJnlLine."Sell-to/Buy-from No." := VLE."Buy-from Vendor No.";
        GenJnlLine."Posting Group" := VLE."Vendor Posting Group";
        GenJnlLine."Shortcut Dimension 1 Code" := VLE."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := VLE."Global Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := VLE."Dimension Set ID";
        GenJnlLine."Salespers./Purch. Code" := VLE."Purchaser Code";
        GenJnlLine."Source Code" := VLE."Source Code";
        GenJnlLine."On Hold" := VLE."On Hold";
        GenJnlLine."Applies-to Doc. Type" := VLE."Applies-to Doc. Type";
        GenJnlLine."Applies-to Doc. No." := VLE."Applies-to Doc. No.";
        GenJnlLine."Due Date" := VLE."Due Date";
        GenJnlLine."Pmt. Discount Date" := VLE."Pmt. Discount Date";
        GenJnlLine."Applies-to ID" := VLE."Applies-to ID";
        GenJnlLine."Journal Batch Name" := VLE."Journal Batch Name";
        GenJnlLine."Reason Code" := VLE."Reason Code";
        //GenJnlLine."User ID" := USERID;
        GenJnlLine."Bal. Account Type" := VLE."Bal. Account Type";
        GenJnlLine."Bal. Account No." := VLE."Bal. Account No.";
        GenJnlLine."Posting No. Series" := VLE."No. Series";
        GenJnlLine."IC Partner Code" := VLE."IC Partner Code";
        GenJnlLine.Prepayment := VLE.Prepayment;
        GenJnlLine."Recipient Bank Account" := VLE."Recipient Bank Account";
        GenJnlLine."Message to Recipient" := VLE."Message to Recipient";
        GenJnlLine."Applies-to Ext. Doc. No." := VLE."Applies-to Ext. Doc. No.";
        GenJnlLine."Creditor No." := VLE."Creditor No.";
        GenJnlLine."Payment Reference" := VLE."Payment Reference";
        GenJnlLine."Payment Method Code" := VLE."Payment Method Code";
        GenJnlLine."Exported to Payment File" := VLE."Exported to Payment File";
    END;

    PROCEDURE FinishPosting();
    VAR
        CostAccSetup: Record "Cost Accounting Setup";
        TransferGlEntriesToCA: Codeunit "Transfer GL Entries to CA";
        AccountingPeriod: Record 50;
        FiscalYearStartDate: Date;
        NextVATEntryNo: Integer;
        NextGLREntryNo: Integer;
    BEGIN
        IF TempGLEntryBuf.FINDSET THEN BEGIN

            AccountingPeriod.RESET;
            AccountingPeriod.SETCURRENTKEY(Closed);
            AccountingPeriod.SETRANGE(Closed, FALSE);
            AccountingPeriod.FINDFIRST;
            FiscalYearStartDate := AccountingPeriod."Starting Date";

            VATEntry.LOCKTABLE;
            IF VATEntry.FINDLAST THEN
                NextVATEntryNo := VATEntry."Entry No." + 1
            ELSE
                NextVATEntryNo := 1;


            REPEAT
                GlobalGLEntry := TempGLEntryBuf;
                GlobalGLEntry."Prior-Year Entry" := GlobalGLEntry."Posting Date" < FiscalYearStartDate;
                GlobalGLEntry.INSERT;
            UNTIL TempGLEntryBuf.NEXT = 0;

            GLReg.RESET;
            IF GLReg.FINDLAST THEN
                NextGLREntryNo := GLReg."No." + 1;

            GLReg.INIT;
            GLReg."No." := NextGLREntryNo;
            GLReg."From Entry No." := GLEntryNo;
            GLReg."From VAT Entry No." := NextVATEntryNo;
            GLReg."Creation Date" := TODAY;
            GLReg."Source Code" := TempGLEntryBuf."Source Code";
            GLReg."Journal Batch Name" := TempGLEntryBuf."Journal Batch Name";
            GLReg."User ID" := USERID;

            GLReg."To VAT Entry No." := NextVATEntryNo - 1;
            IF (GLReg."From VAT Entry No." = 0) OR (GLReg."To VAT Entry No." < GLReg."From VAT Entry No.") THEN BEGIN
                GLReg."From VAT Entry No." := 0;
                GLReg."To VAT Entry No." := 0;
            END;
            IF GLReg."To Entry No." = 0 THEN BEGIN
                GLReg."To Entry No." := GlobalGLEntry."Entry No.";
                GLReg.INSERT;
            END ELSE BEGIN
                GLReg."To Entry No." := GlobalGLEntry."Entry No.";
                GLReg.MODIFY;
            END;
        END;
        //GlobalGLEntry.CONSISTENT(
        //  (BalanceCheckAmount = 0) AND (BalanceCheckAmount2 = 0) AND
        //  (BalanceCheckAddCurrAmount = 0) AND (BalanceCheckAddCurrAmount2 = 0));
    END;

    PROCEDURE AddApplyVendorLedgerentry(varDetailVLE: Record "Detailed Vendor Ledg. Entry");
    VAR
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Window: Dialog;
        EntryNoBeforeApplication: Integer;
        EntryNoAfterApplication: Integer;
        APVLE: Record "Vendor Ledger Entry";
        entrycount: Integer;
        GLEntry: Record "G/L Entry";
        DetailVLE: Record "Detailed Vendor Ledg. Entry";
        ApplicationNo: Integer;
        Vend: Record Vendor;
        VendpostingGr: Record "Vendor Posting Group";
        VendLedEntry: Record "Vendor Ledger Entry";
    BEGIN
        VendLedEntry.RESET;
        VendLedEntry.SETRANGE("Entry No.", varDetailVLE."Vendor Ledger Entry No.");
        IF VendLedEntry.FIND('-') THEN BEGIN
            // if ap/ account no is not empty then using it to change account no.     ---hcj
            IF varDetailVLE."Document Type" = varDetailVLE."Document Type"::Payment THEN BEGIN

                DetailVLE.RESET;
                DetailVLE.SETRANGE("Entry No.", varDetailVLE."Entry No.");
                IF DetailVLE.FIND('-') THEN BEGIN
                    ApplicationNo := DetailVLE."Applied Vend. Ledger Entry No.";
                    DetailVLE.RESET;
                    DetailVLE.SETRANGE("Applied Vend. Ledger Entry No.", ApplicationNo);
                    IF varDetailVLE."Transaction No." = 0 THEN BEGIN
                        DetailVLE.SETCURRENTKEY("Application No.", "Vendor No.", "Entry Type");
                        DetailVLE.SETRANGE("Application No.", varDetailVLE."Application No.");
                    END ELSE BEGIN
                        DetailVLE.SETCURRENTKEY("Transaction No.", "Vendor No.", "Entry Type");
                        DetailVLE.SETRANGE("Transaction No.", varDetailVLE."Transaction No.");
                    END;
                    DetailVLE.SETFILTER(DetailVLE."Applied Vend. Ledger Entry No.", '<>0');
                    DetailVLE.SETCURRENTKEY("Initial Document Type", "Entry Type", "Vendor No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Posting Date");
                    IF DetailVLE.FIND('-') THEN BEGIN
                        REPEAT

                            APVLE.RESET;
                            APVLE.SETRANGE("Entry No.", DetailVLE."Vendor Ledger Entry No.");
                            IF APVLE.FIND('-') THEN BEGIN
                                // TempGLEntryBuf.DELETEALL();
                                IF (APVLE."Entry No." = VendLedEntry."Entry No.") THEN BEGIN
                                    WITH APVLE DO BEGIN

                                        GenJnlLine2.RESET;
                                        GenJnlLine2.INIT;
                                        CALCFIELDS(APVLE.Amount);
                                        CALCFIELDS(APVLE."Amount (LCY)");
                                        CALCFIELDS(APVLE."Remaining Amt. (LCY)");
                                        CALCFIELDS(APVLE."Original Amt. (LCY)");
                                        CopyVLEtoGenJnlLine(APVLE, GenJnlLine2);
                                        GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                                        IF APVLE."AP Account No." <> '' THEN
                                            GenJnlLine2."Account No." := APVLE."AP Account No.";

                                        GenJnlLine2."Source Line No." := APVLE."Entry No.";
                                        IF APVLE."Entry No." = VendLedEntry."Entry No." THEN BEGIN
                                            Vend.GET(APVLE."Vendor No.");
                                            Vend.CheckBlockedVendOnJnls(Vend, "Document Type", TRUE);

                                            IF "Posting Group" = '' THEN BEGIN
                                                Vend.TESTFIELD("Vendor Posting Group");
                                                "Posting Group" := Vend."Vendor Posting Group";
                                            END;
                                            VendpostingGr.GET("Posting Group");
                                            GenJnlLine2."Account No." := VendpostingGr.GetPayablesAccount;

                                            //  GenJnlLine2."Source Type" := GenJnlLine2."Source Type"::Vendor;
                                            //  GenJnlLine2."Source No." := "Vendor No.";
                                            //   GenJnlLine2."Source Code" := SourceCodeSetup."Purchase Entry Application";
                                            GenJnlLine2."System-Created Entry" := TRUE;
                                            GenJnlLine2."Source Line No." := 0;

                                        END;
                                        //IF DetailVLE."Entry Type" = DetailVLE."Entry Type"::"Payment Discount" THEN
                                        //BEGIN
                                        GenJnlLine2.Amount := DetailVLE.Amount;
                                        GenJnlLine2."Amount (LCY)" := DetailVLE."Amount (LCY)";
                                        //END
                                        //ELSE
                                        //BEGIN
                                        //  GenJnlLine2.Amount := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                        //  GenJnlLine2."Amount (LCY)" := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                        //END;
                                    END;
                                END;

                                IF (APVLE."AP Account No." <> '') OR (APVLE."Entry No." = VendLedEntry."Entry No.") THEN BEGIN
                                    WITH APVLE DO BEGIN

                                        CALCFIELDS(APVLE.Amount);
                                        CALCFIELDS(APVLE."Remaining Amt. (LCY)");
                                        CALCFIELDS(APVLE."Original Amt. (LCY)");
                                        GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                                        IF APVLE."AP Account No." <> '' THEN
                                            GenJnlLine2."Account No." := APVLE."AP Account No.";

                                        GenJnlLine2."Source Line No." := APVLE."Entry No.";
                                        //IF DetailVLE."Entry Type" = DetailVLE."Entry Type"::"Payment Discount" THEN
                                        //BEGIN
                                        GenJnlLine2.Amount := DetailVLE.Amount;
                                        GenJnlLine2."Amount (LCY)" := DetailVLE."Amount (LCY)";
                                        //END
                                        //ELSE
                                        //BEGIN
                                        //  GenJnlLine2.Amount := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                        //  GenJnlLine2."Amount (LCY)" := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                        //END;

                                        PostGLAcc(GenJnlLine2);
                                    END;
                                    //              COMMIT;
                                END;

                            END;
                        UNTIL DetailVLE.NEXT = 0;
                        FinishPosting();
                        COMMIT;
                    END;
                END;
            END;
        END;
    END;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean; Subscriber: Variant; RecVar: Variant)
    var
        VendEntryApplyPostedEntries: Codeunit "Eventsubscriber_and_CU227";
    begin
        VendEntryApplyPostedEntries := Subscriber;
        PreviewMode := true;
        Result := VendEntryApplyPostedEntries.Run(RecVar);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckReversal(VendLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostApplyVendLedgEntry(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostUnapplyVendLedgEntry(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUnApplyVendor(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyVendEntryFormEntryOnAfterCheckEntryOpen(ApplyingVendLedgEntry: Record "Vendor Ledger Entry");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyVendEntryFormEntryOnBeforeRunVendEntryEdit(var ApplyingVendLedgEntry: Record "Vendor Ledger Entry");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyVendEntryFormEntryOnAfterVendLedgEntrySetFilters(var VendorLedgEntry: Record "Vendor Ledger Entry"; var ApplyToVendLedgEntry: Record "Vendor Ledger Entry"; var IsHandled: Boolean; var VendEntryApplID: Code[50]);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeApply(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var DocumentNo: Code[20]; var ApplicationDate: Date)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeApplyVendEntryFormEntry(var ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetApplicationDate(VendorLedgEntry: Record "Vendor Ledger Entry"; var ApplicationDate: Date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostApplyVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostUnapplyVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCollectAffectedLedgerEntriesOnAfterSetFilters(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindLastApplEntryOnAfterSetFilters(var DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeVendPostApplyVendLedgEntry(var HideProgressWindow: Boolean; VendLedgEntry: Record "Vendor Ledger Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetApplicationDateOnAfterSetFilters(var ApplyToVendLedgEntry: Record "Vendor Ledger Entry"; VendorLedgEntry: Record "Vendor Ledger Entry");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRunUpdateAnalysisView(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRunVendExchRateAdjustment(var GenJnlLine: Record "Gen. Journal Line"; var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostUnApplyVendorCommit(var HideProgressWindow: Boolean; PreviewMode: Boolean; DetailedVendLedgEntry2: Record "Detailed Vendor Ledg. Entry"; DocNo: Code[20]; PostingDate: Date; CommitChanges: Boolean; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckUnappliedEntriesOnBeforeUnapplyAllEntriesError(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; LastTransactionNo: Integer; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnVendPostApplyVendLedgEntryOnBeforeCommit(var VendLedgerEntry: Record "Vendor Ledger Entry"; var SuppressCommit: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUnApplyVendor(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostUnApplyVendorOnAfterDtldVendLedgEntrySetFilters(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostUnApplyVendorOnAfterGetVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyOnBeforePmtTolVend(VendLedgEntry: Record "Vendor Ledger Entry"; var PaymentToleranceMgt: Codeunit "Payment Tolerance Management"; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostUnApplyVendorCommitOnBeforeFilterDtldVendLedgEntry(DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyOnBeforeVendPostApplyVendLedgEntry(VendorLedgerEntry: Record "Vendor Ledger Entry"; var ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyOnBeforePostingDateMustNotBeBeforeError(var ApplyUnapplyParameters: Record "Apply Unapply Parameters"; var VendorLedgerEntry: Record "Vendor Ledger Entry"; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostUnApplyVendorCommitOnBeforePostingDateMustNotBeBeforeError(var ApplyUnapplyParameters: Record "Apply Unapply Parameters"; var DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry"; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnModifyOnBeforeTestCheckPrinted, '', false, false)]
    local procedure "Gen. Journal Line_OnModifyOnBeforeTestCheckPrinted"(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if GenJnlBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then begin
            if GenJnlBatch.Name = 'ACH' then
                IsHandled := true;
        end;
    end;



}
