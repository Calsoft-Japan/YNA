//CS 2025/1/15 Channing.Zhou FDD214
pageextension 50232 ApplyCustomerEntriesExt extends "Apply Customer Entries"
{
    layout
    {
        modify("Amount to Apply")
        {
            trigger OnBeforeValidate()
            begin
                if UnbindSubscription(CUCustEntryApplyPostEn) then;
            end;

            trigger OnAfterValidate()
            begin
                //BindSubscription(CUCustEntryApplyPostEn);
            end;
        }
        addafter("Amount to Apply")
        {
            field(Overpaid; Rec.Overpaid)
            {
                ApplicationArea = All;
            }
        }
    }

    var
        CUCustEntryApplyPostEn: Codeunit CustEntryApplyPostEn;

    trigger OnOpenPage()
    begin
        if BindSubscription(CUCustEntryApplyPostEn) then;
    end;

    trigger OnAfterGetRecord()
    begin
        if BindSubscription(CUCustEntryApplyPostEn) then;
    end;
}
