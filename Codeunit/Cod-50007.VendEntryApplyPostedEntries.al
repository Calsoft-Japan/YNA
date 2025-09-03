codeunit 50007 VendEntryApplyPostedEntriesExt
{
    Permissions = tabledata "G/L Register" = rimd,
                    tabledata "G/L Entry" = rimd;

    var
        NextEntryNo: Integer;
        NextTransactionNo: Integer;
        GLEntryNo: Integer;
        GlobalGLEntry: Record "G/L Entry";
        BalanceCheckAmount: Decimal;
        BalanceCheckAmount2: Decimal;
        BalanceCheckAddCurrAmount: Decimal;
        BalanceCheckAddCurrAmount2: Decimal;
        "Posting Group": Code[10];

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VendEntry-Apply Posted Entries", OnApplyOnBeforeVendPostApplyVendLedgEntry, '', false, false)]
    local procedure "VendEntry-Apply Posted Entries_OnApplyOnBeforeVendPostApplyVendLedgEntry"(VendorLedgerEntry: Record "Vendor Ledger Entry"; var ApplyUnapplyParameters: Record "Apply Unapply Parameters" temporary)
    var
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        Window: Dialog;
        EntryNoBeforeApplication: Integer;
        EntryNoAfterApplication: Integer;
        SuppressCommit: Boolean;
        PostingApplicationMsg: Label 'Posting application...';
        UpdateAnalysisView: Codeunit "Update Analysis View";
        GLSetup: Record "General Ledger Setup";

        GenJnlBatch: Record "Gen. Journal Batch";
        DetailVLE: Record "Detailed Vendor Ledg. Entry";
        DetailVLE2: Record "Detailed Vendor Ledg. Entry";
        APVLE: Record "Vendor Ledger Entry";
        ApplicationNo: Integer;
        Vend: Record Vendor;
        VendpostingGr: Record "Vendor Posting Group";
        TempGLEntryBuf: Record "G/L Entry" temporary;
        HideProgressWindow: Boolean;
    begin
        HideProgressWindow := false;
        if not HideProgressWindow then
            Window.Open(PostingApplicationMsg);

        SourceCodeSetup.Get();
        /*
        GLSetup.GetRecordOnce();
        if GLSetup."Journal Templ. Name Mandatory" then begin
            GLSetup.TestField("Apply Jnl. Template Name");
            GLSetup.TestField("Apply Jnl. Batch Name");
            ApplyUnapplyParameters."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
            ApplyUnapplyParameters."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
            GenJnlBatch.Get(GLSetup."Apply Jnl. Template Name", GLSetup."Apply Jnl. Batch Name");
        end;
        //ApplyUnapplyParameters."Document No." := VendorLedgerEntry."Document No.";
        //ApplyUnapplyParameters."Posting Date" := GetApplicationDate(VendorLedgerEntry);
        */
        GenJnlLine.Init();
        GenJnlLine."Document No." := ApplyUnapplyParameters."Document No.";
        GenJnlLine."Posting Date" := ApplyUnapplyParameters."Posting Date";
        GenJnlLine."Document Date" := GenJnlLine."Posting Date";
        GenJnlLine."VAT Reporting Date" := GenJnlLine."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine."Account No." := VendorLedgerEntry."Vendor No.";
        VendorLedgerEntry.CalcFields("Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
        GenJnlLine.Correction :=
            (VendorLedgerEntry."Debit Amount" < 0) or (VendorLedgerEntry."Credit Amount" < 0) or
            (VendorLedgerEntry."Debit Amount (LCY)" < 0) or (VendorLedgerEntry."Credit Amount (LCY)" < 0);
        GenJnlLine.CopyVendLedgEntry(VendorLedgerEntry);
        GenJnlLine."Source Code" := SourceCodeSetup."Purchase Entry Application";
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."External Document No." := VendorLedgerEntry."External Document No.";
        GenJnlLine."Journal Template Name" := ApplyUnapplyParameters."Journal Template Name";
        GenJnlLine."Journal Batch Name" := ApplyUnapplyParameters."Journal Batch Name";

        EntryNoBeforeApplication := FindLastApplDtldVendLedgEntry();

        GenJnlPostLine.VendPostApplyVendLedgEntry(GenJnlLine, VendorLedgerEntry);

        EntryNoAfterApplication := FindLastApplDtldVendLedgEntry();
        /***************************/
        // if ap/ account no is not empty then using it to change account no.     ---hcj
        //IF DtldVendLedgEntry2."Document Type" = DtldVendLedgEntry2."Document Type"::Payment THEN
        begin


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
                            IF (APVLE."Entry No." = VendorLedgerEntry."Entry No.") THEN BEGIN
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
                                    IF APVLE."Entry No." = VendorLedgerEntry."Entry No." THEN BEGIN
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

                            IF (APVLE."AP Account No." <> '') OR (APVLE."Entry No." = VendorLedgerEntry."Entry No.") THEN BEGIN
                                GenJnlLine2."Posting Date" := ApplyUnapplyParameters."Posting Date";
                                APVLE.CALCFIELDS(APVLE.Amount);
                                APVLE.CALCFIELDS(APVLE."Amount (LCY)");
                                APVLE.CALCFIELDS(APVLE."Remaining Amt. (LCY)");
                                APVLE.CALCFIELDS(APVLE."Original Amt. (LCY)");
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
                                PostGLAcc(GenJnlLine2, TempGLEntryBuf);
                                //COMMIT;
                            END;


                        END;
                    UNTIL DetailVLE.NEXT = 0;
                    FinishPosting(TempGLEntryBuf);
                    //COMMIT;
                END;
            END;
        end;

        SuppressCommit := false;
        if not SuppressCommit then
            Commit();
        if not HideProgressWindow then
            Window.Close();
        UpdateAnalysisView.UpdateAll(0, true);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VendEntry-Apply Posted Entries", OnBeforeVendPostApplyVendLedgEntry, '', false, false)]
    local procedure "VendEntry-Apply Posted Entries_OnBeforeVendPostApplyVendLedgEntry"(var HideProgressWindow: Boolean; VendLedgEntry: Record "Vendor Ledger Entry"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VendEntry-Apply Posted Entries", OnApplyVendEntryFormEntryOnAfterVendLedgEntrySetFilters, '', false, false)]
    local procedure "VendEntry-Apply Posted Entries_OnApplyVendEntryFormEntryOnAfterVendLedgEntrySetFilters"(var VendorLedgEntry: Record "Vendor Ledger Entry"; var ApplyToVendLedgEntry: Record "Vendor Ledger Entry"; var IsHandled: Boolean; var VendEntryApplID: Code[50])
    begin

        //FDD210  ApplyingVendLedgEntry is Invoice and Credit memo can't apply to Payment
        IF (ApplyToVendLedgEntry."Document Type" = ApplyToVendLedgEntry."Document Type"::Invoice)
           OR (ApplyToVendLedgEntry."Document Type" = ApplyToVendLedgEntry."Document Type"::"Credit Memo") THEN
            VendorLedgEntry.SETFILTER("Document Type", '<>Payment');

        IF ApplyToVendLedgEntry."Document Type" = ApplyToVendLedgEntry."Document Type"::Payment THEN
            VendorLedgEntry.SETFILTER("Document Type", '<>Payment&<>Refund');
        //FDD210 end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VendEntry-Apply Posted Entries", OnAfterPostUnapplyVendLedgEntry, '', false, false)]
    local procedure "VendEntry-Apply Posted Entries_OnAfterPostUnapplyVendLedgEntry"(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary)
    var
        SourceCodeSetup: Record "Source Code Setup";
        DetailVLE: Record "Detailed Vendor Ledg. Entry";
        ApplicationNo: Integer;
        APVLE: Record "Vendor Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        Vend: Record Vendor;
        VendpostingGr: Record "Vendor Posting Group";
        TempGLEntryBuf: Record "G/L Entry" temporary;
    begin
        //hcj

        // if ap/ account no is not empty then using it to change account no.     ---hcj
        IF DetailedVendorLedgEntry."Document Type" = DetailedVendorLedgEntry."Document Type"::Payment THEN BEGIN
            DetailVLE.RESET;
            DetailVLE.SETRANGE("Entry No.", DetailedVendorLedgEntry."Entry No.");
            IF DetailVLE.FIND('-') THEN BEGIN
                ApplicationNo := DetailVLE."Applied Vend. Ledger Entry No.";
                DetailVLE.RESET;
                DetailVLE.SETRANGE("Applied Vend. Ledger Entry No.", ApplicationNo);
                IF DetailedVendorLedgEntry."Transaction No." = 0 THEN BEGIN
                    DetailVLE.SETCURRENTKEY("Application No.", "Vendor No.", "Entry Type");
                    DetailVLE.SETRANGE("Application No.", DetailedVendorLedgEntry."Application No.");
                END ELSE BEGIN
                    DetailVLE.SETCURRENTKEY("Transaction No.", "Vendor No.", "Entry Type");
                    DetailVLE.SETRANGE("Transaction No.", DetailedVendorLedgEntry."Transaction No.");
                END;

                DetailVLE.SETCURRENTKEY("Initial Document Type", "Entry Type", "Vendor No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Posting Date");
                IF DetailVLE.FIND('-') THEN BEGIN
                    REPEAT
                        APVLE.RESET;
                        APVLE.SETRANGE("Entry No.", DetailVLE."Vendor Ledger Entry No.");
                        IF APVLE.FIND('-') THEN BEGIN
                            IF (APVLE."Entry No." = VendorLedgerEntry."Entry No.") THEN BEGIN

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
                                IF APVLE."Entry No." = VendorLedgerEntry."Entry No." THEN BEGIN
                                    Vend.GET(APVLE."Vendor No.");
                                    Vend.CheckBlockedVendOnJnls(Vend, APVLE."Document Type", TRUE);

                                    IF "Posting Group" = '' THEN BEGIN
                                        Vend.TESTFIELD("Vendor Posting Group");
                                        "Posting Group" := Vend."Vendor Posting Group";
                                    END;
                                    VendpostingGr.GET("Posting Group");
                                    GenJnlLine2."Account No." := VendpostingGr.GetPayablesAccount;

                                    GenJnlLine2."Source Type" := GenJnlLine."Source Type"::Vendor;
                                    GenJnlLine2."Source No." := APVLE."Vendor No.";
                                    GenJnlLine2."Source Code" := SourceCodeSetup."Purchase Entry Application";
                                    GenJnlLine2."System-Created Entry" := TRUE;
                                    GenJnlLine2."Source Line No." := 0;

                                END;
                                GenJnlLine2.Amount := DetailVLE.Amount * -1;
                                GenJnlLine2."Amount (LCY)" := DetailVLE."Amount (LCY)" * -1;
                                //  COMMIT;
                            END;


                            IF (APVLE."AP Account No." <> '') OR (APVLE."Entry No." = VendorLedgerEntry."Entry No.") THEN BEGIN
                                //                  CopyVLEtoGenJnlLine(APVLE,GenJnlLine2);
                                GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                                IF APVLE."AP Account No." <> '' THEN
                                    GenJnlLine2."Account No." := APVLE."AP Account No.";

                                GenJnlLine2.Amount := DetailVLE.Amount * -1;
                                GenJnlLine2."Amount (LCY)" := DetailVLE."Amount (LCY)" * -1;

                                PostGLAcc(GenJnlLine2, TempGLEntryBuf);
                                //  COMMIT;
                            END;


                        END;
                    UNTIL DetailVLE.NEXT = 0;
                    FinishPosting(TempGLEntryBuf);
                    //COMMIT;
                END;
            END;
        END;  //the end of if payment
        //FDD210 End hcj
    end;

    procedure GetApplicationDate(VendLedgEntry: Record "Vendor Ledger Entry") ApplicationDate: Date
    var
        ApplyToVendLedgEntry: Record "Vendor Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(ApplicationDate);

        ApplicationDate := 0D;
        ApplyToVendLedgEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
        ApplyToVendLedgEntry.SetRange("Vendor No.", VendLedgEntry."Vendor No.");
        ApplyToVendLedgEntry.SetRange("Applies-to ID", VendLedgEntry."Applies-to ID");
        ApplyToVendLedgEntry.FindSet();
        repeat
            if ApplyToVendLedgEntry."Posting Date" > ApplicationDate then
                ApplicationDate := ApplyToVendLedgEntry."Posting Date";
        until ApplyToVendLedgEntry.Next() = 0;
    end;

    procedure AddApplyVendorLedgerentry(varDetailVLE: Record "Detailed Vendor Ledg. Entry")
    var
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
        TempGLEntryBuf: Record "G/L Entry" temporary;
    begin
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
                                    GenJnlLine2.RESET;
                                    GenJnlLine2.INIT;
                                    APVLE.CALCFIELDS(APVLE.Amount);
                                    APVLE.CALCFIELDS(APVLE."Amount (LCY)");
                                    APVLE.CALCFIELDS(APVLE."Remaining Amt. (LCY)");
                                    APVLE.CALCFIELDS(APVLE."Original Amt. (LCY)");
                                    CopyVLEtoGenJnlLine(APVLE, GenJnlLine2);
                                    GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                                    IF APVLE."AP Account No." <> '' THEN
                                        GenJnlLine2."Account No." := APVLE."AP Account No.";

                                    GenJnlLine2."Source Line No." := APVLE."Entry No.";
                                    IF APVLE."Entry No." = VendLedEntry."Entry No." THEN BEGIN
                                        Vend.GET(APVLE."Vendor No.");
                                        Vend.CheckBlockedVendOnJnls(Vend, APVLE."Document Type", TRUE);

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

                                IF (APVLE."AP Account No." <> '') OR (APVLE."Entry No." = VendLedEntry."Entry No.") THEN BEGIN

                                    APVLE.CALCFIELDS(APVLE.Amount);
                                    APVLE.CALCFIELDS(APVLE."Remaining Amt. (LCY)");
                                    APVLE.CALCFIELDS(APVLE."Original Amt. (LCY)");
                                    GenJnlLine2."Document Type" := GenJnlLine2."Document Type"::Payment;
                                    IF APVLE."AP Account No." <> '' THEN
                                        GenJnlLine2."Account No." := APVLE."AP Account No.";

                                    GenJnlLine2."Source Line No." := APVLE."Entry No.";
                                    //IF DetailVLE."Entry Type" = DetailVLE."Entry Type"::"Payment Discount" THEN
                                    //BEGIN
                                    GenJnlLine2.Amount := DetailVLE.Amount;
                                    GenJnlLine2."Amount (LCY)" := DetailVLE."Amount (LCY)";
                                    //GenJnlLine2."Bal. Account Type" := DetailVLE.
                                    //END
                                    //ELSE
                                    //BEGIN
                                    //  GenJnlLine2.Amount := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                    //  GenJnlLine2."Amount (LCY)" := (APVLE."Original Amt. (LCY)"  - APVLE."Remaining Amt. (LCY)") * -1;
                                    //END;

                                    PostGLAcc(GenJnlLine2, TempGLEntryBuf);
                                    //              COMMIT;
                                END;

                            END;
                        UNTIL DetailVLE.NEXT = 0;
                        FinishPosting(TempGLEntryBuf);
                        //COMMIT;
                    END;
                END;
            END;
        END;
    end;

    procedure CopyVLEtoGenJnlLine(VLE: Record "Vendor Ledger Entry"; var GenJnlLine: Record "Gen. Journal Line")
    begin
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
    end;

    local procedure PostGLAcc(GenJnlLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        GLAcc: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
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
            InsertGLEntry(GenJnlLine, GLEntry, TRUE, TempGLEntryBuf);
            //PostJob(GenJnlLine,GLEntry);
            //PostVAT(GenJnlLine,GLEntry,VATPostingSetup);
            //FinishPosting();
        END;
    end;

    local procedure FindLastApplDtldVendLedgEntry(): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.LockTable();
        exit(DtldVendLedgEntry.GetLastEntryNo());
    end;

    local procedure InitGLEntry(GenJnlLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; GLAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean; SystemCreatedEntry: Boolean)
    var
        GLAcc: Record "G/L Account";
    //GlobalGLEntry: Record "G/L Entry";
    //TransferCustomFields: Codeunit 10201;
    begin

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
        //Codeunit 'Transfer Custom Fields' is marked for removal. Reason: These methods are not used anymore. Tag: 17.0.
        //TransferCustomFields.GenJnlLineTOGenLedgEntry(GenJnlLine, GLEntry);
        //GLEntry."Additional-Currency Amount" :=
        //  GLCalcAddCurrency(Amount,AmountAddCurr,GLEntry."Additional-Currency Amount",UseAmountAddCurr,GenJnlLine);

    end;

    procedure InsertGLEntry(GenJnlLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; CalcAddCurrResiduals: Boolean; var TempGLEntryBuf: Record "G/L Entry" temporary)
    begin
        GLEntry.TESTFIELD("G/L Account No.");


        UpdateCheckAmounts(
          GLEntry."Posting Date", GLEntry.Amount, GLEntry."Additional-Currency Amount",
          BalanceCheckAmount, BalanceCheckAmount2, BalanceCheckAddCurrAmount, BalanceCheckAddCurrAmount2);

        GLEntry.UpdateDebitCredit(GenJnlLine.Correction);

        TempGLEntryBuf := GLEntry;
        TempGLEntryBuf.INSERT;

        NextEntryNo := NextEntryNo + 1;

    end;

    local procedure UpdateCheckAmounts(PostingDate: Date; Amount: Decimal; AddCurrAmount: Decimal; var BalanceCheckAmount: Decimal; var BalanceCheckAmount2: Decimal; var BalanceCheckAddCurrAmount: Decimal; var BalanceCheckAddCurrAmount2: Decimal)
    begin
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
    end;

    procedure FinishPosting(var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        CostAccSetup: Record "Cost Accounting Setup";
        TransferGlEntriesToCA: Codeunit "Transfer GL Entries to CA";
        AccountingPeriod: Record "Accounting Period";
        FiscalYearStartDate: Date;
        NextVATEntryNo: Integer;
        NextGLREntryNo: Integer;
        GLReg: Record "G/L Register";
        VATEntry: Record "VAT Entry";
    begin
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

            //bobby by 2025-3-28 begin
            GLReg."To Entry No." := GlobalGLEntry."Entry No.";
            GLReg.INSERT;
            /*
            IF GLReg."To Entry No." = 0 THEN BEGIN
                GLReg."To Entry No." := GlobalGLEntry."Entry No.";
                GLReg.INSERT;
            END ELSE BEGIN
                GLReg."To Entry No." := GlobalGLEntry."Entry No.";
                GLReg.MODIFY;
            END;
            */
            //bobby by 2025-3-28 end
        END;
        //GlobalGLEntry.CONSISTENT(
        //  (BalanceCheckAmount = 0) AND (BalanceCheckAmount2 = 0) AND
        //  (BalanceCheckAddCurrAmount = 0) AND (BalanceCheckAddCurrAmount2 = 0));
    end;
}
