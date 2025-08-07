table 50000 "Interface Message"
{

    Caption = 'Interface Message';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Data Type"; Option)
        {
            OptionCaption = 'Import,Export';
            OptionMembers = Import,Export;
        }
        field(3; "Data Name"; Option)
        {
            OptionCaption = 'Vendor,GL/AP/AR,G/L Entry,Fixed Asset,FA Projection';
            OptionMembers = Vendor,"GL/AP/AR","G/L Entry","Fixed Asset","FA Projection";
        }
        field(4; "Created At"; DateTime)
        {
        }
        field(5; "Message"; Text[250])
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

