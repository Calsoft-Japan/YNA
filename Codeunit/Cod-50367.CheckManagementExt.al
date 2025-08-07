codeunit 50367 CheckManagementExt
{
    var
        GGGenJnlLine4: Record "Gen. Journal Line" temporary;
        "Posting Group": Code[10];
        SourceCodeSetup: Record "Source Code Setup";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::CheckManagement, OnUnApplyVendInvoicesOnBeforePost, '', false, false)]
    local procedure CheckManagement_OnUnApplyVendInvoicesOnBeforePost(var GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry"; var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        OrigPaymentVendorLedgerEntry: Record "Vendor Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DetailVLE: Record "Detailed Vendor Ledg. Entry";
        APVLE: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        VendpostingGr: Record "Vendor Posting Group";
        ApplicationNo: Integer;
    begin
        //FDD210 begin
        //VendLedgEntry.LOCKTABLE;
        VendLedgEntry.GET(DetailedVendorLedgEntry."Vendor Ledger Entry No.");
        //fdd210 end;


        //if ap/ account no is not empty then using it to change account no.     ---hcj
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
                            IF (APVLE."Entry No." = VendLedgEntry."Entry No.") THEN BEGIN

                                GGGenJnlLine4.RESET;
                                GGGenJnlLine4.INIT;
                                //APVLE.CALCFIELDS(APVLE.Amount);
                                //APVLE.CALCFIELDS(APVLE."Remaining Amt. (LCY)");
                                //APVLE.CALCFIELDS(APVLE."Original Amt. (LCY)");
                                CopyVLEtoGenJnlLine(APVLE, GGGenJnlLine4);
                                GGGenJnlLine4."Document Type" := GGGenJnlLine4."Document Type"::Payment;
                                IF APVLE."AP Account No." <> '' THEN
                                    GGGenJnlLine4."Account No." := APVLE."AP Account No.";

                                GGGenJnlLine4."Source Line No." := APVLE."Entry No.";
                                IF APVLE."Entry No." = VendLedgEntry."Entry No." THEN BEGIN
                                    //Vend.Locktable;
                                    Vend.GET(APVLE."Vendor No.");
                                    Vend.CheckBlockedVendOnJnls(Vend, APVLE."Document Type", TRUE);

                                    IF "Posting Group" = '' THEN BEGIN
                                        Vend.TESTFIELD("Vendor Posting Group");
                                        "Posting Group" := Vend."Vendor Posting Group";
                                    END;
                                    VendpostingGr.GET("Posting Group");
                                    GGGenJnlLine4."Account No." := VendpostingGr.GetPayablesAccount;

                                    GGGenJnlLine4."Source Type" := GGGenJnlLine4."Source Type"::Vendor;
                                    GGGenJnlLine4."Source No." := APVLE."Vendor No.";
                                    GGGenJnlLine4."Source Code" := SourceCodeSetup."Purchase Entry Application";
                                    GGGenJnlLine4."System-Created Entry" := TRUE;
                                    GGGenJnlLine4."Source Line No." := 0;

                                END;
                                GGGenJnlLine4.Amount := DetailVLE.Amount * -1;
                                GGGenJnlLine4."Amount (LCY)" := DetailVLE."Amount (LCY)" * -1;
                                COMMIT;
                            END;


                            IF (APVLE."AP Account No." <> '') OR (APVLE."Entry No." = VendLedgEntry."Entry No.") THEN BEGIN
                                //CopyVLEtoGenJnlLine(APVLE, GGGenJnlLine4);
                                GGGenJnlLine4."Account Type" := GGGenJnlLine4."Account Type"::"G/L Account";
                                GGGenJnlLine4."Document Type" := GGGenJnlLine4."Document Type"::Payment;
                                IF APVLE."AP Account No." <> '' THEN
                                    GGGenJnlLine4."Account No." := APVLE."AP Account No.";

                                GGGenJnlLine4.Amount := DetailVLE.Amount * -1;
                                GGGenJnlLine4."Amount (LCY)" := DetailVLE."Amount (LCY)" * -1;
                                GGGenJnlLine4."Line No." := GGGenJnlLine4."Line No." + 1;
                                GGGenJnlLine4.INSERT;
                                //PostGLAcc(GenJnlLine2);
                                //GenJnlPostLine.RunWithoutCheck(GenJnlLine2)
                                //COMMIT;
                            END;


                        END;
                    UNTIL DetailVLE.NEXT = 0;
                    //LocalFinishPosting();
                    //COMMIT;
                END;
            END;
        END;
        //the end of if payment
        //FDD210 End hcj
    end;

    procedure CopyVLEtoGenJnlLine(VLE: Record "Vendor Ledger Entry"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
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
}
