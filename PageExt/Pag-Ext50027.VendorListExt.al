pageextension 50027 VendorListExt extends "Vendor List"
{
    layout
    {

    }
    actions
    {
        addbefore("Payment Journal")
        {
            action("DataImport")
            {
                Caption = 'Data Import';
                Image = Import;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ImportVendor: Codeunit ImportAPARVendor;
                begin
                    // hcj CS1.0
                    ImportVendor.ImportVendor();
                    // HCJ CS1.0 END;
                end;
            }
        }
    }
}
