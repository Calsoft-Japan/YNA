xmlport 50005 ExportFixedAsset
{
    // =================================================================================
    // Ver.No.  Date         Sign.  ID              Description
    // ---------------------------------------------------------------------------------
    // CSPH1    2016-10-18   Kenya  n/a             Fix issue when Depreciation Starting Date is blank
    // =================================================================================

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
            tableelement("Fixed Asset"; "Fixed Asset")
            {
                XmlName = 'FixedAsset';
                textelement(Company)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Company := 'YNA';
                    end;
                }
                textelement(managementunit)
                {
                    XmlName = 'ManagementUnit';

                    trigger OnBeforePassVariable()
                    begin
                        ManagementUnit := '04';
                    end;
                }
                fieldelement("AssetNo."; "Fixed Asset"."No.")
                {
                }
                textelement("assetno.2")
                {
                    XmlName = 'AssetNo.2';

                    trigger OnBeforePassVariable()
                    begin
                        "AssetNo.2" := '000';
                    end;
                }
                textelement(UpdatedDate)
                {
                }
                textelement(Field6)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field6 := '0'
                    end;
                }
                textelement(Field7)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field7 := '0'
                    end;
                }
                textelement(Field8)
                {
                }
                textelement(Field9)
                {
                }
                textelement(Field10)
                {
                }
                textelement(Field11)
                {
                }
                fieldelement(AssetName; "Fixed Asset".Description)
                {
                }
                textelement(AcquisitionYear)
                {
                }
                textelement(AcquisitionMonth)
                {
                }
                textelement(AcquisitionDay)
                {
                }
                textelement(OperationDivision)
                {

                    trigger OnBeforePassVariable()
                    begin
                        OperationDivision := '0';
                    end;
                }
                textelement(Field17)
                {
                }
                textelement(Field18)
                {
                }
                textelement(Field19)
                {
                }
                textelement(Situation)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Situation := '0';
                    end;
                }
                textelement(Field21)
                {
                }
                textelement(Field22)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field22 := '0';
                    end;
                }
                fieldelement(Purchase; "Fixed Asset"."Purchased From")
                {
                }
                textelement(Field24)
                {
                }
                fieldelement(MachineNo; "Fixed Asset"."Machine No.")
                {
                }
                fieldelement(DrawingNo; "Fixed Asset"."Drawing No.")
                {
                }
                fieldelement(FAlocation; "Fixed Asset"."FA Location Code")
                {
                }
                textelement(FAlocationName)
                {
                }
                fieldelement(DepartmentCode; "Fixed Asset"."Global Dimension 1 Code")
                {
                }
                textelement(Field30)
                {
                }
                textelement(Field31)
                {
                }
                textelement(Field32)
                {
                }
                textelement(Field33)
                {
                }
                textelement(FASubclass)
                {
                }
                fieldelement(LeaseBorrow; "Fixed Asset"."Lease/Borrowing")
                {
                }
                fieldelement(LineCode; "Fixed Asset"."Line Code")
                {
                }
                fieldelement(LineCodebyProcess; "Fixed Asset"."Line Code By Process")
                {
                }
                textelement(Field38)
                {
                }
                textelement(Field39)
                {
                }
                textelement(Field40)
                {
                }
                textelement(Field41)
                {
                }
                textelement(Field42)
                {
                }
                textelement(Field43)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field43 := '0';
                    end;
                }
                textelement(Field44)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field44 := '0';
                    end;
                }
                textelement(Field45)
                {
                }
                textelement(Field46)
                {
                }
                textelement(Field47)
                {
                }
                textelement(Field48)
                {
                }
                textelement(Field49)
                {
                }
                textelement(Field50)
                {
                }
                textelement(Field51)
                {
                }
                textelement(DepreciationYear)
                {
                }
                textelement(DepreciationMonth)
                {
                }
                textelement(Field54)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field54 := '0';
                    end;
                }
                textelement(Field55)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field55 := '0';
                    end;
                }
                textelement(Field56)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field56 := '0';
                    end;
                }
                textelement(Field57)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field57 := '0';
                    end;
                }
                textelement(Field58)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field58 := '0';
                    end;
                }
                textelement(Field59)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field59 := '0';
                    end;
                }
                textelement(Field60)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Field60 := '0';
                    end;
                }
                textelement(FullyDepreciated)
                {
                }
                textelement(AssetServiceLife)
                {
                }
                textelement(RemainingNoofMonth)
                {
                }
                textelement(DepreciationMethod)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DepreciationMethod := '1';
                    end;
                }
                textelement(DepreciationRate)
                {
                }
                textelement(AcquisitionCost)
                {
                }
                textelement(BookValue)
                {
                }
                textelement(BeginningBookValue)
                {
                }
                textelement(AnnualDepreciationAmount)
                {
                }
                textelement("Acc.Dep.CurrMonth")
                {
                }
                textelement("Acc.Dep.YTD")
                {
                }
                textelement("Acc.Depreciation")
                {
                }
                textelement("BonusDep.Class")
                {
                }
                textelement(Field74)
                {
                }
                textelement(Field75)
                {
                }
                textelement(Field76)
                {
                }
                textelement(Field77)
                {
                }
                textelement(Field78)
                {
                }
                textelement(Field79)
                {
                }
                textelement(Field80)
                {
                }
                textelement(Field81)
                {
                }
                textelement(Field82)
                {
                }
                textelement(Field83)
                {
                }
                textelement(Field84)
                {
                }
                textelement(Field85)
                {
                }
                textelement(Field86)
                {
                }
                textelement(Field87)
                {
                }
                textelement(Field88)
                {
                }
                textelement(Field89)
                {
                }
                textelement(Field90)
                {
                }
                textelement(Field91)
                {
                }
                textelement(Field92)
                {
                }
                textelement(Field93)
                {
                }
                textelement(Field94)
                {
                }
                textelement(Field95)
                {
                }
                textelement(Field96)
                {
                }
                textelement(Field97)
                {
                }
                textelement(Field98)
                {
                }
                textelement(Field99)
                {
                }
                textelement(Field100)
                {
                }
                textelement(Field101)
                {
                }
                textelement(Field102)
                {
                }
                textelement(Field103)
                {
                }
                textelement(Field104)
                {
                }
                textelement(Field105)
                {
                }
                textelement(Field106)
                {
                }
                textelement(Field107)
                {
                }
                textelement(Field108)
                {
                }
                textelement(Field109)
                {
                }
                textelement(Field110)
                {
                }
                textelement(Field111)
                {
                }
                textelement(Field112)
                {
                }
                textelement(Field113)
                {
                }
                textelement(Field114)
                {
                }
                textelement(Field115)
                {
                }
                textelement(Field116)
                {
                }
                textelement(Field117)
                {
                }
                textelement(Field118)
                {
                }
                textelement(Field119)
                {
                }
                textelement(Field120)
                {
                }
                textelement(Field121)
                {
                }
                textelement(Field122)
                {
                }
                textelement(Field123)
                {
                }
                textelement(Field124)
                {
                }
                textelement(Field125)
                {
                }
                textelement(Field126)
                {
                }
                textelement(Field127)
                {
                }
                textelement(Field128)
                {
                }
                textelement(Field129)
                {
                }
                textelement(Field130)
                {
                }
                textelement(Field131)
                {
                }
                textelement(Field132)
                {
                }
                textelement(Field133)
                {
                }
                textelement(Field134)
                {
                }
                textelement(Field135)
                {
                }
                textelement(Field136)
                {
                }
                textelement(Field137)
                {
                }
                textelement(Field138)
                {
                }
                textelement(Field139)
                {
                }
                textelement(Field140)
                {
                }
                textelement(Field141)
                {
                }
                textelement(Field142)
                {
                }
                textelement(Field143)
                {
                }
                textelement(Field144)
                {
                }
                fieldelement(Remarks; "Fixed Asset".Remarks)
                {
                }
                textelement(Field146)
                {
                }
                textelement(Field147)
                {
                }
                textelement(Field148)
                {
                }

                trigger OnAfterGetRecord()
                var
                    SumAmount1: Decimal;
                    SumAmount2: Decimal;
                    SumAmount3: Decimal;
                    SumAmount4: Decimal;
                    SumAmount5: Decimal;
                    SumAmount6: Decimal;
                    Date1: Date;
                    Date2: Date;
                    Date3: Date;
                    AsofMonth: Integer;
                    Asofyear: Integer;
                    oncetime: Boolean;
                    YearFrom: Integer;
                    YearTo1: Integer;
                    YearTo2: Integer;
                    MonthFrom: Integer;
                    MonthTo1: Integer;
                    MonthTo2: Integer;
                    RemainingMonths: Integer;
                    DepreciationMonths: Integer;
                    PlannedDepreciation: Decimal;
                    BookValueNum: Decimal;
                begin
                    UpdatedDate := FORMAT("Fixed Asset"."Last Date Modified", 0, '<Year4>/<Month,2>/<Day,2>');

                    FAlocationName := '';
                    FAlocation.RESET;
                    FAlocation.SETRANGE(FAlocation.Code, "Fixed Asset"."FA Location Code");
                    IF FAlocation.FIND('-') THEN BEGIN
                        FAlocationName := FAlocation.Name;
                    END;

                    CASE "Fixed Asset"."FA Subclass Code" OF
                        'J&T':
                            FASubclass := '1';
                        'DIE':
                            FASubclass := '3';
                        'MACH':
                            FASubclass := '4'
                        ELSE
                            FASubclass := '7';
                    END;

                    BookValue := '0.00';
                    AssetServiceLife := '';
                    RemainingNoofMonth := '';

                    FAdepBook.RESET;
                    FAdepBook.SETRANGE("FA No.", "Fixed Asset"."No.");
                    IF FAdepBook.FIND('-') THEN BEGIN
                        // 2016-10-18 Begin
                        IF FAdepBook."Depreciation Starting Date" = 0D THEN BEGIN
                            //bobby FileOperator.SaveLogFile(LogFilename, 'Warning: [FA No.' + "Fixed Asset"."No." + '] Depreciation Starting Date in FA Depreciation Book is blank.', FALSE);
                            InterfaceMessage.UpdateInterfaceMessage(1, 3, 'Warning: [FA No.' + "Fixed Asset"."No." + '] Depreciation Starting Date in FA Depreciation Book is blank.');
                            DepreciationYear := '';
                            DepreciationMonth := '';
                        END
                        ELSE BEGIN
                            DepreciationYear := FORMAT(DATE2DMY(FAdepBook."Depreciation Starting Date", 3));
                            DepreciationMonth := FORMAT(DATE2DMY(FAdepBook."Depreciation Starting Date", 2));
                        END;
                        // 2016-10-18 End
                        FAdepBook.SETFILTER("FA Posting Date Filter", '<=' + FORMAT(AsofDate));
                        FAdepBook.CALCFIELDS("Book Value");

                        IF FAdepBook."No. of Depreciation Years" <> 0 THEN
                            DepreciationRate := FORMAT(ROUND(1 / FAdepBook."No. of Depreciation Years", 0.001, '>'))
                        ELSE
                            DepreciationRate := '0';

                        IF FAdepBook."Disposal Date" > 0D THEN
                            BookValueNum := 0
                        ELSE
                            BookValueNum := FAdepBook."Book Value";

                        IF BookValueNum = 0 THEN
                            FullyDepreciated := '1'
                        ELSE
                            FullyDepreciated := '0';

                        BookValue := FORMAT(BookValueNum, 0, '<Precision,2:2><Integer><Decimals>');
                        AssetServiceLife := FORMAT(FAdepBook."No. of Depreciation Years", 0, '<Integer>');
                        RemainingNoofMonth := FORMAT(GetNoofmonth(FAdepBook."Depreciation Ending Date"));
                    END;

                    SumAmount1 := 0;  // Acquisition Cost
                    SumAmount2 := 0;  // Beginning Book Value
                    SumAmount3 := 0;  // Annual Depreciation Amount
                    SumAmount4 := 0;  // Depreciation Amount of Current Month
                    SumAmount5 := 0;  // Depreciation Amount YTD Current Month
                    SumAmount6 := 0;  // Accumulated Depreciation
                    AsofMonth := DATE2DMY(AsofDate, 2);
                    Asofyear := DATE2DMY(AsofDate, 3);
                    Date1 := GetStartingDateAP(FALSE);
                    Date2 := GetStartingDateAP(TRUE);

                    FAledgerEntry.RESET;
                    FAledgerEntry.SETCURRENTKEY("Posting Date");
                    FAledgerEntry.SETRANGE("FA No.", "Fixed Asset"."No.");
                    FAledgerEntry.SETRANGE("Depreciation Book Code", DefaultBook);
                    FAledgerEntry.SETRANGE("Part of Book Value", TRUE);
                    IF FAledgerEntry.FIND('-') THEN BEGIN
                        oncetime := FALSE;
                        REPEAT
                            IF FAledgerEntry."FA Posting Type" = FAledgerEntry."FA Posting Type"::"Acquisition Cost" THEN BEGIN
                                SumAmount1 := SumAmount1 + FAledgerEntry.Amount;
                                IF oncetime = FALSE THEN BEGIN
                                    AcquisitionYear := FORMAT(DATE2DMY(FAledgerEntry."Posting Date", 3));
                                    AcquisitionMonth := FORMAT(DATE2DMY(FAledgerEntry."Posting Date", 2));
                                    AcquisitionDay := FORMAT(DATE2DMY(FAledgerEntry."Posting Date", 1));
                                    oncetime := TRUE;
                                END;
                            END;

                            IF Date1 > FAledgerEntry."Posting Date" THEN
                                SumAmount2 := SumAmount2 + FAledgerEntry.Amount;

                            IF (FAledgerEntry."FA Posting Type" = FAledgerEntry."FA Posting Type"::Depreciation) AND
                               (FAledgerEntry."Posting Date" >= Date1) AND
                               (FAledgerEntry."Posting Date" <= AsofDate) THEN
                                SumAmount3 := SumAmount3 + ABS(FAledgerEntry.Amount);

                            IF (FAledgerEntry."FA Posting Type" = FAledgerEntry."FA Posting Type"::Depreciation) AND
                               (DATE2DMY(FAledgerEntry."Posting Date", 3) = Asofyear) AND
                               (DATE2DMY(FAledgerEntry."Posting Date", 2) = AsofMonth) THEN
                                SumAmount4 := SumAmount4 + ABS(FAledgerEntry.Amount);

                            IF (FAledgerEntry."FA Posting Type" = FAledgerEntry."FA Posting Type"::Depreciation) AND
                               (FAledgerEntry."Posting Date" >= Date1) AND
                               (FAledgerEntry."Posting Date" <= AsofDate) THEN
                                SumAmount5 := SumAmount5 + ABS(FAledgerEntry.Amount);

                            IF (FAledgerEntry."FA Posting Type" = FAledgerEntry."FA Posting Type"::Depreciation) THEN
                                SumAmount6 := SumAmount6 + ABS(FAledgerEntry.Amount);

                        UNTIL FAledgerEntry.NEXT <= 0;
                    END;

                    AcquisitionCost := FORMAT(SumAmount1, 0, '<Precision,2:2><Integer><Decimals>');
                    BeginningBookValue := FORMAT(SumAmount2, 0, '<Precision,2:2><Integer><Decimals>');
                    "Acc.Dep.CurrMonth" := FORMAT(SumAmount4, 0, '<Precision,2:2><Integer><Decimals>');
                    "Acc.Dep.YTD" := FORMAT(SumAmount5, 0, '<Precision,2:2><Integer><Decimals>');
                    "Acc.Depreciation" := FORMAT(SumAmount6, 0, '<Precision,2:2><Integer><Decimals>');

                    IF AsofDate < FAdepBook."Depreciation Ending Date" THEN BEGIN
                        MonthFrom := DATE2DMY(AsofDate, 2);
                        YearFrom := DATE2DMY(AsofDate, 3);
                        MonthTo1 := DATE2DMY(Date2, 2);
                        YearTo1 := DATE2DMY(Date2, 3);
                        DepreciationMonths := (YearTo1 - YearFrom) * 12 + (MonthTo1 - MonthFrom) - 1;
                        MonthTo2 := DATE2DMY(FAdepBook."Depreciation Ending Date", 2);
                        YearTo2 := DATE2DMY(FAdepBook."Depreciation Ending Date", 3);
                        RemainingMonths := (YearTo2 - YearFrom) * 12 + (MonthTo2 - MonthFrom);

                        IF RemainingMonths < DepreciationMonths THEN DepreciationMonths := RemainingMonths;
                        PlannedDepreciation := (FAdepBook."Book Value" - FAdepBook."Salvage Value") * DepreciationMonths / RemainingMonths;
                        SumAmount3 := SumAmount3 + ROUND(PlannedDepreciation, 0.01);

                    END;
                    AnnualDepreciationAmount := FORMAT(SumAmount3, 0, '<Precision,2:2><Integer><Decimals>');

                    "BonusDep.Class" := '0';

                    Field75 := '0';
                    Field82 := '0';
                    Field91 := '0';
                    Field100 := '0';
                    Field107 := '0';
                    Field115 := '0';
                    Field76 := '0';
                    Field83 := '0';
                    Field92 := '0';
                    Field101 := '0';
                    Field108 := '0';
                    Field116 := '0';
                    Field77 := '0';
                    Field84 := '0';
                    Field93 := '0';
                    Field102 := '0';
                    Field109 := '0';
                    Field117 := '0';
                    Field78 := '0';
                    Field85 := '0';
                    Field94 := '0';
                    Field103 := '0';
                    Field110 := '0';
                    Field118 := '0';
                    Field79 := '0';
                    Field87 := '0';
                    Field95 := '0';
                    Field104 := '0';
                    Field112 := '0';
                    Field121 := '0';
                    Field80 := '0';
                    Field88 := '0';
                    Field96 := '0';
                    Field105 := '0';
                    Field113 := '0';
                    Field122 := '0';
                    Field81 := '0';
                    Field90 := '0';
                    Field97 := '0';
                    Field106 := '0';
                    Field114 := '0';
                    Field123 := '0';

                    Field124 := '0';
                    Field129 := '0';
                    Field136 := '0';
                    Field125 := '0';
                    Field130 := '0';
                    Field143 := '0';
                    Field126 := '0';
                    Field131 := '0';
                    Field144 := '0';
                    Field127 := '0';
                    Field132 := '0';
                    Field147 := '0';
                    Field128 := '0';
                    Field135 := '0';

                    icount += 1;
                end;

                trigger OnPreXmlItem()
                begin
                    "Fixed Asset".SETFILTER("Main Asset/Component", '<>Main Asset');
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
        //bobby FileOperator.SaveLogFile(LogFilename, 'Exported ' + FORMAT(icount) + ' Assets', FALSE);
        InterfaceMessage.UpdateInterfaceMessage(1, 3, 'Exported ' + FORMAT(icount) + ' Assets');
    end;

    trigger OnPreXmlPort()
    var
        companyinfo: Record "Company Information";
    begin

        //companyinfo.RESET;
        //companyinfo.FINDFIRST;

        //LogFilename := companyinfo."File Path" + '\Log\AFWZD';
        //bobby FileOperator.SaveLogFile(LogFilename, '-------Start Export Fixed Asset ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ' ---------', FALSE);
        //InterfaceMessage.UpdateInterfaceMessage(1, 3, '-----Start Export Fixed Asset ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ' -----');
        icount := 0;
    end;

    var
        FAledgerEntry: Record "FA Ledger Entry";
        FAlocation: Record "FA Location";
        FAdepBook: Record "FA Depreciation Book";
        AsofDate: Date;
        //FileOperator: Codeunit "50001";
        LogFilename: Text;
        icount: Integer;
        DefaultBook: Label 'FINANCIAL';
        InterfaceMessage: Codeunit "Interface Message";

    procedure GetStartingDateAP(isNextDate: Boolean) Startingdate: Date
    var
        AccPer: Record "Accounting Period";
    begin
        IF isNextDate = FALSE THEN BEGIN
            AccPer.RESET;
            AccPer.SETRANGE("New Fiscal Year", TRUE);
            AccPer.SETRANGE(Closed, FALSE);
            AccPer.SETRANGE("Date Locked", TRUE);
            IF AccPer.FIND('-') THEN BEGIN
                Startingdate := AccPer."Starting Date";
            END
        END
        ELSE BEGIN
            AccPer.RESET;
            AccPer.SETRANGE("New Fiscal Year", TRUE);
            AccPer.SETRANGE(Closed, FALSE);
            AccPer.SETRANGE("Date Locked", FALSE);
            IF AccPer.FIND('-') THEN BEGIN
                Startingdate := AccPer."Starting Date";
            END
        END;
    end;

    procedure GetNoofmonth(endingdate: Date) NoofMonth: Integer
    var
        year: Integer;
        month: Integer;
        i: Integer;
    begin
        // begin date today,
        // ending date endingdate.
        IF endingdate = 0D THEN BEGIN
            //FileOperator.SaveLogFile(LogFilename, 'Warning: [FA No.' + "Fixed Asset"."No." + '] Depreciation Ending Date in FA Depreciation Book is blank.', FALSE);
            InterfaceMessage.UpdateInterfaceMessage(1, 3, 'Warning: [FA No.' + "Fixed Asset"."No." + '] Depreciation Ending Date in FA Depreciation Book is blank.');
            icount := 0;
            NoofMonth := 0;
        END
        ELSE IF endingdate < TODAY() THEN BEGIN
            NoofMonth := 0;
        END
        ELSE BEGIN
            year := DATE2DMY(TODAY(), 3);
            month := DATE2DMY(TODAY(), 2);

            NoofMonth := (DATE2DMY(endingdate, 3) - year) * 12 + DATE2DMY(endingdate, 2) - month;
        END;
    end;

    procedure SetAsofDate(varAsofDate: Date)
    begin
        AsofDate := varAsofDate;
    end;
}

