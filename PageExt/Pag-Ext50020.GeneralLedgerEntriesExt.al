pageextension 50020 GeneralLedgerEntriesExt extends "General Ledger Entries"
{
    layout
    {

        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        addafter("Shortcut Dimension 8 Code")
        {
            field("Account Sub-code"; Rec."Account Sub-code")
            {
                ApplicationArea = all;
            }
            field("AP/AR Account No."; Rec."AP/AR Account No.")
            {
                ApplicationArea = all;
            }
            field("RMA No."; Rec."RMA No.")
            {
                ApplicationArea = all;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
            field("Vendorcode"; Rec."Vendorcode")
            {
                ApplicationArea = all;
            }
            field(Size; Rec.Size)
            {
                ApplicationArea = all;
            }
            field("Closed at Date"; Rec."Closed at Date")
            {
                ApplicationArea = all;
            }
            field("Voucher Group Code"; Rec."Voucher Group Code")
            {
                ApplicationArea = all;
            }
            field("System Code"; Rec."System Code")
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
            field("Unit Price"; Rec."Unit Price")
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

            field("Original Document No."; Rec."Original Document No.")
            {
                ApplicationArea = all;
            }
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = all;
            }

            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = all;
            }

        }
    }
    actions
    {

    }
}
