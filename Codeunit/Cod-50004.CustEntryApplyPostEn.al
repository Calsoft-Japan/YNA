codeunit 50004 CustEntryApplyPostEn
{
    TableNo = "Cust. Ledger Entry";
    EventSubscriberInstance = Manual; //CS 2025/1/15 Channing.Zhou FDD214

    trigger OnRun()
    begin


        ApplyingCustLedgEntry.RESET;
        ApplyingCustLedgEntry.SETRANGE("Entry No.", Rec."Entry No.");
        IF ApplyingCustLedgEntry.FIND('-') THEN BEGIN

            //IF ApplyingCustLedgEntry."Applies-to ID"  = '' THEN
            BEGIN
                GLReg.RESET;
                //GLReg.SETRANGE("Source Code",'PURCHJNL');  //PURCHASES // comment out 07112016 hcj
                GLReg.SETFILTER("From Entry No.", '<=' + FORMAT(ApplyingCustLedgEntry."Entry No."));
                GLReg.SETFILTER("To Entry No.", '>=' + FORMAT(ApplyingCustLedgEntry."Entry No."));
                IF GLReg.FIND('-') THEN BEGIN
                    CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive);
                    IF ApplyingCustLedgEntry."External Document No." <> '' THEN  //08182016 hcj
                    BEGIN
                        CustLedgEntry.SETFILTER("External Document No.",
                             COPYSTR(ApplyingCustLedgEntry."External Document No.", 1, STRLEN(ApplyingCustLedgEntry."External Document No.") - 12) + '*');
                        CustLedgEntry.SETRANGE("AR Account No.", ApplyingCustLedgEntry."AR Account No.");
                    END
                    ELSE
                        CustLedgEntry.SETRANGE("Document No.", ApplyingCustLedgEntry."Original Document No.");
                    CustLedgEntry.SETRANGE(Open, TRUE);
                    CustLedgEntry.SETFILTER("Entry No.", FORMAT(GLReg."From Entry No.") + '..' + FORMAT(GLReg."To Entry No."));
                    CustLedgEntry.SETRANGE("Customer No.", ApplyingCustLedgEntry."Customer No.");
                    CustLedgEntry.SETFILTER("Document Type", '<>' + FORMAT(ApplyingCustLedgEntry."Document Type"));
                    IF CustLedgEntry.FINDFIRST THEN BEGIN

                        IF ApplyingCustLedgEntry."Remaining Amount" = 0 THEN
                            ApplyingCustLedgEntry.CALCFIELDS("Remaining Amount");

                        ApplyingCustLedgEntry."Applying Entry" := TRUE;
                        IF ApplyingCustLedgEntry."Applies-to ID" = '' THEN
                            ApplyingCustLedgEntry."Applies-to ID" := ApplyingCustLedgEntry."Document No.";// ApplyingCustLedgEntry."Original Document No.";

                        ApplyingCustLedgEntry."Amount to Apply" := ApplyingCustLedgEntry."Remaining Amount";
                        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", ApplyingCustLedgEntry);
                        //COMMIT;

                        // set apply to id
                        SetApplytoID.SetApplId(CustLedgEntry, ApplyingCustLedgEntry, ApplyingCustLedgEntry."Document No.");//ApplyingCustLedgEntry."Original Document No.");
                        //COMMIT;
                    END;


                    ActionPerformed := ApplyingCustLedgEntry."Applies-to ID" <> '';// CustLedgEntry."Applies-to ID" <> '';
                    IF ActionPerformed THEN BEGIN
                        PostDirectApplication();
                    END;
                END;
            END;
        END;
    end;

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry";
        SetApplytoID: Codeunit "Cust. Entry-SetAppl.ID";
        ActionPerformed: Boolean;
        recCustledgrEntry: Record "Cust. Ledger Entry";
        PurchInvLine: Record "Purch. Inv. Line";
        Text012: Label 'The application was successfully posted.';
        Text013: Label 'The %1 entered must not be before the %1 on the %2.';
        Text019: Label 'Post application process has been canceled.';
        GLReg: Record "G/L Register";

    local procedure PostDirectApplication()
    var
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        ApplicationDate: Date;
        NewApplicationDate: Date;
        NewDocumentNo: Code[20];
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
    begin
        IF ApplyingCustLedgEntry."Entry No." <> 0 THEN BEGIN
            recCustledgrEntry := ApplyingCustLedgEntry;
            ApplicationDate := CustEntryApplyPostedEntries.GetApplicationDate(recCustledgrEntry);
            PostApplication.SetValues(ApplyingCustLedgEntry."Document No.", ApplicationDate);
            //IF ACTION::OK = PostApplication.RUNMODAL THEN BEGIN
            PostApplication.GetValues(NewDocumentNo, NewApplicationDate);
            IF NewApplicationDate < ApplicationDate THEN
                ERROR(Text013, recCustledgrEntry.FIELDCAPTION("Posting Date"), recCustledgrEntry.TABLECAPTION);

            //END ELSE
            //  ERROR(Text019);

            CustEntryApplyPostedEntries.Apply(recCustledgrEntry, ApplyUnapplyParameters);
            //CustEntryApplyPostedEntries.Apply(recCustledgrEntry, NewDocumentNo, NewApplicationDate);
            // MESSAGE(Text012);


        END;
    end;

    //CS 2025/1/15 Channing.Zhou FDD214
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", OnValidateAmounttoApplyBeforeFieldError, '', true, true)]
    local procedure OnValidateAmounttoApplyBeforeFieldError(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        IF ABS(CustLedgerEntry."Amount to Apply" /*+ CustLedgerEntry.Overpaid*/) >= ABS(CustLedgerEntry."Remaining Amount") THEN BEGIN
            // 20170329 by JWU
            CustLedgerEntry.Overpaid := (CustLedgerEntry."Amount to Apply" /*+ CustLedgerEntry.Overpaid*/) - CustLedgerEntry."Remaining Amount";
            CustLedgerEntry."Amount to Apply" := CustLedgerEntry."Remaining Amount";
            CustLedgerEntry.Modify();
        END ELSE begin
            IF ABS(CustLedgerEntry."Amount to Apply" /*+ CustLedgerEntry.Overpaid*/) < ABS(CustLedgerEntry."Remaining Amount") THEN begin
                CustLedgerEntry."Amount to Apply" := CustLedgerEntry."Amount to Apply";// + CustLedgerEntry.Overpaid;
                CustLedgerEntry.Overpaid := 0;
                CustLedgerEntry.Modify();
            end
        end;
    end;
}

