codeunit 50012 GenJnlPostLineExt
{
    //CS 2025/1/20 Bobby.Ji FDD210/FDD211 Start
    Permissions = tabledata "G/L Register" = rimd,
                    tabledata "G/L Entry" = rimd;

    var
    //NextEntryNo: Integer;

    /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterFinishPosting, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnAfterFinishPosting"(var GlobalGLEntry: Record "G/L Entry"; var GLRegister: Record "G/L Register"; var IsTransactionConsistent: Boolean; var GenJournalLine: Record "Gen. Journal Line")
    */
    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnFinishPostingOnBeforeResetFirstEntryNo, '', false, false)]
        local procedure "Gen. Jnl.-Post Line_OnFinishPostingOnBeforeResetFirstEntryNo"(var Sender: Codeunit "Gen. Jnl.-Post Line"; var GLEntry: Record "G/L Entry"; NextEntryNo: Integer; FirstEntryNo: Integer)
        var
            ClearEntryNO: Boolean;
            ApplyVendorEntry: Codeunit VendEntryApplyPostedEntriesExt;
            DetailVLE: Record "Detailed Vendor Ledg. Entry";
            TempGLEntryBufData: Record TempGLEntryBuf;
        begin

            // add hcj 03/22/2016 FDD210
            ClearEntryNO := FALSE;
            TempGLEntryBufData.Reset();
            TempGLEntryBufData.SetRange("User ID", UserId);
            IF TempGLEntryBufData.FINDSET THEN BEGIN
                REPEAT
                    IF TempGLEntryBufData."Source Code" <> 'REVERSAL' THEN BEGIN
                        DetailVLE.RESET;
                        DetailVLE.SETRANGE(DetailVLE."Vendor Ledger Entry No.", TempGLEntryBufData."Temp Entry No.");
                        DetailVLE.SETRANGE(DetailVLE."Entry Type", DetailVLE."Entry Type"::Application);
                        IF DetailVLE.FIND('-') THEN BEGIN
                            //ApplyVendorEntry.AddApplyVendorLedgerentry(DetailVLE);
                            ClearEntryNO := TRUE;
                        END;
                    END;

                UNTIL TempGLEntryBufData.NEXT = 0;
            END;
            //TempGLEntryBufData.DeleteAll();
            // 05/20/2016 hcj
            //IF ClearEntryNO THEN
            //NextEntryNo := 0; // hcj 05/20/2016
            // end 05/20/2016
        end;
    */
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterGLFinishPosting, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnAfterGLFinishPosting"(GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line"; var IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; var GLRegister: Record "G/L Register"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    var
        ClearEntryNO: Boolean;
        ApplyVendorEntry: Codeunit VendEntryApplyPostedEntriesExt;
        DetailVLE: Record "Detailed Vendor Ledg. Entry";
        TempGLEntryBufData: Record TempGLEntryBuf;
    begin

        // add hcj 03/22/2016 FDD210
        ClearEntryNO := FALSE;
        TempGLEntryBufData.Reset();
        TempGLEntryBufData.SetRange("User ID", UserId);
        IF TempGLEntryBufData.FINDSET THEN BEGIN
            REPEAT
                IF TempGLEntryBufData."Source Code" <> 'REVERSAL' THEN BEGIN
                    DetailVLE.RESET;
                    DetailVLE.SETRANGE(DetailVLE."Vendor Ledger Entry No.", TempGLEntryBufData."Temp Entry No.");
                    DetailVLE.SETRANGE(DetailVLE."Entry Type", DetailVLE."Entry Type"::Application);
                    IF DetailVLE.FIND('-') THEN BEGIN
                        ApplyVendorEntry.AddApplyVendorLedgerentry(DetailVLE);
                        ClearEntryNO := TRUE;
                    END;
                END;

            UNTIL TempGLEntryBufData.NEXT = 0;
        END;
        TempGLEntryBufData.DeleteAll();
        // 05/20/2016 hcj
        IF ClearEntryNO THEN
            NextEntryNo := 0; // hcj 05/20/2016
        // end 05/20/2016
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeFinishPosting, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnBeforeFinishPosting"(var Sender: Codeunit "Gen. Jnl.-Post Line"; var GenJournalLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        TempGLEntryBufData: Record TempGLEntryBuf;
        ApplyVendorEntry: Codeunit VendEntryApplyPostedEntriesExt;
        DetailVLE: Record "Detailed Vendor Ledg. Entry";
    begin

        IF TempGLEntryBuf.FINDSET THEN BEGIN
            REPEAT
                TempGLEntryBufData.Reset();
                TempGLEntryBufData.Init();
                TempGLEntryBufData."Entry No." := 0;
                TempGLEntryBufData."Temp Entry No." := TempGLEntryBuf."Entry No.";
                TempGLEntryBufData."Source Code" := TempGLEntryBuf."Source Code";
                TempGLEntryBufData."User ID" := UserId;
                TempGLEntryBufData.Insert();
            UNTIL TempGLEntryBuf.NEXT = 0;
        END;
    end;
    //CS 2025/1/20 Bobby.Ji FDD210/FDD211 End

    //CS 2025/1/20 Channing.Zhou FDD209 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterPostGLAcc, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnAfterPostGLAcc"(var Sender: Codeunit "Gen. Jnl.-Post Line"; var GenJnlLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer; Balancing: Boolean; var GLEntry: Record "G/L Entry"; VATPostingSetup: Record "VAT Posting Setup")
    begin
        // CS1.0 FDD209 sync the addition fields
        GLEntry."Voucher Group Code" := GenJnlLine."Voucher Group Code";
        GLEntry."System Code" := GenJnlLine."System Code";
        //  GLEntry."G/L Account No."      := GenJnlLine."AP/AR Account No."
        //hcj import
        GLEntry."AP/AR Account No." := GenJnlLine."AP/AR Account No.";
        GLEntry."Item No." := GenJnlLine."Item No.";
        GLEntry."Item Description" := GenJnlLine."Item Description";
        GLEntry.Type := GenJnlLine.Type;
        GLEntry.Size := GenJnlLine.Size;
        GLEntry."Unit Price" := GenJnlLine."Unit Price";
        //Quantity := GenJnlLine.Quantity;
        GLEntry."Due Date" := GenJnlLine."Due Date";
        GLEntry."Receipt Date" := GenJnlLine."Receipt Date";
        GLEntry."Original Receipt No." := GenJnlLine."Original Receipt No.";
        GLEntry."Print Debit/Credit Memo" := GenJnlLine."Print Debit/Credit Memo";
        GLEntry."RMA No." := GenJnlLine."RMA No.";
        GLEntry."Original Document No." := GenJnlLine."Original Document No.";
        GLEntry."Customer No." := GenJnlLine."Customer No.";
        GLEntry."Description 2" := GenJnlLine."Description 2";
        //hcj end
        // CS1.0 sync end.
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitGLEntry, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnAfterInitGLEntry"(var Sender: Codeunit "Gen. Jnl.-Post Line"; var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    begin
        // add hcj for FDD209 begin
        IF ((GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) OR
           (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer)) AND
           (GenJournalLine."AP/AR Account No." <> '') THEN begin
            GLEntry."G/L Account No." := GenJournalLine."AP/AR Account No.";
        end;
        // add hcj for fdd209 end.
    end;

    //CS 2025/1/20 Channing.Zhou FDD209 End
}
