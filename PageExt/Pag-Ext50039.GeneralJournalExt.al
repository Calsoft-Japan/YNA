pageextension 50039 GeneralJournalExt extends "General Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field("Account Sub-code"; Rec."Account Sub-code")
            {
                StyleExpr = StyleTxt;
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    Rec.ShowShortcutDimCode(ShortcutDimCode);
                    SetUserInteractions;
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    actions
    {

        modify(PostAndPrint)
        {
            //Visible = true;
            trigger OnBeforeAction()
            var
                GenJline: Record "Gen. Journal Line" temporary;
                strCustLine: Text;
            BEGIN
                //    ----- begin  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
                IF Rec.FindFirst() THEN BEGIN
                    strCustLine := '';
                    REPEAT
                        IF (Rec."Account Type" in [Rec."Account Type"::Customer, Rec."Account Type"::Vendor]) AND (Rec."Incoming Document Entry No." = 0) THEN
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

        //CS 2025/5/21 Channing.Zhou FDD213 start
        addafter("Test Report")
        {
            action("Create File Link")
            {
                ApplicationArea = All;
                Caption = 'Create File Link';
                Image = Links;
                trigger OnAction()
                VAR
                    GenPaySetup: Record "General Ledger Setup";
                    localfilename: Text[250];
                    errormessage: Text[250];
                    Incommingdoc: Record "Incoming Document";
                    LocalInvocieNumber: Text[40];
                BEGIN
                    Rec.LOCKTABLE();
                    GenPaySetup.GET;
                    if not Rec.IsEmpty() then begin
                        IF Rec.FindSet() THEN
                            REPEAT
                                //IF Rec."Account Type" = Rec."Account Type"::Customer THEN BEGIN
                                localfilename := GenPaySetup."File Folder Path" + '/' + Rec."Document No." + '.PDF';// + '.*';
                                LocalInvocieNumber := Rec."Document No.";
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
                            //END;
                            UNTIL Rec.NEXT = 0;
                    end;
                END;
            }
        }
        addafter("Apply Entries_Promoted")
        {
            actionref("Create File Link_Promoted"; "Create File Link")
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
        }
        addafter("Apply Entries_Promoted")
        {
            actionref("ImportData_Promoted"; "ImportData")
            {
            }
        }
        //bobby FDD102 end
    }
    var
        StyleTxt: Text;
        GenJnlManagement: Codeunit GenJnlManagement;
}
