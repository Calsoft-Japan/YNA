codeunit 50003 VendEntryApplyPostEn
{
    TableNo = "Vendor Ledger Entry";

    trigger OnRun()
    var
        VendLedgEntryNo: Integer;
    begin


        ApplyingVendLedgEntry.RESET;
        ApplyingVendLedgEntry.SETRANGE("Entry No.", Rec."Entry No.");
        IF ApplyingVendLedgEntry.FIND('-') THEN BEGIN

            //IF ApplyingVendLedgEntry."Applies-to ID"  = '' THEN
            BEGIN
                GLReg.RESET;
                //GLReg.SETRANGE("Source Code",'PURCHJNL');  //PURCHASES // comment out 07112016 hcj
                GLReg.SETFILTER("From Entry No.", '<=' + FORMAT(ApplyingVendLedgEntry."Entry No."));
                GLReg.SETFILTER("To Entry No.", '>=' + FORMAT(ApplyingVendLedgEntry."Entry No."));
                IF GLReg.FIND('-') THEN BEGIN
                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                    IF ApplyingVendLedgEntry."External Document No." <> '' THEN  //08182016 hcj
                    BEGIN
                        VendLedgEntry.SETFILTER("External Document No.",
                             COPYSTR(ApplyingVendLedgEntry."External Document No.", 1, STRLEN(ApplyingVendLedgEntry."External Document No.") - 15) + '*');
                        VendLedgEntry.SETRANGE("AP Account No.", ApplyingVendLedgEntry."AP Account No.");
                    END
                    ELSE
                        VendLedgEntry.SETRANGE("Document No.", ApplyingVendLedgEntry."Original Document No.");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    VendLedgEntry.SETFILTER("Entry No.", FORMAT(GLReg."From Entry No.") + '..' + FORMAT(GLReg."To Entry No."));
                    VendLedgEntry.SETRANGE("Vendor No.", ApplyingVendLedgEntry."Vendor No.");
                    VendLedgEntry.SETFILTER("Document Type", '<>' + FORMAT(ApplyingVendLedgEntry."Document Type"));
                    IF VendLedgEntry.FINDFIRST THEN BEGIN
                        VendLedgEntryNo := VendLedgEntry."Entry No.";
                        IF ApplyingVendLedgEntry."Remaining Amount" = 0 THEN
                            ApplyingVendLedgEntry.CALCFIELDS("Remaining Amount");

                        ApplyingVendLedgEntry."Applying Entry" := TRUE;
                        IF ApplyingVendLedgEntry."Applies-to ID" = '' THEN
                            ApplyingVendLedgEntry."Applies-to ID" := ApplyingVendLedgEntry."Original Document No."; // ApplyingVendLedgEntry."Document No.";//backup lewis 20250923 if Original Document No. is 'YES' use "Document No."

                        ApplyingVendLedgEntry."Amount to Apply" := ApplyingVendLedgEntry."Remaining Amount";
                        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", ApplyingVendLedgEntry);
                        //COMMIT;

                        // set apply to id
                        SetApplytoID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, ApplyingVendLedgEntry."Original Document No.");//ApplyingVendLedgEntry."Document No.");//backup lewis 20250923 if Original Document No. is 'YES' use "Document No."
                        //COMMIT;
                    END;

                    IF VendLedgEntry.Get(VendLedgEntryNo) THEN BEGIN
                        ActionPerformed := VendLedgEntry."Applies-to ID" <> '';
                        IF ActionPerformed THEN BEGIN
                            PostDirectApplication();
                        END;
                    end;
                END;
            END;
        END;
    end;

    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        ApplyingVendLedgEntry: Record "Vendor Ledger Entry";
        SetApplytoID: Codeunit "Vend. Entry-SetAppl.ID";
        ActionPerformed: Boolean;
        recVendledgrEntry: Record "Vendor Ledger Entry";
        PurchInvLine: Record "Purch. Inv. Line";
        Text012: Label 'The application was successfully posted.';
        Text013: Label 'The %1 entered must not be before the %1 on the %2.';
        Text019: Label 'Post application process has been canceled.';
        GLReg: Record "G/L Register";

    local procedure PostDirectApplication()
    var
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        ApplicationDate: Date;
        NewApplicationDate: Date;
        NewDocumentNo: Code[20];
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
    begin
        IF ApplyingVendLedgEntry."Entry No." <> 0 THEN BEGIN
            recVendledgrEntry := ApplyingVendLedgEntry;
            ApplicationDate := VendEntryApplyPostedEntries.GetApplicationDate(recVendledgrEntry);
            PostApplication.SetValues(ApplyingVendLedgEntry."Document No.", ApplicationDate);
            //IF ACTION::OK = PostApplication.RUNMODAL THEN BEGIN
            PostApplication.GetValues(NewDocumentNo, NewApplicationDate);
            IF NewApplicationDate < ApplicationDate THEN
                ERROR(Text013, recVendledgrEntry.FIELDCAPTION("Posting Date"), recVendledgrEntry.TABLECAPTION);

            //END ELSE
            //  ERROR(Text019);

            VendEntryApplyPostedEntries.Apply(recVendledgrEntry, ApplyUnapplyParameters);
            //VendEntryApplyPostedEntries.Apply(recVendledgrEntry, NewDocumentNo, NewApplicationDate);
            // MESSAGE(Text012);


        END;
    end;
}

