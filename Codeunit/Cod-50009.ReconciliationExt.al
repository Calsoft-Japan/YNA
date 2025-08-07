codeunit 50009 ReconciliationExt
{
    //CS 2025/1/10 Bobby.Ji FDD212
    [EventSubscriber(ObjectType::Page, Page::Reconciliation, OnAfterSetGenJnlLine, '', false, false)]
    local procedure Reconciliation_OnAfterSetGenJnlLine(var GLAccountNetChange: Record "G/L Account Net Change" temporary; var GenJnlLine: Record "Gen. Journal Line")
    var
        GLAcc2: Record "G/L Account";
    begin
        if GenJnlLine.Find('-') then
            repeat
                // FDD212 hcj 6/7/2016
                IF (GenJnlLine."AP/AR Account No." <> '') AND (GenJnlLine."Account Type" <> GenJnlLine."Account Type"::"G/L Account") THEN BEGIN
                    GLAcc2.GET(GenJnlLine."AP/AR Account No.");
                    IF GLAcc2."Reconciliation Account" = TRUE THEN BEGIN
                        SaveNetChange(
                          GenJnlLine."Account Type"::"G/L Account", GenJnlLine."AP/AR Account No.",
                          ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."VAT %" / 100)), GLAccountNetChange, GenJnlLine);
                        //SaveNetChange(
                        //  GenJnlLine."Bal. Account Type",GenJnlLine."Bal. Account No.",
                        //  -ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."Bal. VAT %" / 100)));
                    END;
                END;
            // FDD212 hcj end
            until GenJnlLine.Next() = 0;
    end;

    local procedure SaveNetChange(AccType: Enum "Gen. Journal Account Type"; AccNo: Code[20]; NetChange: Decimal; var GLAccountNetChange: Record "G/L Account Net Change" temporary; var GenJnlLine: Record "Gen. Journal Line")
    var
        IsHandled: Boolean;
        GLAcc: Record "G/L Account";
        BankAcc: Record "Bank Account";
        BankAccPostingGr: Record "Bank Account Posting Group";
        ReconciliationPage: page Reconciliation;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if AccNo = '' then
            exit;
        case AccType of
            GenJnlLine."Account Type"::"G/L Account":
                if not GLAccountNetChange.Get(AccNo) then
                    exit;
            GenJnlLine."Account Type"::"Bank Account":
                begin
                    if AccNo <> BankAcc."No." then begin
                        BankAcc.Get(AccNo);
                        BankAcc.TestField("Bank Acc. Posting Group");
                        BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");
                        BankAccPostingGr.TestField("G/L Account No.");
                    end;
                    AccNo := BankAccPostingGr."G/L Account No.";

                    if not GLAccountNetChange.Get(AccNo) then begin
                        GLAcc.Get(AccNo);
                        InsertGLAccNetChange(GLAccountNetChange, GLAcc);
                    end;
                end;
            else
                exit;
        end;

        GLAccountNetChange."Net Change in Jnl." := GLAccountNetChange."Net Change in Jnl." + NetChange;
        GLAccountNetChange."Balance after Posting" := GLAccountNetChange."Balance after Posting" + NetChange;
        GLAccountNetChange.Modify();
    end;

    procedure InsertGLAccNetChange(var GLAccountNetChange: Record "G/L Account Net Change" temporary; var GLAcc: Record "G/L Account")
    begin
        GLAcc.CalcFields("Balance at Date");
        GLAccountNetChange.Init();
        GLAccountNetChange."No." := GLAcc."No.";
        GLAccountNetChange.Name := GLAcc.Name;
        GLAccountNetChange."Balance after Posting" := GLAcc."Balance at Date";
        GLAccountNetChange.Insert();

    end;
}
