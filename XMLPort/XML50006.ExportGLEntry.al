xmlport 50006 ExportGLEntry
{
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TransactionType = Report;
    UseRequestPage = false;

    schema
    {
        textelement(DocumentElement)
        {
            tableelement("G/L Entry"; "G/L Entry")
            {
                XmlName = 'GLEntry';
                textelement(Company)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Company := 'YNA';
                    end;
                }
                textelement(SlipDate)
                {
                }
                textelement(SlipNumber)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DetailLineNo := '0';
                    end;
                }
                textelement(detaillineno)
                {
                    XmlName = 'DetailLineNo';
                }
                textelement(DeCreditclass)
                {
                }
                fieldelement(Accountcode; "G/L Entry"."G/L Account No.")
                {
                }
                textelement(AccountSubcode)
                {
                }
                textelement(DepartmentCode)
                {
                }
                textelement(FunctionCode1)
                {
                }
                textelement(FunctionCode2)
                {
                }
                textelement(FunctionCode3)
                {
                }
                textelement(FunctionCode4)
                {
                }
                textelement(JournalAmount)
                {
                }
                textelement(TaxprocessingCode)
                {
                }
                textelement(TaxInputClass)
                {

                    trigger OnBeforePassVariable()
                    begin
                        TaxInputClass := '0';
                    end;
                }
                textelement(AmountofTax)
                {

                    trigger OnBeforePassVariable()
                    begin
                        AmountofTax := '0';
                    end;
                }
                textelement(ForeignCurrencycode)
                {
                }
                textelement(Ratetype)
                {
                }
                textelement(Exchangerate)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Exchangerate := ''; // Print blank field instead of zero. Added on 4/5/2024 by J.Wu
                    end;
                }
                textelement(ForeignCurrencyAmount)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ForeignCurrencyAmount := ''; // Print blank field instead of zero. Added on 4/5/2024 by J.Wu
                    end;
                }
                fieldelement(RemarksColumn1; "G/L Entry".Description)
                {
                }
                textelement(RemarksColumn2)
                {
                }
                textelement(Vouchergroupcode)
                {
                }
                textelement(SliphistoryNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        SliphistoryNo := '0';
                    end;
                }
                textelement(Systemcode)
                {
                }
                textelement(Allocationprocessgroupcode)
                {
                }
                textelement(AllocationprocessCode)
                {
                }
                textelement(OthersystemslipNo)
                {
                }
                textelement(Othersystem2Div)
                {
                }
                textelement(OthsysdepnumgroupNo)
                {
                }
                textelement(PairAccountingcode)
                {
                }
                textelement(PairAccountingAuxCode)
                {
                }
                textelement(InputuserID)
                {
                }
                textelement(InputterminalNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        InputterminalNo := '0';
                    end;
                }
                textelement(Inputsystemdate)
                {
                }
                textelement(Approvaluserid)
                {
                }
                textelement(approvalterNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        approvalterNo := '0';
                    end;
                }
                textelement(AppSystemdate)
                {
                }
                textelement(UpdateuserID)
                {
                }
                textelement(UpdateTerNo)
                {

                    trigger OnBeforePassVariable()
                    begin
                        UpdateTerNo := '0';
                    end;
                }
                textelement(Updatedate)
                {
                }
                textelement(SlipClass)
                {
                }
                textelement(Quartersegment)
                {
                }
                textelement(LaunderingClass)
                {
                }
                textelement(AllocationClass)
                {
                }
                textelement(CashanddepextrClass)
                {
                }
                textelement(FundClockextracDiv)
                {
                }
                textelement(Fundsubjectcode)
                {
                }
                textelement(Customersegment)
                {
                }
                textelement(CustomCode)
                {
                }
                textelement(Withdrawalslipclass)
                {
                }
                textelement(PreChar1)
                {
                }
                textelement(PreChar2)
                {
                }
                textelement(PreChar3)
                {
                }
                textelement(PreChar4)
                {
                }
                textelement(PreChar5)
                {
                }
                textelement(PreChar6)
                {
                }
                textelement(PreChar7)
                {
                }
                textelement(PreChar8)
                {
                }
                textelement(PreNum1)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PreNum1 := '0';
                    end;
                }
                textelement(PreNum2)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PreNum2 := '0';
                    end;
                }
                textelement(PreNum3)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PreNum3 := '0';
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    TempAmount1: Decimal;
                    TempAmount2: Decimal;
                begin
                    SlipDate := FORMAT("G/L Entry"."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>');
                    SlipNumber := getRightsubstring("G/L Entry"."Entry No.", 8);

                    IF "G/L Entry".Amount >= 0 THEN
                        DeCreditclass := '0'
                    ELSE
                        DeCreditclass := '1';

                    DimSetEntry.RESET;
                    DimSetEntry.SETRANGE("Dimension Set ID", "G/L Entry"."Dimension Set ID");
                    DimSetEntry.SETRANGE("Dimension Code", "G/L Entry"."G/L Account No.");
                    IF DimSetEntry.FIND('-') THEN
                        AccountSubcode := DimSetEntry."Dimension Value Code"
                    ELSE
                        AccountSubcode := '';

                    DimSetEntry.RESET;
                    DimSetEntry.SETRANGE("Dimension Set ID", "G/L Entry"."Dimension Set ID");
                    DimSetEntry.SETRANGE("Dimension Code", 'DEPARTMENT');
                    IF DimSetEntry.FIND('-') THEN
                        DepartmentCode := DimSetEntry."Dimension Value Code"
                    ELSE
                        DepartmentCode := '';

                    JournalAmount := FORMAT(ABS("G/L Entry".Amount), 0, 1);
                    TempAmount1 := ABS("G/L Entry".Amount);

                    ForeignCurrencycode := '';
                    ForeignCurrencyAmount := '0';
                    Exchangerate := '0';
                    TempAmount2 := 0;
                    //IF "G/L Entry"."Bal. Account Type" = "G/L Entry"."Bal. Account Type"::Vendor THEN
                    IF ("G/L Entry"."Source Code" = 'PURCHASES') OR ("G/L Entry"."Source Code" = 'PURCHJNL') THEN BEGIN
                        VendLE.RESET;
                        VendLE.SETRANGE("Document No.", "G/L Entry"."Document No.");
                        VendLE.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
                        VendLE.SETRANGE("Document Type", VendLE."Document Type"::Invoice);
                        IF VendLE.FIND('-') THEN BEGIN
                            ForeignCurrencycode := VendLE."Currency Code";
                            IF ForeignCurrencycode <> '' THEN BEGIN
                                VendLE.CALCFIELDS(VendLE.Amount);
                                TempAmount2 := ABS(VendLE.Amount);
                                ForeignCurrencyAmount := FORMAT(TempAmount2, 0, 1);
                            END;
                        END;

                        IF TempAmount1 <> 0 THEN
                            Exchangerate := FORMAT(ROUND(TempAmount2 / TempAmount1, 0.000000000001));
                    END;

                    IF "G/L Entry"."Bal. Account Type" = "G/L Entry"."Bal. Account Type"::"Bank Account" THEN BEGIN
                        BankAccLE.RESET;
                        BankAccLE.SETRANGE("Document No.", "G/L Entry"."Document No.");
                        BankAccLE.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
                        BankAccLE.SETRANGE("Bank Account No.", "G/L Entry"."Bal. Account No.");
                        IF BankAccLE.FIND('-') THEN BEGIN
                            ForeignCurrencycode := BankAccLE."Currency Code";
                            IF ForeignCurrencycode <> '' THEN BEGIN
                                TempAmount2 := ABS(BankAccLE.Amount);
                                ForeignCurrencyAmount := FORMAT(TempAmount2, 0, 1);
                            END;
                        END;

                        IF TempAmount1 <> 0 THEN
                            Exchangerate := FORMAT(ROUND(TempAmount2 / TempAmount1, 0.000000000001));
                    END;

                    InputuserID := COPYSTR("G/L Entry"."User ID", STRPOS("G/L Entry"."User ID", '\') + 1, 10);

                    getVoucheSystemCode();

                    icount += 1;
                end;

                trigger OnPreXmlItem()
                begin
                    "G/L Entry".SETFILTER("Posting Date", PostingDateFilter);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AsofDate; AsofDate)
                    {
                        Caption = 'As of';
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    var
        Fileoper: File;
    begin
        //FileOperator.SaveLogFile(LogFilename, 'Exported ' + FORMAT(icount) + ' G/L entry', FALSE);
        InterfaceMessage.UpdateInterfaceMessage(1, 2, 'Exported ' + FORMAT(icount) + ' G/L entry');
    end;

    trigger OnPreXmlPort()
    var
        companyinfo: Record "Company Information";
    begin
        //companyinfo.RESET;
        //companyinfo.FINDFIRST;


        //LogFilename := companyinfo."File Path" + '\Log\AKFGX';
        //FileOperator.SaveLogFile(LogFilename, '-------Start Export G/L Entry ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ' ---------', FALSE);

        icount := 0;
    end;

    var
        VendLE: Record "Vendor Ledger Entry";
        CustLE: Record "Cust. Ledger Entry";
        FAledgerEntry: Record "FA Ledger Entry";
        FAlocation: Record "FA Location";
        FAdepBook: Record "FA Depreciation Book";
        AsofDate: Date;
        //FileOperator: Codeunit 50001;
        //LogFilename: Text;
        icount: Integer;
        PostingDateFilter: Text[250];
        BankAccLE: Record "Bank Account Ledger Entry";
        DimSetEntry: Record "Dimension Set Entry";
        InterfaceMessage: Codeunit "Interface Message";

    local procedure getRightsubstring(EntryNo: Integer; substrlenger: Integer) delinenumber: Text
    var
        strfrom: Text[20];
    begin
        strfrom := '0000000' + FORMAT(EntryNo);
        delinenumber := COPYSTR(strfrom, STRLEN(strfrom) - substrlenger + 1, substrlenger);
    end;

    local procedure getVoucheSystemCode()
    var
        FALedEntry: Record "FA Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendorLedgEntry: Record "Vendor Ledger Entry";
    begin
        CustomCode := '';

        IF ("G/L Entry"."Voucher Group Code" <> '') AND ("G/L Entry"."System Code" <> '') THEN BEGIN
            Vouchergroupcode := "G/L Entry"."Voucher Group Code";
            Systemcode := "G/L Entry"."System Code";
        END ELSE BEGIN
            CASE "G/L Entry"."Source Code" OF
                'REVERSAL':
                    BEGIN
                        Vouchergroupcode := '20';
                        Systemcode := '01';
                    END;

                'FAGLJNL':
                    BEGIN
                        FALedEntry.RESET;
                        FALedEntry.SETRANGE("Document No.", "G/L Entry"."Document No.");
                        FALedEntry.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
                        IF FALedEntry.FIND('-') THEN BEGIN
                            IF FALedEntry."FA Posting Type" = FALedEntry."FA Posting Type"::Depreciation THEN BEGIN
                                Vouchergroupcode := '37';
                                Systemcode := '37';
                            END
                            ELSE IF FALedEntry."FA Posting Type" = FALedEntry."FA Posting Type"::"Acquisition Cost" THEN BEGIN
                                Vouchergroupcode := 'J1';
                                Systemcode := 'J1';
                            END;
                        END;
                    END;

                ELSE BEGIN
                    Vouchergroupcode := '10';
                    Systemcode := '01';
                END;
            END;
        END;
    end;

    procedure SetpostingdateFilter(Filterdate: Text[250])
    begin
        PostingDateFilter := Filterdate;
    end;
}

