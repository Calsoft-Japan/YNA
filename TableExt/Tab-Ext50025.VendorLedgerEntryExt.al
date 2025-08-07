tableextension 50025 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50001;"AP Account No.";Code[20])
        {
            Description = 'CS1.0';
        }
        field(50002;"Item No.";Text[50])
        {
            Description = 'CS1.0';
        }
        field(50003;"Item Description";Text[42])
        {
            Description = 'CS1.0';
        }
        field(50004;Type;Text[42])
        {
            Description = 'CS1.0';
        }
        field(50005;Size;Text[42])
        {
            Description = 'CS1.0';
        }
        field(50007;"Unit Price";Decimal)
        {
            DecimalPlaces = 4:4;
            Description = 'CS1.0';
        }
        field(50008;Quantity;Decimal)
        {
            Description = 'CS1.0';
        }
        field(50012;"new Due Date";Date)
        {
            Description = 'CS1.0';
        }
        field(50014;"Receipt Date";Date)
        {
            Description = 'CS1.0';
        }
        field(50015;"Original Receipt No.";Text[11])
        {
            Description = 'CS1.0';
        }
        field(50017;"Print Debit/Credit Memo";Boolean)
        {
            Description = 'CS1.0';
        }
        field(50018;"RMA No.";Text[42])
        {
            Description = 'CS1.0';
        }
        field(50019;"Original Document No.";Text[11])
        {
            Description = 'CS1.0';
        }
    }
}

