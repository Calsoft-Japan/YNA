pageextension 50374 CheckLedgerEntriesExt extends "Check Ledger Entries"
{
    layout
    {

    }
    actions
    {

        modify("Void Check")
        {
            Visible = false;
        }
        //bobby repost 50005 2025/02/27 begin
        addafter("Void Check")
        {
            action("Void Check2")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Void Check';
                Image = VoidCheck;
                ToolTip = 'Void the check if, for example, the check is not cashed by the bank.';

                trigger OnAction()
                var
                    CheckManagement: Codeunit CheckManagementExt;
                begin
                    CheckManagement.FinancialVoidCheck(Rec);
                end;
            }
        }
        addafter("Void Check_Promoted")
        {
            actionref("Void_Check2_Promoted"; "Void Check2")
            {
            }
        }

        //bobby repost 50005 2025/02/27 end
    }
}
