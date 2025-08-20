pageextension 50256 PaymentJournalExt extends "Payment Journal"
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
