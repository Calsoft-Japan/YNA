tableextension 50021 "Cust. Ledger Entry Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        modify("Amount to Apply")
        {
            trigger OnBeforeValidate()
            var
                recpoh: Record "Purchase Header";
            begin
                //IF ABS(Rec."Amount to Apply"/* + Rec.Overpaid*/) > ABS(Rec."Remaining Amount") THEN BEGIN
                // 20170329 by JWU
                //    Rec.Overpaid := ABS(Rec."Amount to Apply"/* + Rec.Overpaid*/) - ABS(Rec."Remaining Amount");
                //    Rec."Amount to Apply" := ABS(Rec."Remaining Amount");
                //    Rec.Modify();
                //END ELSE begin
                //    IF ABS(Rec."Amount to Apply"/* + Rec.Overpaid*/) <= ABS(Rec."Remaining Amount") THEN begin
                //        Rec."Amount to Apply" := ABS(Rec."Amount to Apply"/* + Rec.Overpaid*/);
                //        Rec.Overpaid := 0;
                //        Rec.Modify();
                //    end
                //end;
            end;
        }
        field(50001; "AR Account No."; Code[20])
        {
            Description = 'CS1.0';
        }
        field(50002; "Item No."; Text[50])
        {
            Description = 'CS1.0';
        }
        field(50003; "Item Description"; Text[42])
        {
            Description = 'CS1.0';
        }
        field(50006; "Customer No. 2"; Text[7])
        {
            Description = 'CS1.0';
        }
        field(50007; "Unit Price"; Decimal)
        {
            DecimalPlaces = 4 : 4;
            Description = 'CS1.0';
        }
        field(50008; Quantity; Decimal)
        {
            Description = 'CS1.0';
        }
        field(50011; "Description 2"; Text[62])
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
        field(50020; Overpaid; Decimal)
        {
            Description = 'CS1.0';
        }
        field(50021; "Overpaid for Payment"; Decimal)
        {
            CalcFormula = Sum("Cust. Ledger Entry".Overpaid WHERE("Document Type" = FILTER(<> Payment),
                                                                   "Closed by Entry No." = FIELD("Entry No.")));
            Description = 'CS1.0';
            Editable = true;
            Enabled = true;
            FieldClass = FlowField;
        }
        field(50022; "Original Amount2"; Decimal)
        {
            CalcFormula = Lookup("Detailed Cust. Ledg. Entry".Amount WHERE("Cust. Ledger Entry No." = FIELD("Credit Memo Entry No."),
                                                                            "Entry Type" = CONST("Initial Entry")));
            Description = 'CS1.0';
            FieldClass = FlowField;
        }
        field(50023; "Credit Memo Entry No."; Integer)
        {
            CalcFormula = Lookup("Cust. Ledger Entry"."Entry No." WHERE("Closed by Entry No." = FIELD("Entry No."),
                                                                         "Journal Batch Name" = CONST('MSR'),
                                                                         "Document Type" = CONST("Credit Memo"),
                                                                         "Original Document No." = CONST('YES')));
            Description = 'CS1.0';
            FieldClass = FlowField;
        }
    }
}

