codeunit 50001 GenJnlPostExt
{
    //CS 2025/1/10 Channing.Zhou FDD209
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeCode, '', false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        APACC: Code[10];
        GLACC_CIP: Boolean;
        GLACCNON_CIP: Boolean;
        Warning_CIP: Text;
        DocNo_CIP: Text;
        LastDocNo_CIP: Text;
        TempGenJnlLine: Record TempGenJnlLine;
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
                        ERROR('AP Account No. cannot be blank. (Document Type: ' + FORMAT(GenJournalLine."Document Type") + ', Document No.: ' +
                        GenJournalLine."Document No." + ', Vendor: ' + GenJournalLine."Account No." + ')');

                    IF (GenJournalLine."Journal Batch Name" <> 'MSR') AND (GenJournalLine."External Document No." = '') THEN
                        ERROR('External Document No. cannot be blank. (Document Type: ' + FORMAT(GenJournalLine."Document Type") + ', Document no: ' +
                        GenJournalLine."Document No." + ', Vendor: ' + GenJournalLine."Account No." + ')');

                END;
                // END new requirement

                //bobby begin
                TempGenJnlLine.Init();
                TempGenJnlLine."Entry No." := 0;
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
        //CS 2025/1/15 Channing.Zhou FDD215 start
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
        //CS 2025/1/15 Channing.Zhou FDD215 end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnCodeOnAfterGenJnlPostBatchRun, '', false, false)]
    local procedure OnCodeOnAfterGenJnlPostBatchRun(var GenJnlLine: Record "Gen. Journal Line")
    var
        applyentry: Codeunit VendEntryApplyPostEn;
        VendorLedEntry: Record "Vendor Ledger Entry";
        Custapplyentry: Codeunit CustEntryApplyPostEn;
        CustLedEntry: Record "Cust. Ledger Entry";
        tempGenJnlLine: Record TempGenJnlLine;
    begin
        //bobby begin
        tempGenJnlLine.Reset();
        tempGenJnlLine.SetRange("User ID", UserId);
        //booby end
        //hcj begin
        IF tempGenJnlLine.FindFirst() THEN BEGIN
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
        IF tempGenJnlLine.FindFirst() THEN BEGIN
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

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure "G/L Entry_OnAfterCopyGLEntryFromGenJnlLine"(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin      //hcj fdd209
        GLEntry."AP/AR Account No." := GenJournalLine."AP/AR Account No.";
        GLEntry."Item No." := GenJournalLine."Item No.";
        GLEntry."Item Description" := GenJournalLine."Item Description";
        GLEntry.Type := GenJournalLine.Type;
        GLEntry.Size := GenJournalLine.Size;
        GLEntry."Unit Price" := GenJournalLine."Unit Price";
        //GLEntry.Quantity := GenJnlLine.Quantity;
        GLEntry."Due Date" := GenJournalLine."Due Date";
        GLEntry."Receipt Date" := GenJournalLine."Receipt Date";
        GLEntry."Original Receipt No." := GenJournalLine."Original Receipt No.";
        GLEntry."Print Debit/Credit Memo" := GenJournalLine."Print Debit/Credit Memo";
        GLEntry."RMA No." := GenJournalLine."RMA No.";
        GLEntry."Original Document No." := GenJournalLine."Original Document No.";
        GLEntry."Customer No." := GenJournalLine."Customer No.";
        GLEntry."Description 2" := GenJournalLine."Description 2";
        GLEntry."System Code" := GenJournalLine."System Code";
        GLEntry."Voucher Group Code" := GenJournalLine."Voucher Group Code";
        //hcj end
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", OnAfterCopyCustLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure "Cust. Ledger Entry_OnAfterCopyCustLedgerEntryFromGenJnlLine"(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        // CS1.0 FDD209
        CustLedgerEntry."AR Account No." := GenJournalLine."AP/AR Account No.";
        CustLedgerEntry."Item No." := GenJournalLine."Item No.";
        CustLedgerEntry."Item Description" := GenJournalLine."Item Description";
        CustLedgerEntry."Customer No. 2" := GenJournalLine."Customer No.";
        CustLedgerEntry."Unit Price" := GenJournalLine."Unit Price";
        CustLedgerEntry.Quantity := GenJournalLine.Quantity;
        CustLedgerEntry."Description 2" := GenJournalLine."Description 2";
        CustLedgerEntry."Print Debit/Credit Memo" := GenJournalLine."Print Debit/Credit Memo";
        CustLedgerEntry."RMA No." := GenJournalLine."RMA No.";
        CustLedgerEntry."Original Document No." := GenJournalLine."Original Document No.";
        //CS1.0 end
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", OnAfterCopyVendLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure "Vendor Ledger Entry_OnAfterCopyVendLedgerEntryFromGenJnlLine"(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin      //hcj fdd209
        VendorLedgerEntry."AP Account No." := GenJournalLine."AP/AR Account No.";
        VendorLedgerEntry."Item No." := GenJournalLine."Item No.";
        VendorLedgerEntry."Item Description" := GenJournalLine."Item Description";
        VendorLedgerEntry.Type := GenJournalLine.Type;
        VendorLedgerEntry.Size := GenJournalLine.Size;
        VendorLedgerEntry."Unit Price" := GenJournalLine."Unit Price";
        VendorLedgerEntry.Quantity := GenJournalLine.Quantity;
        VendorLedgerEntry."Due Date" := GenJournalLine."Due Date";
        VendorLedgerEntry."Receipt Date" := GenJournalLine."Receipt Date";
        VendorLedgerEntry."Original Receipt No." := GenJournalLine."Original Receipt No.";
        VendorLedgerEntry."Print Debit/Credit Memo" := GenJournalLine."Print Debit/Credit Memo";
        VendorLedgerEntry."RMA No." := GenJournalLine."RMA No.";
        VendorLedgerEntry."Original Document No." := GenJournalLine."Original Document No.";
        //hcj end
    end;
}
