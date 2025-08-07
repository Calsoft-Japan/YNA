tableextension 50081 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Account Sub-code"; Code[20])
        {
            Description = 'CS1.0';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Account No."));

            trigger OnValidate()
            var
                DimTable: Record 480 temporary;
                addmin: Codeunit 50002;
            begin

                IF ("Account No." <> '') AND ("Account Sub-code" <> '') THEN BEGIN

                    DimTable.INIT;
                    DimTable."Dimension Code" := "Account No.";
                    DimTable."Dimension Value Code" := "Account Sub-code";
                    DimTable.INSERT(TRUE);


                    "Dimension Set ID" := addmin.AddDimensions("Dimension Set ID", DimTable);
                END
                ELSE IF ("Account Sub-code" = '') THEN BEGIN
                    DimTable.INIT;
                    DimTable."Dimension Code" := xRec."Account No.";
                    DimTable."Dimension Value Code" := xRec."Account Sub-code";
                    DimTable.INSERT(TRUE);


                    "Dimension Set ID" := addmin.DeleteDimensions("Dimension Set ID", DimTable);

                END;
            end;
        }
        field(50001; "AP/AR Account No."; Code[20])
        {
            Description = 'CS1.0';
            TableRelation = "G/L Account"."No." WHERE("AP/AR Account" = CONST(true));
        }
        field(50002; "Item No."; Text[50])
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
        field(50006; "Customer No."; Text[7])
        {
            Description = 'CS1.0';
        }
        field(50007; "Unit Price"; Decimal)
        {
            DecimalPlaces = 4 : 4;
            Description = 'CS1.0';
        }
        field(50008; Quantity1; Decimal)
        {
            Description = 'CS1.0';
        }
        field(50009; "System Code"; Text[2])
        {
            Description = 'CS1.0';
        }
        field(50010; "Voucher Group Code"; Text[2])
        {
            Description = 'CS1.0';
        }
        field(50011; "Description 2"; Text[62])
        {
            Description = 'CS1.0';
        }
        field(50012; "Due Date new"; Date)
        {
            Caption = 'Due Date';
            Description = 'CS1.0';
        }
        field(50013; "Department Code"; Code[3])
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
        field(50018; "RMA No."; Text[62])
        {
            Description = 'CS1.0';
        }
        field(50019; "Original Document No."; Text[11])
        {
            Description = 'CS1.0';
        }
    }
    keys
    {
        key(key12; "Bank Payment Type")
        {

        }
    }
}

