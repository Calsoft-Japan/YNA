pageextension 50253 SalesJournalExt extends "Sales Journal"
{
    layout
    {
        addafter("Direct Debit Mandate ID")
        {
            field("AP/AR Account No."; Rec."AP/AR Account No.")
            {
                Caption = 'AR Account No.';
                ApplicationArea = All;
            }
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
            }
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
            }
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = All;
            }
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
            }
            field("Print Debit/Credit Memo"; Rec."Print Debit/Credit Memo")
            {
                ApplicationArea = All;
            }
            field("RMA No."; Rec."RMA No.")
            {
                ApplicationArea = All;
            }
            field("Account Sub-code"; Rec."Account Sub-code")
            {
                ApplicationArea = All;
            }
            field("Original Document No."; Rec."Original Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        //CS lewis 20250908 hide post and show post customization.
        addafter(Post)
        {
            action(CS_Post)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Image = PostOrder;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                Visible = true;

                trigger OnAction()
                var
                    GenJline: Record "Gen. Journal Line" temporary;
                    strCustLine: Text;
                begin
                    //    ----- begin  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
                    IF Rec.FindFirst() THEN BEGIN
                        strCustLine := '';
                        REPEAT
                            IF (Rec."Account Type" = Rec."Account Type"::Customer) AND (Rec."Incoming Document Entry No." = 0) THEN
                                strCustLine := FORMAT(Rec."Line No.") + ', '
                                      UNTIL Rec.NEXT <= 0;
                        IF strCustLine <> '' THEN BEGIN
                            IF NOT DIALOG.CONFIRM('One or more journal lines do not have incoming document link. Do you want to continue?', FALSE, strCustLine) THEN
                                EXIT;
                        END;
                    END;
                    //    ----- end  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----

                    Rec.SendToPosting(Codeunit::"CSGen. Jnl.-Post");
                    CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                    SetJobQueueVisibility();
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
                var
                    GenJline: Record "Gen. Journal Line" temporary;
                    strCustLine: Text;
                begin
                    //    ----- begin  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
                    IF Rec.FindFirst() THEN BEGIN
                        strCustLine := '';
                        REPEAT
                            IF (Rec."Account Type" = Rec."Account Type"::Customer) AND (Rec."Incoming Document Entry No." = 0) THEN
                                strCustLine := FORMAT(Rec."Line No.") + ', '
                                      UNTIL Rec.NEXT <= 0;
                        IF strCustLine <> '' THEN BEGIN
                            IF NOT DIALOG.CONFIRM('One or more journal lines do not have incoming document link. Do you want to continue?', FALSE, strCustLine) THEN
                                EXIT;
                        END;
                    END;
                    //    ----- end  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----

                    Rec.SendToPosting(Codeunit::"CSGen. Jnl.-Post+Print");
                    CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                    SetJobQueueVisibility();
                    CurrPage.Update(false);
                end;
            }

        }
        //CS 2025/1/13 Channing.Zhou FDD209 start
        modify(Post)
        {
            Visible = false;
            trigger OnBeforeAction()
            var
                GenJline: Record "Gen. Journal Line" temporary;
                strCustLine: Text;
            BEGIN
                //    ----- begin  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
                IF Rec.FindFirst() THEN BEGIN
                    strCustLine := '';
                    REPEAT
                        IF (Rec."Account Type" = Rec."Account Type"::Customer) AND (Rec."Incoming Document Entry No." = 0) THEN
                            strCustLine := FORMAT(Rec."Line No.") + ', '
                                  UNTIL Rec.NEXT <= 0;
                    IF strCustLine <> '' THEN BEGIN
                        IF NOT DIALOG.CONFIRM('One or more journal lines do not have incoming document link. Do you want to continue?', FALSE, strCustLine) THEN
                            EXIT;
                    END;
                END;
                //    ----- end  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
            END;
        }

        modify(Preview)
        {
            Visible = false;
        }

        modify("Post and &Print")
        {
            Visible = false;
            trigger OnBeforeAction()
            var
                GenJline: Record "Gen. Journal Line" temporary;
                strCustLine: Text;
            BEGIN
                //    ----- begin  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
                IF Rec.FindFirst() THEN BEGIN
                    strCustLine := '';
                    REPEAT
                        IF (Rec."Account Type" = Rec."Account Type"::Customer) AND (Rec."Incoming Document Entry No." = 0) THEN
                            strCustLine := FORMAT(Rec."Line No.") + ', '
                                  UNTIL Rec.NEXT <= 0;
                    IF strCustLine <> '' THEN BEGIN
                        IF NOT DIALOG.CONFIRM('One or more journal lines do not have incoming document link. Do you want to continue?', FALSE, strCustLine) THEN
                            EXIT;
                    END;
                END;
                //    ----- end  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
            END;
        }
        //CS 2025/1/13 Channing.Zhou FDD209 end
        //CS 2025/5/21 Channing.Zhou FDD213 start
        addafter("Test Report")
        {
            action("Create Invoice File Link")
            {
                ApplicationArea = All;
                Caption = 'Create &Invoice File Link';
                Image = Links;
                trigger OnAction()
                VAR
                    SalesPaySetup: Record "Sales & Receivables Setup";
                    localfilename: Text[250];
                    errormessage: Text[250];
                    Incommingdoc: Record "Incoming Document";
                    LocalInvocieNumber: Text[40];
                BEGIN
                    Rec.LOCKTABLE();
                    SalesPaySetup.GET;
                    if not Rec.IsEmpty() then begin
                        IF Rec.FindSet() THEN
                            REPEAT
                                IF Rec."Account Type" = Rec."Account Type"::Customer THEN BEGIN
                                    localfilename := SalesPaySetup."Invoice Folder Path" + '/' + Rec."Account No." + '_' + DELCHR(COPYSTR(Rec."External Document No.", 1, 13), '<>') + '.PDF';
                                    LocalInvocieNumber := Rec."Account No." + '_' + DELCHR(COPYSTR(Rec."External Document No.", 1, 13), '<>');
                                    Incommingdoc.RESET;
                                    Incommingdoc.SETRANGE(Status, Incommingdoc.Status::New);
                                    Incommingdoc.SETRANGE(Incommingdoc."Journal Document No.", Rec."Document No.");
                                    Incommingdoc.SETRANGE(Incommingdoc."Journal Line No.", Rec."Line No.");
                                    IF Incommingdoc.FIND('-') THEN BEGIN
                                        Incommingdoc.DELETE(TRUE);
                                    END;
                                    Incommingdoc.RESET;
                                    Incommingdoc.INIT;
                                    Incommingdoc."Entry No." := 0;
                                    Incommingdoc."Document No." := Rec."Document No.";
                                    Incommingdoc."Posting Date" := Rec."Posting Date";
                                    Incommingdoc."Journal Document No." := Rec."Document No.";
                                    Incommingdoc."Journal Line No." := Rec."Line No.";
                                    Incommingdoc.Description := LocalInvocieNumber;
                                    Incommingdoc.SetURL(localfilename);
                                    Incommingdoc.INSERT(TRUE);
                                    Rec."Incoming Document Entry No." := Incommingdoc."Entry No.";
                                    Rec.MODIFY(TRUE);
                                END;
                            UNTIL Rec.NEXT = 0;
                    end;
                END;
            }
        }
        addafter("Apply Entries_Promoted")
        {
            actionref("Create Invoice File Link_Promoted"; "Create Invoice File Link")
            {
            }


        }
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
        //CS 2025/5/21 Channing.Zhou FDD213 end
        //bobby FDD102 begin
        addafter("Apply Entries")
        {
            action("ImportData")
            {
                Caption = 'Import Data';
                Image = Import;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ImportGen: Codeunit ImportAPARVendor;
                begin
                    // hcj CS1.0
                    ImportGen.ImportGenJournalLine();
                    // HCJ CS1.0 END;
                end;
            }
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
            actionref("ImportData_Promoted"; "ImportData")
            {
            }
            actionref("TestAppliedEntries_Promoted"; "TestAppliedEntries")
            {
            }
        }
        addafter("Post and &Print_Promoted")
        {
            actionref("Test Report_Promoted"; "Test Report")
            {
            }
        }
        //bobby FDD102 end
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
