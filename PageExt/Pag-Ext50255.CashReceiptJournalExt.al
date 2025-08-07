pageextension 50255 CashReceiptJournalExt extends "Cash Receipt Journal"
{
    layout
    {

    }
    actions
    {

        //bobby repost 50005 2025/02/27 begin
        addafter("Apply Entries")
        {
            action(TestAppliedEntries)
            {
                Caption = 'Test - Applied Entries';
                Image = PrintReport;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    //CS1.0 BEGIN
                    PrintAppliedEntries(Rec);
                    //CS1.0 END
                end;
            }
        }
        addafter("Apply Entries_Promoted")
        {
            actionref("TestAppliedEntries_Promoted"; "TestAppliedEntries")
            {
            }
        }

        //bobby repost 50005 2025/02/27 end
    }
    procedure PrintAppliedEntries(var NewGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.COPY(NewGenJnlLine);
        GenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
        REPORT.RUN(50005, TRUE, FALSE, GenJnlLine);
    end;
}
