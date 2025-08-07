pageextension 50025 CustomerLedgerEntriesExt extends "Customer Ledger Entries"
{
    layout
    {
        //CS 2025/2/11 Channing.Zhou FDD214 Start
        addafter("Remaining Amount")
        {
            field(Overpaid; Rec.Overpaid)
            {
                ApplicationArea = all;
            }
            field("Overpaid for Payment"; Rec."Overpaid for Payment")
            {
                ApplicationArea = all;
            }
        }
        //CS 2025/2/11 Channing.Zhou FDD214 End
        addafter("Direct Debit Mandate ID")
        {
            field("AR Account No."; Rec."AR Account No.")
            {
                ApplicationArea = all;
            }
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = all;
            }
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = all;
            }
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = all;
            }
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = all;
            }
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
            field("Print Debit/Credit Memo"; Rec."Print Debit/Credit Memo")
            {
                ApplicationArea = all;
            }
            field("RMA No."; Rec."RMA No.")
            {
                ApplicationArea = all;
            }
            field("Customer No. 2"; Rec."Customer No. 2")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(AppliedEntries)
        {
            action("PrintDebit")
            {
                ApplicationArea = all;
                Caption = 'Print Debit/Credit Memo';
                Image = Print;
                Scope = Repeater;

                trigger OnAction()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                    GJL: Record "Gen. Journal Line" temporary;
                    LineNo: Integer;
                    SPreport: Report "Sale-Purch.Credit memo";
                begin

                    CustLedgEntry.COPY(Rec);
                    CurrPage.SETSELECTIONFILTER(CustLedgEntry);
                    LineNo := 10000;
                    if CustLedgEntry.FINDFIRST() then begin
                        REPEAT
                            // IF CustLedgEntry."Print Debit/Credit Memo"  THEN
                            // BEGIN
                            GJL.INIT;
                            GJL."Line No." := LineNo;
                            GJL."Account Type" := GJL."Account Type"::Customer;
                            GJL."Account No." := CustLedgEntry."Customer No.";
                            CustLedgEntry.CALCFIELDS(CustLedgEntry.Amount);
                            GJL.Amount := CustLedgEntry.Amount;
                            GJL."Document No." := CustLedgEntry."Document No."; // No.
                            GJL."Posting Date" := CustLedgEntry."Posting Date"; // Credit/debit memo date
                            GJL."Item No." := CustLedgEntry."Item No.";
                            GJL."Item Description" := CustLedgEntry."Item Description";
                            GJL."RMA No." := CustLedgEntry."RMA No.";
                            GJL.Quantity1 := CustLedgEntry.Quantity;
                            GJL."Unit Price" := CustLedgEntry."Unit Price";
                            GJL."Print Debit/Credit Memo" := CustLedgEntry."Print Debit/Credit Memo";
                            GJL.INSERT;
                            LineNo += 10000;
                        //  END
                        //  ELSE
                        // BEGIN
                        //   CurrPage.UPDATE;
                        //   ERROR('This entry no.('+FORMAT(CustLedgEntry."Entry No.")+') cannot be printed as a Credit/Debit Memo.');
                        // END;
                        UNTIL CustLedgEntry.NEXT = 0;
                    end;
                    if GJL.FINDFIRST() then begin
                        SPreport.Settemptable(GJL);
                        SPreport.RUN;
                    end;
                    CurrPage.UPDATE;
                end;
            }
        }
        addafter("AppliedEntries_Promoted")
        {
            actionref("PrintDebit_Promoted"; "PrintDebit")
            {
            }
        }
    }
}
