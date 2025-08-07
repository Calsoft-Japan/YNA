tableextension 55600 "Fixed Asset Ext" extends "Fixed Asset"
{
    fields
    {
        field(50000; "Acquisition Cost"; Decimal)
        {
            CalcFormula = Sum("FA Ledger Entry".Amount WHERE("FA No." = FIELD("No."),
                                                              "Depreciation Book Code" = CONST('FINANCIAL'),
                                                              "FA Posting Type" = CONST("Acquisition Cost"),
                                                              "Part of Book Value" = CONST(true)));
            Description = 'CS1.0';
            FieldClass = FlowField;
        }
        field(50001; "Accumulated Depreciation"; Decimal)
        {
            CalcFormula = - Sum("FA Ledger Entry".Amount WHERE("FA No." = FIELD("No."),
                                                               "Depreciation Book Code" = CONST('FINANCIAL'),
                                                               "FA Posting Type" = CONST(Depreciation),
                                                               "Part of Book Value" = CONST(true)));
            Description = 'CS1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Purchased From"; Code[20])
        {
            Description = 'CS1.0';
            TableRelation = Vendor."No.";
        }
        field(50003; "Purchase Date"; Date)
        {
            Description = 'CS1.0';
        }
        field(50004; "Machine No."; Text[10])
        {
            Description = 'CS1.0';
        }
        field(50005; "Drawing No."; Text[11])
        {
            Description = 'CS1.0';
        }
        field(50006; "Lease/Borrowing"; Option)
        {
            Description = 'CS1.0';
            OptionMembers = " ","1","2";
        }
        field(50007; "Line Code"; Code[4])
        {
            Description = 'CS1.0';
        }
        field(50008; "Line Code By Process"; Code[3])
        {
            Description = 'CS1.0';
        }
        field(50009; Remarks; Text[42])
        {
            Description = 'CS1.0';
        }
        field(50010; "Book Value"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("FA Ledger Entry".Amount WHERE("FA No." = FIELD("No."),
                                                              "Depreciation Book Code" = CONST('FINANCIAL'),
                                                              "FA Posting Type" = FILTER("Acquisition Cost" | Depreciation | "Write-Down" | Appreciation)));
            Description = 'CS1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Depreciation Starting Date"; Date)
        {
            CalcFormula = Lookup("FA Depreciation Book"."Depreciation Starting Date" WHERE("FA No." = FIELD("No."),
                                                                                            "Depreciation Book Code" = CONST('FINANCIAL')));
            Description = 'CS1.0';
            FieldClass = FlowField;
        }
        field(50012; "Depreciation Ending Date"; Date)
        {
            CalcFormula = Lookup("FA Depreciation Book"."Depreciation Ending Date" WHERE("FA No." = FIELD("No."),
                                                                                          "Depreciation Book Code" = CONST('FINANCIAL')));
            Description = 'CS1.0';
            FieldClass = FlowField;
        }
        field(50013; "Disposal Date"; Date)
        {
            CalcFormula = Lookup("FA Depreciation Book"."Disposal Date" WHERE("FA No." = FIELD("No."),
                                                                               "Depreciation Book Code" = CONST('FINANCIAL')));
            Description = 'CS1.0';
            FieldClass = FlowField;
        }
    }
}

