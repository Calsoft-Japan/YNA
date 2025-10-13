pageextension 50256 PaymentJournalExt extends "Payment Journal"
{
    layout
    {

    }
    actions
    {

        addafter(Post_Promoted)
        {
            actionref(CSPost_Promoted; CS_Post)
            {

            }
            actionref(CSPostPreview_Promoted; CS_Preview)
            {

            }
            actionref(PostandPrint_Promoted; "CS_Post and &Print")
            {

            }
        }

        modify(Post)
        {
            Visible = false;
        }
        modify(Preview)
        {
            Visible = false;
        }
        modify("Post and &Print")
        {
            Visible = false;
        }

        addafter(post)
        {
            action(CS_Post)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Image = PostOrder;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    Rec.SendToPosting(Codeunit::"CSGen. Jnl.-Post");
                    CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                    CurrPage.Update(false);
                end;
            }
            action(CS_Preview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                ShortCutKey = 'Ctrl+Alt+F9';
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                trigger OnAction()
                var
                    GenJnlPost: Codeunit "CSGen. Jnl.-Post";
                begin
                    GenJnlPost.Preview(Rec);
                end;
            }
            action("CS_Post and &Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post and &Print';
                Image = PostPrint;
                ShortCutKey = 'Shift+F9';
                ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    Rec.SendToPosting(Codeunit::"CSGen. Jnl.-Post+Print");
                    CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");

                    CurrPage.Update(false);
                end;
            }


        }
        modify("Void Check")
        {
            Visible = false;
        }
        modify("Void &All Checks")
        {
            Visible = false;
        }
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
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    Rec.TestField("Bank Payment Type", Rec."Bank Payment Type"::"Computer Check");
                    Rec.TestField("Check Printed", true);
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(VoidCheckQst, Rec."Document No."), true) then
                        CheckManagement.VoidCheck(Rec);
                end;
            }
            action("Void &All Checks2")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Void &All Checks';
                Image = VoidAllChecks;
                ToolTip = 'Void all checks if, for example, the checks are not cashed by the bank.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    GenJournalLine2: Record "Gen. Journal Line";
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    if ConfirmManagement.GetResponseOrDefault(VoidAllPrintedChecksQst, true) then begin
                        GenJournalLine.Reset();
                        GenJournalLine.Copy(Rec);
                        GenJournalLine.SetRange("Bank Payment Type", Rec."Bank Payment Type"::"Computer Check");
                        GenJournalLine.SetRange("Check Printed", true);
                        if GenJournalLine.Find('-') then
                            repeat
                                GenJournalLine2 := GenJournalLine;
                                CheckManagement.VoidCheck(GenJournalLine2);
                            until GenJournalLine.Next() = 0;
                    end;
                end;
            }
        }
        //bobby repost 50005 2025/02/27 begin
        addafter("ApplyEntries")
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
        addafter("Void Check_Promoted")
        {
            actionref("Void_Check2_Promoted"; "Void Check2")
            {
            }
            actionref("Void_&All_Checks2_Promoted"; "Void &All Checks2")
            {
            }
        }
        addafter("ApplyEntries_Promoted")
        {
            actionref("TestAppliedEntries_Promoted"; "TestAppliedEntries")
            {
            }
        }

        //bobby repost 50005 2025/02/27 end
    }
    var
        CheckManagement: Codeunit CheckManagementExt;
        VoidCheckQst: Label 'Void Check %1?', Comment = '%1 - check number';
        VoidAllPrintedChecksQst: Label 'Void all printed checks?';

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
