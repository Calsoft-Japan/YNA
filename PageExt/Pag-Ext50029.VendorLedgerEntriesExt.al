pageextension 50029 VendorLedgerEntriesExt extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Exported to Payment File")
        {
            //CS 2025/2/11 Channing.Zhou FDD214 Start
            field("AP Account No."; Rec."AP Account No.")
            {
                ApplicationArea = all;
                Editable = false;
                Enabled = false;
            }
            //CS 2025/2/11 Channing.Zhou FDD214 End
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = all;
            }
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = all;
            }
            field(Type; Rec.Type)
            {
                ApplicationArea = all;
            }
            field(Size; Rec.Size)
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
            field("Receipt Date"; Rec."Receipt Date")
            {
                ApplicationArea = all;
            }
            field("Original Receipt No."; Rec."Original Receipt No.")
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
            field("Original Document No."; Rec."Original Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("AppliedEntries")
        {
            action("SalesPuCrmemo")
            {
                ApplicationArea = all;
                Caption = 'Print Debit/Credit Memo';
                Image = PrintDocument;
                Scope = Repeater;
                ShortCutKey = 'Shift+F11';

                trigger OnAction()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                    GJL: Record "Gen. Journal Line" temporary;
                    SPreport: Report "Sale-Purch.Credit memo";
                    LineNo: Integer;
                begin

                    VendLedgEntry.COPY(Rec);
                    CurrPage.SETSELECTIONFILTER(VendLedgEntry);
                    LineNo := 10000;
                    if VendLedgEntry.FINDFIRST() then begin
                        REPEAT
                        //IF VendLedgEntry."Print Debit/Credit Memo" = '1' THEN
                        BEGIN
                            GJL.INIT;
                            GJL."Line No." := LineNo;
                            GJL."Account Type" := GJL."Account Type"::Vendor;
                            GJL."Account No." := VendLedgEntry."Vendor No.";
                            VendLedgEntry.CALCFIELDS(VendLedgEntry.Amount);
                            GJL.Amount := VendLedgEntry.Amount;
                            GJL."Document No." := VendLedgEntry."Document No."; // No.
                            GJL."Posting Date" := VendLedgEntry."Posting Date"; // Credit/debit memo date
                            GJL."Item No." := VendLedgEntry."Item No.";
                            GJL."Item Description" := VendLedgEntry."Item Description";
                            GJL."RMA No." := VendLedgEntry."RMA No.";
                            GJL.Quantity1 := VendLedgEntry.Quantity;
                            GJL."Unit Price" := VendLedgEntry."Unit Price";
                            GJL."Print Debit/Credit Memo" := VendLedgEntry."Print Debit/Credit Memo";
                            GJL.INSERT;
                            LineNo += 10000;
                        END
                        //ELSE
                        //BEGIN
                        //   CurrPage.UPDATE;
                        //   ERROR('This entry no.('+FORMAT(VendLedgEntry."Entry No.")+') cannot be printed as a Credit/Debit Memo.');
                        //END;

                        UNTIL VendLedgEntry.NEXT = 0;
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
            actionref("SalesPuCrmemo_Promoted"; "SalesPuCrmemo")
            {
            }
        }
    }
}
