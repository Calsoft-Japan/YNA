xmlport 50002 ImportVendorData
{
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TextEncoding = UTF8;
    UseRequestPage = false;

    schema
    {
        textelement(DocumentElement)
        {
            tableelement(Vendor; Vendor)
            {
                XmlName = 'VNtable';
                UseTemporary = true;
                fieldelement(No; Vendor."No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Name; Vendor.Name)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Address; Vendor.Address)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Address_2; Vendor."Address 2")
                {
                    MinOccurs = Zero;
                }
                fieldelement(City; Vendor.City)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Contact; Vendor.Contact)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Phone_No; Vendor."Phone No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Global_Dimension_1_Code; Vendor."Global Dimension 1 Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Global_Dimension_2_Code; Vendor."Global Dimension 2 Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Vendor_Posting_Group; Vendor."Vendor Posting Group")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Currency_Code; Vendor."Currency Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Payment_Terms_Code; Vendor."Payment Terms Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Payment_Method_Code; Vendor."Payment Method Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Gen_Bus_Posting_Group; Vendor."Gen. Bus. Posting Group")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ZIP_Code; Vendor."Post Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(State; Vendor.County)
                {
                    MinOccurs = Zero;
                }
                fieldelement(E_Mail; Vendor."E-Mail")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Federal_ID_No; Vendor."Federal ID No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Bank_Code; Vendor."Preferred Bank Account Code")
                {
                    MinOccurs = Zero;
                }
                textelement(bank_accountno)
                {
                    MinOccurs = Zero;
                    XmlName = 'Bank_Account_No';
                }
                textelement(transit_no)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transit_No';
                }
                fieldelement(IRS_1099_Code; Vendor."IRS 1099 Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Blocked; Vendor.Blocked)
                {
                    MinOccurs = Zero;
                }
                fieldelement(FaxNo; Vendor."Fax No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Country; Vendor."Country/Region Code")
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin


                    IF (Vendor."No." > '000000') AND (Vendor."No." <= '299999') THEN BEGIN
                        tempVendor.INIT;
                        tempVendor."No." := Vendor."No.";
                        tempVendor.Name := Vendor.Name;
                        tempVendor.INSERT;

                    END
                    ELSE BEGIN
                        tempVendor.INIT;
                        tempVendor := Vendor;
                        tempVendor."Search Name" := Vendor.Name;
                        tempVendor."Vendor Posting Group" := 'TRADE';
                        tempVendor.INSERT;
                    END;

                    IF Vendor."Preferred Bank Account Code" <> '' THEN BEGIN

                        TempVendorBankAccount.INIT;
                        TempVendorBankAccount."Vendor No." := Vendor."No.";
                        TempVendorBankAccount."Bank Account No." := Bank_AccountNo;
                        TempVendorBankAccount.Code := Vendor."Preferred Bank Account Code";
                        TempVendorBankAccount."Transit No." := Transit_No;

                        IF Vendor."Payment Method Code" = 'ACH' THEN
                            TempVendorBankAccount."Use for Electronic Payments" := TRUE;
                        TempVendorBankAccount.INSERT;
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        Companyinfo.GET;
        //LogFileName := Companyinfo."File Path" + '\LOG\Vendor';
    end;

    trigger OnPostXmlPort()
    var
        localOK: Boolean;
        logFilenameTime: Text[1024];
        trueVendor2: Record Vendor;
        InterfaceMessage: Codeunit "Interface Message";
    begin
        InterfaceMessage.UpdateInterfaceMessage(0, 0, '-----Starting import Vendor(StartTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
        AllRecCount := 1;
        FailRecCount := 0;
        ValidateOK := TRUE;


        TempVendorBankAccount.RESET;
        IF TempVendorBankAccount.FIND('-') THEN BEGIN
            REPEAT

                SureVendorBankAccount.INIT;
                SureVendorBankAccount := TempVendorBankAccount;
                IF NOT SureVendorBankAccount.INSERT(TRUE) THEN BEGIN
                    SureVendorBankAccount.MODIFY(TRUE);
                END;


            UNTIL TempVendorBankAccount.NEXT = 0;
        END;


        tempVendor.RESET;
        IF tempVendor.FIND('-') THEN BEGIN
            REPEAT
                localOK := TRUE;
                // Validate employee
                IF ((tempVendor."No." > '000000') AND (tempVendor."No." <= '299999')) OR ((tempVendor."No." > '499999') AND (tempVendor."No." <= '599999')) THEN BEGIN
                    SureVendor.RESET;
                    SureVendor.SETRANGE("No.", tempVendor."No.");
                    IF SureVendor.FIND('-') THEN BEGIN
                        SureVendor.Name := tempVendor.Name;
                        SureVendor.MODIFY(TRUE);
                        InterfaceMessage.UpdateInterfaceMessage(0, 0, 'Successful: Vendor[' + SureVendor."No." + '] was Modified.');
                    END
                    ELSE BEGIN
                        SureVendor.INIT;
                        SureVendor := tempVendor;
                        SureVendor.INSERT(TRUE);
                        InterfaceMessage.UpdateInterfaceMessage(0, 0, 'Successful: Vendor[' + SureVendor."No." + '] was Created.');
                    END;
                END
                ELSE BEGIN
                    SureVendor.INIT;
                    SureVendor := tempVendor;

                    IF SureVendor."Vendor Posting Group" <> '' THEN BEGIN
                        VenpostingGroup.RESET;
                        VenpostingGroup.SETRANGE(Code, SureVendor."Vendor Posting Group");
                        IF NOT VenpostingGroup.FIND('-') THEN BEGIN
                            UpdateTempInterfaceMessage(0, 0, '[Vendor No.:' + SureVendor."No." + '],the Vendor Posting Group ' + SureVendor."Vendor Posting Group" + ' does not exist.');
                            localOK := FALSE;
                            ValidateOK := FALSE;
                            FailRecCount := FailRecCount + 1;
                        END;
                    END;

                    IF SureVendor."Gen. Bus. Posting Group" <> '' THEN BEGIN

                        GenBusGroup.RESET;
                        GenBusGroup.SETRANGE(GenBusGroup.Code, SureVendor."Gen. Bus. Posting Group");
                        IF NOT GenBusGroup.FIND('-') THEN BEGIN
                            UpdateTempInterfaceMessage(0, 0, '[Vendor No.:' + SureVendor."No." + '],the Gen. Bus. Posting Group ' + SureVendor."Gen. Bus. Posting Group" + ' does not exist.');
                            localOK := FALSE;
                            ValidateOK := FALSE;
                            FailRecCount := FailRecCount + 1;
                        END;
                    END;

                    IF SureVendor."Currency Code" <> '' THEN BEGIN

                        Currency.RESET;
                        Currency.SETRANGE(Code, SureVendor."Currency Code");
                        IF NOT Currency.FIND('-') THEN BEGIN
                            UpdateTempInterfaceMessage(0, 0, '[Vendor No.:' + SureVendor."No." + '],the Currency Code ' + SureVendor."Currency Code" + ' does not exist.');
                            localOK := FALSE;
                            ValidateOK := FALSE;
                            FailRecCount := FailRecCount + 1;
                        END;
                    END;

                    IF SureVendor."Payment Terms Code" <> '' THEN BEGIN

                        PaymentTerms.RESET;
                        PaymentTerms.SETRANGE(Code, SureVendor."Payment Terms Code");
                        IF NOT PaymentTerms.FIND('-') THEN BEGIN
                            UpdateTempInterfaceMessage(0, 0, '[Vendor No.:' + SureVendor."No." + '],the Payment Terms Code ' + SureVendor."Payment Terms Code" + ' does not exist.');
                            localOK := FALSE;
                            ValidateOK := FALSE;
                            FailRecCount := FailRecCount + 1;
                        END;
                    END;

                    IF SureVendor."Payment Method Code" <> '' THEN BEGIN

                        PaymentMethod.RESET;
                        PaymentMethod.SETRANGE(Code, SureVendor."Payment Method Code");
                        IF NOT PaymentMethod.FIND('-') THEN BEGIN
                            UpdateTempInterfaceMessage(0, 0, '[Vendor No.:' + SureVendor."No." + '],the Payment Method Code ' + SureVendor."Payment Method Code" + ' does not exist.');
                            localOK := FALSE;
                            ValidateOK := FALSE;
                            FailRecCount := FailRecCount + 1;
                        END;

                    END;
                END;

                // handle Vendor Bank Account

                IF (SureVendor."Preferred Bank Account Code" = '') AND
                (((tempVendor."No." > '299999') AND (tempVendor."No." < '500000')) OR (tempVendor."No." > '599999')) THEN    // Treat 5* as employee. Added by J.Wu on 4/16/2024
                BEGIN
                    SureVendorBankAccount.RESET;
                    SureVendorBankAccount.SETRANGE("Vendor No.", SureVendor."No.");
                    SureVendorBankAccount.DELETEALL;
                END;


                IF ValidateOK = TRUE THEN BEGIN
                    //IF tempVendor."No." > '299999' THEN
                    // Begin - Treat 5* as employee. Added by J.Wu on 4/16/2024
                    IF (((tempVendor."No." > '299999') AND (tempVendor."No." < '500000')) OR (tempVendor."No." > '599999')) THEN
                        // End - Treat 5* as employee. Added by J.Wu on 4/16/2024

                        IF NOT SureVendor.INSERT(TRUE) THEN BEGIN
                            // just update 23 fields
                            trueVendor2.RESET;
                            trueVendor2.GET(tempVendor."No.");
                            trueVendor2.Name := tempVendor.Name;
                            trueVendor2.Address := tempVendor.Address;
                            trueVendor2."Address 2" := tempVendor."Address 2";
                            trueVendor2.City := tempVendor.City;
                            trueVendor2.Contact := tempVendor.Contact;
                            trueVendor2."Phone No." := tempVendor."Phone No.";
                            trueVendor2."Global Dimension 1 Code" := tempVendor."Global Dimension 1 Code";
                            trueVendor2."Global Dimension 2 Code" := tempVendor."Global Dimension 2 Code";
                            trueVendor2."Vendor Posting Group" := tempVendor."Vendor Posting Group";
                            trueVendor2."Currency Code" := tempVendor."Currency Code";
                            trueVendor2."Payment Terms Code" := tempVendor."Payment Terms Code";
                            trueVendor2."Payment Method Code" := tempVendor."Payment Method Code";
                            trueVendor2."Gen. Bus. Posting Group" := tempVendor."Gen. Bus. Posting Group";
                            trueVendor2."Post Code" := tempVendor."Post Code";
                            trueVendor2.County := tempVendor.County;
                            trueVendor2."E-Mail" := tempVendor."E-Mail";
                            trueVendor2."Federal ID No." := tempVendor."Federal ID No.";
                            trueVendor2."Preferred Bank Account Code" := tempVendor."Preferred Bank Account Code";
                            trueVendor2."IRS 1099 Code" := tempVendor."IRS 1099 Code";
                            trueVendor2.Blocked := tempVendor.Blocked;
                            trueVendor2."Fax No." := tempVendor."Fax No.";
                            trueVendor2."Country/Region Code" := tempVendor."Country/Region Code";
                            trueVendor2.MODIFY(TRUE);

                            //SureVendor.MODIFY(TRUE);
                            InterfaceMessage.UpdateInterfaceMessage(0, 0, 'Successful: Vendor[' + SureVendor."No." + '] was Modified.');
                        END
                        ELSE BEGIN
                            InterfaceMessage.UpdateInterfaceMessage(0, 0, 'Successful: Vendor[' + SureVendor."No." + '] was Created.');
                        END;
                END;
            UNTIL tempVendor.NEXT = 0;
            COMMIT;
        END;

        //InterfaceMessage.UpdateInterfaceMessage(0, 0, '-----End Import Vendor Card (' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
        IF ValidateOK = true THEN BEGIN
            ERROR('OK');
        END
        ELSE begin
            TempInterfaceMessage.Reset();
            if TempInterfaceMessage.FindFirst() then begin
                repeat
                    InterfaceMessage.UpdateInterfaceMessage(0, 0, TempInterfaceMessage.Message);
                    Commit();
                until TempInterfaceMessage.Next() = 0;
            end;

            ERROR('ErrorMessage');
        end;

    end;

    var
        tempVendor: Record Vendor temporary;
        TempVendorBankAccount: Record "Vendor Bank Account" temporary;
        AllRecCount: Integer;
        FailRecCount: Integer;
        ValidateOK: Boolean;
        JBatchName: Code[20];
        JTemplatename: Code[20];
        LineNo: Integer;
        SureVendor: Record Vendor;
        SureVendorBankAccount: Record "Vendor Bank Account";
        GenBusGroup: Record "Gen. Business Posting Group";
        VenpostingGroup: Record "Vendor Posting Group";
        BankAccountNo: Code[30];
        TransitNo: Code[20];
        Currency: Record Currency;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        Companyinfo: Record "Company Information";
        TempInterfaceMessage: Record "Interface Message" temporary;

    procedure UpdateTempInterfaceMessage(DataType: Option; DataName: Option; Message: Text[250])
    var
        TempInterfaceMessageEntryNo: Integer;
    begin
        TempInterfaceMessageEntryNo := 0;
        TempInterfaceMessage.Reset();
        TempInterfaceMessage.SetCurrentKey("Entry No.");
        if TempInterfaceMessage.FindLast() then begin
            TempInterfaceMessageEntryNo := TempInterfaceMessage."Entry No.";
        end;
        TempInterfaceMessage.Init();
        TempInterfaceMessage."Entry No." := TempInterfaceMessageEntryNo + 1;
        TempInterfaceMessage."Data Type" := DataType;
        TempInterfaceMessage."Data Name" := DataName;
        TempInterfaceMessage."Created At" := CurrentDateTime;
        TempInterfaceMessage.Message := Message;
        TempInterfaceMessage.Insert();

    end;

}

