//FDD213
pageextension 50118 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter(EnableDataCheck)
        {
            field("File Folder Path"; Rec."File Folder Path")
            {
                ApplicationArea = All;
            }
        }
    }
}
