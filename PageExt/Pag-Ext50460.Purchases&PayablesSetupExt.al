//FDD213
pageextension 50460 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Default Posting Date")
        {
            field("Invoice Folder Path"; Rec."Invoice Folder Path")
            {
                ApplicationArea = All;
            }
        }
    }
}
