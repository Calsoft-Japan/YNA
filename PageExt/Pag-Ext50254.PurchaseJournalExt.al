pageextension 50254 "Purchase Journal Ext" extends "Purchase Journal"
{
    layout
    {
        addafter(Comment)
        {
            field("AP/AR Account No."; Rec."AP/AR Account No.")
            {
                ApplicationArea = All;
                Caption = 'AP Account No.';
            }
            field("Item No."; Rec."Item No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
            }
            field(Type; Rec.Type)
            {
                ApplicationArea = All;
            }
            field(Size; Rec.Size)
            {
                ApplicationArea = All;
            }
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = All;
            }
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = All;
            }
            field("Receipt Date"; Rec."Receipt Date")
            {
                ApplicationArea = All;
            }
            field("Original Receipt No."; Rec."Original Receipt No.")
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
            field("Original Document No."; Rec."Original Document No.")
            {
                ApplicationArea = All;
            }
            field("Account Sub-code"; Rec."Account Sub-code")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        //CS 2025/1/13 Channing.Zhou FDD209 start
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                GenJline: Record "Gen. Journal Line" temporary;
                StrVendoLine: Text;
            BEGIN
                //    ----- begin  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
                IF Rec.FindFirst() THEN BEGIN
                    StrVendoLine := '';
                    REPEAT
                        IF (Rec."Account Type" = Rec."Account Type"::Vendor) AND (Rec."Incoming Document Entry No." = 0) THEN
                            StrVendoLine := FORMAT(Rec."Line No.") + ', '
                    UNTIL Rec.NEXT <= 0;
                    IF StrVendoLine <> '' THEN BEGIN
                        IF NOT DIALOG.CONFIRM('One or more journal lines do not have incoming document link. Do you want to continue?', FALSE, StrVendoLine) THEN
                            Error('');
                    END;
                END;
                //    ----- end  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
            END;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            var
                GenJline: Record "Gen. Journal Line" temporary;
                StrVendoLine: Text;
            BEGIN
                //    ----- begin  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
                IF Rec.FindFirst() THEN BEGIN
                    StrVendoLine := '';
                    REPEAT
                        IF (Rec."Account Type" = Rec."Account Type"::Vendor) AND (Rec."Incoming Document Entry No." = 0) THEN
                            StrVendoLine := FORMAT(Rec."Line No.") + ', '
                    UNTIL Rec.NEXT <= 0;
                    IF StrVendoLine <> '' THEN BEGIN
                        IF NOT DIALOG.CONFIRM('One or more journal lines do not have incoming document link. Do you want to continue?', FALSE, StrVendoLine) THEN
                            Error('');
                    END;
                END;
                //    ----- end  check if the Incoming Document Entry No. is empty  08042017 edit by lewis-----
            END;
        }
        //CS 2025/1/13 Channing.Zhou FDD209 end
        //CS 2024/12/22 Channing.Zhou FDD213 start
        addafter("Test Report")
        {
            action("Create Invoice File Link")
            {
                ApplicationArea = All;
                Caption = 'Create &Invoice File Link';
                Image = Links;
                trigger OnAction()
                var
                    purchPaySetup: Record "Purchases & Payables Setup";
                    localfilename: Text[250];
                    errormessage: Text[250];
                    Incommingdoc: Record "Incoming Document";
                    LocalInvocieNumber: Text[40];
                begin
                    Rec.LOCKTABLE();
                    purchPaySetup.GET;
                    errormessage := '';
                    if not Rec.IsEmpty() then begin
                        IF Rec.FindSet() THEN
                            REPEAT
                                IF Rec."Account Type" = Rec."Account Type"::Vendor THEN BEGIN
                                    localfilename := purchPaySetup."Invoice Folder Path" + '/' + Rec."Account No." + '-' + DELCHR(COPYSTR(Rec."External Document No.", 1, 20), '<>') + '.PDF';
                                    //Ignore  the file exists checking logic currently, if the clients need to add the logic, need to add code unit for based operation to sharepoint.
                                    /*IF NOT FILE.EXISTS(localfilename) THEN BEGIN
                                        errormessage := errormessage + '' + Rec."Account No." + '-' + DELCHR(COPYSTR(Rec."External Document No.", 1, 20), '<>') + '.PDF, '
                                    END;*/
                                END;
                            UNTIL Rec.NEXT <= 0;

                        IF errormessage <> '' THEN BEGIN
                            IF NOT DIALOG.CONFIRM('The following file(s) could not be found: %1 Do you want to continue?', TRUE, errormessage) THEN BEGIN
                                EXIT;
                            END;
                        END;


                        IF Rec.FindSet() THEN
                            REPEAT
                                IF Rec."Account Type" = Rec."Account Type"::Vendor THEN BEGIN
                                    localfilename := purchPaySetup."Invoice Folder Path" + '/' + Rec."Account No." + '-' + DELCHR(COPYSTR(Rec."External Document No.", 1, 20), '<>') + '.PDF';
                                    LocalInvocieNumber := Rec."Account No." + '-' + DELCHR(COPYSTR(Rec."External Document No.", 1, 20), '<>');
                                    Incommingdoc.RESET;
                                    Incommingdoc.SETRANGE(Incommingdoc.Status, Incommingdoc.Status::New);
                                    Incommingdoc.SETRANGE(Incommingdoc."Journal Document No.", Rec."Document No.");
                                    Incommingdoc.SETRANGE(Incommingdoc."Journal Line No.", Rec."Line No.");
                                    IF Incommingdoc.FindFirst() THEN BEGIN
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
                end;
            }
        }
        addafter("Apply Entries_Promoted")
        {
            actionref("Create Invoice File Link_Promoted"; "Create Invoice File Link")
            {
            }
        }
        //CS 2025/12/22 Channing.Zhou FDD213 end
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
}
