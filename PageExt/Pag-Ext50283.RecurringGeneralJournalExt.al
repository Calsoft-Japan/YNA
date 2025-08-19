pageextension 50283 RecurringGeneralJournalExt extends "Recurring General Journal"
{
    layout
    {

        addafter("Account No.")
        {
            field("AP/AR Account No."; Rec."AP/AR Account No.")
            {
                ApplicationArea = all;
            }
            field("Account Sub-code"; Rec."Account Sub-code")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
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
        addafter("Allocations_Promoted")
        {
            actionref("Create File Link_Promoted"; "Create File Link")
            {
            }
        }
        //CS 2025/5/21 Channing.Zhou FDD213 end
    }
}
