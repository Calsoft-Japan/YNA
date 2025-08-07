tableextension 50379 "Detailed Cust. Ledg. Entry Ext" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(50001; "External Document No."; Code[35])
        {
            CalcFormula = Lookup("Cust. Ledger Entry"."External Document No." WHERE("Document Type" = FIELD("Document Type"),
                                                                                     "Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
    }
}

