table 50001 "TempGLEntryBuf"
{

    Caption = 'TempGLEntryBuf';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Source Code"; Code[10])
        {
        }
        field(3; "User ID"; Code[50])
        {
        }
        field(4; "Temp Entry No."; Integer)
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

