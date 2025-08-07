tableextension 50017 "G/L Entry Ext" extends "G/L Entry"
{
    fields
    {
        field(50000; "Voucher Group Code"; Code[20])
        {
            Description = 'CS1.0';
        }
        field(50001; "System Code"; Code[20])
        {
            Description = 'CS1.0';
        }
        field(50002; "applyEntryNo."; Integer)
        {
            Description = 'CS1.0';
        }
        field(50003; "Item Description"; Text[42])
        {
            Description = 'CS1.0';
        }
        field(50004; Type; Text[42])
        {
            Description = 'CS1.0';
        }
        field(50005; Size; Text[42])
        {
            Description = 'CS1.0';
        }
        field(50007; "Unit Price"; Decimal)
        {
            DecimalPlaces = 4 : 4;
            Description = 'CS1.0';
        }
        field(50012; "Due Date"; Date)
        {
            Description = 'CS1.0';
        }
        field(50014; "Receipt Date"; Date)
        {
            Description = 'CS1.0';
        }
        field(50015; "Original Receipt No."; Text[11])
        {
            Description = 'CS1.0';
        }
        field(50017; "Print Debit/Credit Memo"; Boolean)
        {
            Description = 'CS1.0';
        }
        field(50018; "RMA No."; Text[42])
        {
            Description = 'CS1.0';
        }
        field(50019; "Original Document No."; Text[11])
        {
            Description = 'CS1.0';
        }
        field(50020; "Item No."; Text[50])
        {
            Description = 'CS1.0';
        }
        field(50021; "Customer No."; Text[7])
        {
            Description = 'CS1.0';
        }
        field(50022; "Description 2"; Text[62])
        {
        }
        field(50023; "AP/AR Account No."; Code[20])
        {
            Description = 'CS1.0';
        }
        field(50024; "Account Sub-code"; Code[20])
        {
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" WHERE("Dimension Set ID" = FIELD("Dimension Set ID"),
                                                                                     "Dimension Code" = FIELD("G/L Account No.")));
            Description = 'CS1.0';
            FieldClass = FlowField;
        }
        field(50025; Customercode; Code[20])
        {
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" WHERE("Dimension Set ID" = FIELD("Dimension Set ID"),
                                                                                     "Dimension Code" = CONST('CUSTOMERCODE')));
            Description = 'CS1.0';
            FieldClass = FlowField;
        }
        field(50026; Vendorcode; Code[20])
        {
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" WHERE("Dimension Set ID" = FIELD("Dimension Set ID"),
                                                                                     "Dimension Code" = CONST('VENDORCODE')));
            Description = 'CS1.0';
            FieldClass = FlowField;
        }
        field(50027; "Closed at Date"; Date)
        {
            CalcFormula = Lookup("Vendor Ledger Entry"."Closed at Date" WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
    }
}

