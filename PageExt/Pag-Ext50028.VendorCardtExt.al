pageextension 50028 VendorCardExt extends "Vendor Card"
{
    layout
    {
        addafter("VAT Registration No.")
        {
            field("CS_IRS 1099 Code"; Rec."CS_IRS 1099 Code")
            {
                Caption = 'IRS 1099 Code';
                ApplicationArea = all;
            }
        }
    }
    actions
    {
    }
}
