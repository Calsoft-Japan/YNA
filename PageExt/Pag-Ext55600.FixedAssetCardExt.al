pageextension 55600 FixedAssetCardExt extends "Fixed Asset Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                Caption = 'Department Code';
            }
            field("Purchased From"; Rec."Purchased From")
            {
                ApplicationArea = FixedAssets;
                Importance = Additional;
                ToolTip = 'Specifies when the fixed asset card was last modified.';
            }
            field("Purchase Date"; Rec."Purchase Date")
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
            field("Lease/Borrowing"; Rec."Lease/Borrowing")
            {
                ApplicationArea = All;
            }
            field("Line Code"; Rec."Line Code")
            {
                ApplicationArea = All;
            }
            field("Line Code By Process"; Rec."Line Code By Process")
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
