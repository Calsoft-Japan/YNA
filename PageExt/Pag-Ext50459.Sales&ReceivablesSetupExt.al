//FDD213
pageextension 50459 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
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
