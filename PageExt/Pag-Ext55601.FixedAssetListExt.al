pageextension 55601 FixedAssetListExt extends "Fixed Asset List"
{
    layout
    {
        addafter(Acquired)
        {
            field("Acquisition Cost"; Rec."Acquisition Cost")
            {
                ApplicationArea = All;
            }
            field("Accumulated Depreciation"; Rec."Accumulated Depreciation")
            {
                ApplicationArea = All;
            }
            field("Book Value"; Rec."Book Value")
            {
                ApplicationArea = All;
            }
            field("Disposal Date"; Rec."Disposal Date")
            {
                ApplicationArea = All;
            }
            field("Depreciation Starting Date"; Rec."Depreciation Starting Date")
            {
                ApplicationArea = All;
            }
            field("Depreciation Ending Date"; Rec."Depreciation Ending Date")
            {
                ApplicationArea = All;
            }
            field("Machine No."; Rec."Machine No.")
            {
                ApplicationArea = All;
            }
            field("Drawing No."; Rec."Drawing No.")
            {
                ApplicationArea = All;
            }
            field("Line Code"; Rec."Line Code")
            {
                ApplicationArea = All;
            }
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
        }
    }
}
