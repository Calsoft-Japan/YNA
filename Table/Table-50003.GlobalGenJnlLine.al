table 50003 "GlobalGenJnlLine"
{

    Caption = 'GlobalGenJnlLine';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            //AutoIncrement = true;
        }
        field(2; "User ID"; Code[50])
        {
        }
        field(3; "Original Document No."; Text[11])
        {
        }
        field(4; "Journal Template Name"; Code[10])
        {
        }
        field(5; "Account Type"; Enum "Gen. Journal Account Type")
        {
        }
        field(6; "Document No."; Code[20])
        {
        }
        field(7; "Account No."; Code[20])
        {
        }
        field(8; "External Document No."; Code[35])
        {
        }
        field(9; "AP/AR Account No."; Code[20])
        {
        }
        field(10; "Document Type"; Enum "Gen. Journal Document Type")
        {
        }

        field(11; "GLReg EntryNo"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }


}

