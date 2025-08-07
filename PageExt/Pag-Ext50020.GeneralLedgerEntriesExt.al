pageextension 50020 GeneralLedgerEntriesExt extends "General Ledger Entries"
{
    layout
    {

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
        }
    }
    actions
    {

    }
}
