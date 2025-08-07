//CS 2025/2/11 Channing.Zhou FDD214
pageextension 50061 AppliedCustomerEntriesExt extends "Applied Customer Entries"
{
    layout
    {
        addafter("Closed by Amount")
        {
            field(Overpaid; Rec.Overpaid)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("Clear &Overpaid")
            {
                ApplicationArea = all;
                Caption = 'Clear &Overpaid';
                Image = ReturnCustomerBill;

                trigger OnAction()
                var
                    RecCLE: Record "Cust. Ledger Entry";
                BEGIN
                    RecCLE.COPY(Rec);
                    CurrPage.SETSELECTIONFILTER(RecCLE);
                    IF not RecCLE.IsEmpty() THEN BEGIN
                        RecCLE.FindSet();
                        REPEAT
                            RecCLE.Overpaid := 0;
                            RecCLE.MODIFY();
                        UNTIL RecCLE.NEXT = 0;
                    END;
                END;
            }
        }
        addafter("&Navigate_Promoted")
        {
            actionref("Clear &Overpaid_Promoted"; "Clear &Overpaid")
            {
            }
        }
    }
}
