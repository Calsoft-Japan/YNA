report 55607 "FixedAsset-ProjectedValue-YNA"
{
    // 
    // =======================================================================================================================
    // Ver No.   Date          Sign.    ID         Description
    // -----------------------------------------------------------------------------------------------------------------------
    // CS105     2015-10-19    RJSF     105        Export to TSV functions.
    // =======================================================================================================================
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Fixed Asset - Projected Value.rdlc';

    ApplicationArea = FixedAssets;
    Caption = 'Fixed Asset Projected Value - YNA';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "Budgeted Asset";
            column(CompanyName; COMPANYPROPERTY.DISPLAYNAME)
            {
            }
            column(DeprBookText; DeprBookText)
            {
            }
            column(FixedAssetTabcaptFAFilter; TABLECAPTION + ': ' + FAFilter)
            {
            }
            column(FAFilter; FAFilter)
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(ProjectedDisposal; ProjectedDisposal)
            {
            }
            column(DeprBookUseCustom1Depr; DeprBook."Use Custom 1 Depreciation")
            {
            }
            column(DoProjectedDisposal; DoProjectedDisposal)
            {
            }
            column(GroupTotalsInt; GroupTotalsInt)
            {
            }
            column(IncludePostedFrom; FORMAT(IncludePostedFrom))
            {
            }
            column(GroupCodeName; GroupCodeName)
            {
            }
            column(FANo; FANo)
            {
            }
            column(FADescription; FADescription)
            {
            }
            column(GroupHeadLine; GroupHeadLine)
            {
            }
            column(FixedAssetNo; "No.")
            {
            }
            column(Description_FixedAsset; Description)
            {
            }
            column(DeprText2; DeprText2)
            {
            }
            column(Text002GroupHeadLine; GroupTotalTxt + ': ' + GroupHeadLine)
            {
            }
            column(Custom1Text; Custom1Text)
            {
            }
            column(DeprCustom1Text; DeprCustom1Text)
            {
            }
            column(SalesPriceFieldname; SalesPriceFieldname)
            {
            }
            column(GainLossFieldname; GainLossFieldname)
            {
            }
            column(GroupAmounts3; GroupAmounts[3])
            {
                AutoFormatType = 1;
            }
            column(GroupAmounts4; GroupAmounts[4])
            {
                AutoFormatType = 1;
            }
            column(FAClassCode_FixedAsset; "FA Class Code")
            {
            }
            column(FASubclassCode_FixedAsset; "FA Subclass Code")
            {
            }
            column(GlobalDim1Code_FixedAsset; "Global Dimension 1 Code")
            {
            }
            column(GlobalDim2Code_FixedAsset; "Global Dimension 2 Code")
            {
            }
            column(FALocationCode_FixedAsset; "FA Location Code")
            {
            }
            column(CompofMainAss_FixedAsset; "Component of Main Asset")
            {
            }
            column(FAPostingGroup_FixedAsset; "FA Posting Group")
            {
            }
            column(CurrReportPAGENOCaption; PageNoLbl)
            {
            }
            column(FixedAssetProjectedValueCaption; FAProjectedValueLbl)
            {
            }
            column(FALedgerEntryFAPostingDateCaption; FAPostingDateLbl)
            {
            }
            column(BookValueCaption; BookValueLbl)
            {
            }
            dataitem("FA Ledger Entry"; "FA Ledger Entry")
            {
                DataItemTableView = SORTING("FA No.", "Depreciation Book Code", "FA Posting Date");
                column(FAPostingDt_FALedgerEntry; FORMAT("FA Posting Date"))
                {
                }
                column(PostingDt_FALedgerEntry; "FA Posting Type")
                {
                    IncludeCaption = true;
                }
                column(Amount_FALedgerEntry; Amount)
                {
                    IncludeCaption = true;
                }
                column(FANo_FALedgerEntry; "FA No.")
                {
                }
                column(BookValue; BookValue)
                {
                    AutoFormatType = 1;
                }
                column(NoofDeprDays_FALedgEntry; "No. of Depreciation Days")
                {
                    IncludeCaption = true;
                }
                column(FALedgerEntryEntryNo; "Entry No.")
                {
                }
                column(PostedEntryCaption; PostedEntryLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF "Part of Book Value" THEN
                        BookValue := BookValue + Amount;
                    IF "FA Posting Date" < IncludePostedFrom THEN
                        CurrReport.SKIP;
                    EntryPrinted := TRUE;

                    //--CS105
                    IF ExportToFile THEN BEGIN
                        IF "FA Posting Type" = "FA Posting Type"::Depreciation THEN
                            AddTotalDeprAmt(Amount);
                    END;
                    //--CS105
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("FA No.", "Fixed Asset"."No.");
                    SETRANGE("Depreciation Book Code", DeprBookCode);
                    BookValue := 0;
                    IF (IncludePostedFrom = 0D) OR NOT PrintDetails THEN
                        CurrReport.BREAK;
                end;
            }
            dataitem(ProjectedDepreciation; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = FILTER(1 .. 1000000));
                column(DeprAmount; DeprAmount)
                {
                    AutoFormatType = 1;
                }
                column(EntryAmt1Custom1Amt; EntryAmounts[1] - Custom1Amount)
                {
                    AutoFormatType = 1;
                }
                column(FormatUntilDate; FORMAT(UntilDate))
                {
                }
                column(DeprText; DeprText)
                {
                }
                column(NumberOfDays; NumberOfDays)
                {
                }
                column(No1_FixedAsset; "Fixed Asset"."No.")
                {
                }
                column(Custom1Text_ProjectedDepr; Custom1Text)
                {
                }
                column(Custom1NumberOfDays; Custom1NumberOfDays)
                {
                }
                column(Custom1Amount; Custom1Amount)
                {
                    AutoFormatType = 1;
                }
                column(EntryAmounts1; EntryAmounts[1])
                {
                    AutoFormatType = 1;
                }
                column(AssetAmounts1; AssetAmounts[1])
                {
                    AutoFormatType = 1;
                }
                column(Description1_FixedAsset; "Fixed Asset".Description)
                {
                }
                column(AssetAmounts2; AssetAmounts[2])
                {
                    AutoFormatType = 1;
                }
                column(AssetAmt1AssetAmt2; AssetAmounts[1] + AssetAmounts[2])
                {
                    AutoFormatType = 1;
                }
                column(DeprCustom1Text_ProjectedDepr; DeprCustom1Text)
                {
                }
                column(AssetAmounts3; AssetAmounts[3])
                {
                    AutoFormatType = 1;
                }
                column(AssetAmounts4; AssetAmounts[4])
                {
                    AutoFormatType = 1;
                }
                column(SalesPriceFieldname_ProjectedDepr; SalesPriceFieldname)
                {
                }
                column(GainLossFieldname_ProjectedDepr; GainLossFieldname)
                {
                }
                column(GroupAmounts_1; GroupAmounts[1])
                {
                }
                column(GroupTotalBookValue; GroupTotalBookValue)
                {
                }
                column(TotalBookValue_1; TotalBookValue[1])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF UntilDate >= EndingDate THEN
                        CurrReport.BREAK;
                    IF Number = 1 THEN BEGIN
                        CalculateFirstDeprAmount(Done);
                        IF FADeprBook."Book Value" <> 0 THEN
                            Done := Done OR NOT EntryPrinted;
                    END ELSE
                        CalculateSecondDeprAmount(Done);
                    IF Done THEN
                        UpdateTotals
                    ELSE
                        UpdateGroupTotals;

                    IF Done THEN
                        IF DoProjectedDisposal THEN
                            CalculateGainLoss;

                    IF ExportToFile THEN
                        AddTotalDeprAmt(DeprAmount); //CS105
                end;

                trigger OnPostDataItem()
                begin
                    IF DoProjectedDisposal THEN BEGIN
                        TotalAmounts[3] += AssetAmounts[3];
                        TotalAmounts[4] += AssetAmounts[4];
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CASE GroupTotals OF
                    GroupTotals::"FA Class":
                        NewValue := "FA Class Code";
                    GroupTotals::"FA Subclass":
                        NewValue := "FA Subclass Code";
                    GroupTotals::"FA Location":
                        NewValue := "FA Location Code";
                    GroupTotals::"Main Asset":
                        NewValue := "Component of Main Asset";
                    GroupTotals::"Global Dimension 1":
                        NewValue := "Global Dimension 1 Code";
                    GroupTotals::"Global Dimension 2":
                        NewValue := "Global Dimension 2 Code";
                    GroupTotals::"FA Posting Group":
                        NewValue := "FA Posting Group";
                END;

                IF NewValue <> OldValue THEN BEGIN
                    MakeGroupHeadLine;
                    InitGroupTotals;
                    OldValue := NewValue;
                END;

                IF NOT FADeprBook.GET("No.", DeprBookCode) THEN
                    CurrReport.SKIP;
                IF SkipRecord THEN
                    CurrReport.SKIP;

                IF GroupTotals = GroupTotals::"FA Posting Group" THEN
                    IF "FA Posting Group" <> FADeprBook."FA Posting Group" THEN
                        ERROR(HasBeenModifiedInFAErr, FIELDCAPTION("FA Posting Group"), "No.");

                StartingDate := StartingDate2;
                EndingDate := EndingDate2;
                DoProjectedDisposal := FALSE;
                EntryPrinted := FALSE;
                IF ProjectedDisposal AND
                   (FADeprBook."Projected Disposal Date" > 0D) AND
                   (FADeprBook."Projected Disposal Date" <= EndingDate)
                THEN BEGIN
                    EndingDate := FADeprBook."Projected Disposal Date";
                    IF StartingDate > EndingDate THEN
                        StartingDate := EndingDate;
                    DoProjectedDisposal := TRUE;
                END;

                TransferValues;

                IF ExportToFile THEN
                    InitTotalDeprAmt("No."); //CS105
            end;

            trigger OnPostDataItem()
            begin

                IF ExportToFile THEN
                    InitTotalDeprAmt('END'); //CS105
            end;

            trigger OnPreDataItem()
            begin
                CASE GroupTotals OF
                    GroupTotals::"FA Class":
                        SETCURRENTKEY("FA Class Code");
                    GroupTotals::"FA Subclass":
                        SETCURRENTKEY("FA Subclass Code");
                    GroupTotals::"FA Location":
                        SETCURRENTKEY("FA Location Code");
                    GroupTotals::"Main Asset":
                        SETCURRENTKEY("Component of Main Asset");
                    GroupTotals::"Global Dimension 1":
                        SETCURRENTKEY("Global Dimension 1 Code");
                    GroupTotals::"Global Dimension 2":
                        SETCURRENTKEY("Global Dimension 2 Code");
                    GroupTotals::"FA Posting Group":
                        SETCURRENTKEY("FA Posting Group");
                END;

                GroupTotalsInt := GroupTotals;
                MakeGroupHeadLine;
                InitGroupTotals;
            end;
        }
        dataitem(ProjectionTotal; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(TotalBookValue2; TotalBookValue[2])
            {
                AutoFormatType = 1;
            }
            column(TotalAmounts1; TotalAmounts[1])
            {
                AutoFormatType = 1;
            }
            column(DeprText2_ProjectionTotal; DeprText2)
            {
            }
            column(ProjectedDisposal_ProjectionTotal; ProjectedDisposal)
            {
            }
            column(DeprBookUseCustDepr_ProjectionTotal; DeprBook."Use Custom 1 Depreciation")
            {
            }
            column(Custom1Text_ProjectionTotal; Custom1Text)
            {
            }
            column(TotalAmounts2; TotalAmounts[2])
            {
                AutoFormatType = 1;
            }
            column(DeprCustom1Text_ProjectionTotal; DeprCustom1Text)
            {
            }
            column(TotalAmt1TotalAmt2; TotalAmounts[1] + TotalAmounts[2])
            {
                AutoFormatType = 1;
            }
            column(SalesPriceFieldname_ProjectionTotal; SalesPriceFieldname)
            {
            }
            column(GainLossFieldname_ProjectionTotal; GainLossFieldname)
            {
            }
            column(TotalAmounts3; TotalAmounts[3])
            {
                AutoFormatType = 1;
            }
            column(TotalAmounts4; TotalAmounts[4])
            {
                AutoFormatType = 1;
            }
            column(TotalCaption; TotalLbl)
            {
            }
        }
        dataitem(Buffer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(DeprBookText_Buffer; DeprBookText)
            {
            }
            column(Custom1TextText_Buffer; Custom1Text)
            {
            }
            column(GroupCodeName2; GroupCodeName2)
            {
            }
            column(FAPostingDate_FABufferProjection; FORMAT(TempFABufferProjection."FA Posting Date"))
            {
            }
            column(Desc_FABufferProjection; TempFABufferProjection.Depreciation)
            {
            }
            column(Cust1_FABufferProjection; TempFABufferProjection."Custom 1")
            {
            }
            column(CodeName_FABufferProj; TempFABufferProjection."Code Name")
            {
            }
            column(ProjectedAmountsperDateCaption; ProjectedAmountsPerDateLbl)
            {
            }
            column(FABufferProjectionFAPostingDateCaption; FABufferProjectionFAPostingDateLbl)
            {
            }
            column(FABufferProjectionDepreciationCaption; FABufferProjectionDepreciationLbl)
            {
            }
            column(FixedAssetProjectedValueCaption_Buffer; FABufferProjectedValueLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT TempFABufferProjection.FIND('-') THEN
                        CurrReport.BREAK;
                END ELSE
                    IF TempFABufferProjection.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;

            trigger OnPreDataItem()
            begin
                IF NOT PrintAmountsPerDate THEN
                    CurrReport.BREAK;
                TempFABufferProjection.RESET;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DepreciationBook; DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                        ToolTip = 'Specifies a code for the depreciation book that is included in the report. You can set up an unlimited number of depreciation books to accommodate various depreciation purposes (such as tax and financial statements). For each depreciation book, you must define the terms and conditions, such as integration with general ledger.';

                        trigger OnValidate()
                        begin
                            UpdateReqForm;
                        end;
                    }
                    field(FirstDeprDate; StartingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'First Depreciation Date';
                        ToolTip = 'Specifies the date to be used as the first date in the period for which you want to calculate projected depreciation.';
                    }
                    field(LastDeprDate; EndingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Last Depreciation Date';
                        ToolTip = 'Specifies the Fixed Asset posting date of the last posted depreciation.';
                    }
                    field(NumberOfDays; PeriodLength)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        Caption = 'Number of Days';
                        Editable = NumberOfDaysCtrlEditable;
                        MinValue = 0;
                        ToolTip = 'Specifies the length of the periods between the first depreciation date and the last depreciation date. The program then calculates depreciation for each period. If you leave this field blank, the program automatically sets the contents of this field to equal the number of days in a fiscal year, normally 360.';

                        trigger OnValidate()
                        begin
                            IF PeriodLength > 0 THEN
                                UseAccountingPeriod := FALSE;
                        end;
                    }
                    field(DaysInFirstPeriod; DaysInFirstPeriod)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        Caption = 'No. of Days in First Period';
                        MinValue = 0;
                        ToolTip = 'Specifies the number of days that must be used for calculating the depreciation as of the first depreciation date, regardless of the actual number of days from the last depreciation entry. The number you enter in this field does not affect the total number of days from the starting date to the ending date.';
                    }
                    field(IncludePostedFrom; IncludePostedFrom)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Posted Entries From';
                        ToolTip = 'Specifies the date from which you want the report to include posted entries. The report will include all types of posted entries that have been posted from that FA posting date.';
                    }
                    field(GroupTotals; GroupTotals)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Group Totals';
                        OptionCaption = ' ,FA Class,FA Subclass,FA Location,Main Asset,Global Dimension 1,Global Dimension 2,FA Posting Group';
                        ToolTip = 'Specifies that you want the report to group the fixed assets and print group totals. For example, if you have set up six FA classes, then select the FA Class option to have group totals printed for each of the six class codes. Select to see the available options. If you do not want group totals to be printed, select the blank option.';
                    }
                    field(CopyToGLBudgetName; BudgetNameCode)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Copy to G/L Budget Name';
                        TableRelation = "G/L Budget Name";
                        ToolTip = 'Specifies the name of the budget that you want to copy to.';

                        trigger OnValidate()
                        begin
                            IF BudgetNameCode = '' THEN
                                BalAccount := FALSE;
                        end;
                    }
                    field(InsertBalAccount; BalAccount)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insert Bal. Account';
                        ToolTip = 'Specifies F9772if you want the program to automatically insert budget entries with balancing accounts.';

                        trigger OnValidate()
                        begin
                            IF BalAccount THEN
                                IF BudgetNameCode = '' THEN
                                    ERROR(YouMustSpecifyErr, GLBudgetName.TABLECAPTION);
                        end;
                    }
                    field(PrintPerFixedAsset; PrintDetails)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Print per Fixed Asset';
                        ToolTip = 'Specifies if you want the report to print information separately for each fixed asset.';
                    }
                    field(ProjectedDisposal; ProjectedDisposal)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Projected Disposal';
                        ToolTip = 'Specifies if you want the report to include projected disposals. The contents of the Projected Proceeds on Disposal field and the Projected Disposal Date field on the fixed asset depreciation book.';
                    }
                    field(PrintAmountsPerDate; PrintAmountsPerDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Print Amounts per Date';
                        ToolTip = 'Specifies that you want the report to include a summary of the calculated depreciation for all assets on the last page.';
                    }
                    field(UseAccountingPeriod; UseAccountingPeriod)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Use Accounting Period';
                        ToolTip = 'Specifies if you want the periods between the starting date and the ending date to correspond to the accounting periods you have specified in the Accounting Periods window. When you select this field, the Number of Days field is cleared.';

                        trigger OnValidate()
                        begin
                            IF UseAccountingPeriod THEN
                                PeriodLength := 0;

                            UpdateReqForm;
                        end;
                    }
                    field(ExportToFile; ExportToFile)
                    {
                        Caption = 'Export To File';
                        ApplicationArea = FixedAssets;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            NumberOfDaysCtrlEditable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            GetFASetup;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        //--CS105--
        IF ExportToFile THEN
            DownloadFromStream(inStream, '', '', '', ExportFileName);

        //--CS105--
    end;

    trigger OnPreReport()
    begin
        //--CS105--
        IF ExportToFile THEN BEGIN
            Clear(TempBlob);
            TempBLOB.CreateOutStream(outStream);
            TempBlob.CreateInStream(InStream);
            InitFile;
            InterfaceMessage.UpdateInterfaceMessage(1, 4, '-----Start Export Fixed Assets Projection ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ' -----');
        END;
        //--CS105--


        DeprBook.GET(DeprBookCode);
        Year365Days := DeprBook."Fiscal Year 365 Days";
        IF GroupTotals = GroupTotals::"FA Posting Group" THEN
            FAGenReport.SetFAPostingGroup("Fixed Asset", DeprBook.Code);
        FAGenReport.AppendFAPostingFilter("Fixed Asset", StartingDate, EndingDate);
        FAFilter := "Fixed Asset".GETFILTERS;
        DeprBookText := STRSUBSTNO('%1%2 %3', DeprBook.TABLECAPTION, ':', DeprBookCode);
        MakeGroupTotalText;
        ValidateDates;
        IF PrintDetails THEN BEGIN
            FANo := "Fixed Asset".FIELDCAPTION("No.");
            FADescription := "Fixed Asset".FIELDCAPTION(Description);
        END;
        IF DeprBook."No. of Days in Fiscal Year" > 0 THEN
            DaysInFiscalYear := DeprBook."No. of Days in Fiscal Year"
        ELSE
            DaysInFiscalYear := 360;
        IF Year365Days THEN
            DaysInFiscalYear := 365;
        IF PeriodLength = 0 THEN
            PeriodLength := DaysInFiscalYear;
        IF (PeriodLength <= 5) OR (PeriodLength > DaysInFiscalYear) THEN
            ERROR(NumberOfDaysMustNotBeGreaterThanErr, DaysInFiscalYear);
        FALedgEntry2."FA Posting Type" := FALedgEntry2."FA Posting Type"::Depreciation;
        DeprText := STRSUBSTNO('%1', FALedgEntry2."FA Posting Type");
        IF DeprBook."Use Custom 1 Depreciation" THEN BEGIN
            DeprText2 := DeprText;
            FALedgEntry2."FA Posting Type" := FALedgEntry2."FA Posting Type"::"Custom 1";
            Custom1Text := STRSUBSTNO('%1', FALedgEntry2."FA Posting Type");
            DeprCustom1Text := STRSUBSTNO('%1 %2 %3', DeprText, '+', Custom1Text);
        END;
        SalesPriceFieldname := FADeprBook.FIELDCAPTION("Projected Proceeds on Disposal");
        GainLossFieldname := ProjectedGainLossTxt;
    end;

    var
        NumberOfDaysMustNotBeGreaterThanErr: Label 'Number of Days must not be greater than %1 or less than 5.', Comment = '1 - Number of days in fiscal year';
        ProjectedGainLossTxt: Label 'Projected Gain/Loss';
        GroupTotalTxt: Label 'Group Total';
        GroupTotalsTxt: Label 'Group Totals';
        HasBeenModifiedInFAErr: Label '%1 has been modified in fixed asset %2.', Comment = '1 - FA Posting Group caption; 2- FA No.';
        GLBudgetName: Record "G/L Budget Name";
        FASetup: Record "FA Setup";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FA: Record "Fixed Asset";
        FALedgEntry2: Record "FA Ledger Entry";
        TempFABufferProjection: Record "FA Buffer Projection" temporary;
        FAGenReport: Codeunit "FA General Report";
        CalculateDepr: Codeunit "Calculate Depreciation";
        FADateCalculation: Codeunit "FA Date Calculation";
        DepreciationCalculation: Codeunit "Depreciation Calculation";
        DeprBookCode: Code[10];
        FAFilter: Text;
        DeprBookText: Text[50];
        GroupCodeName: Text[50];
        GroupCodeName2: Text[50];
        GroupHeadLine: Text[50];
        DeprText: Text[50];
        DeprText2: Text[50];
        Custom1Text: Text[50];
        DeprCustom1Text: Text[50];
        IncludePostedFrom: Date;
        FANo: Text[50];
        FADescription: Text[100];
        GroupTotals: Option " ","FA Class","FA Subclass","FA Location","Main Asset","Global Dimension 1","Global Dimension 2","FA Posting Group";
        BookValue: Decimal;
        NewFiscalYear: Date;
        EndFiscalYear: Date;
        DaysInFiscalYear: Integer;
        Custom1DeprUntil: Date;
        PeriodLength: Integer;
        UseAccountingPeriod: Boolean;
        StartingDate: Date;
        StartingDate2: Date;
        EndingDate: Date;
        EndingDate2: Date;
        PrintAmountsPerDate: Boolean;
        UntilDate: Date;
        PrintDetails: Boolean;
        EntryAmounts: array[4] of Decimal;
        AssetAmounts: array[4] of Decimal;
        GroupAmounts: array[4] of Decimal;
        TotalAmounts: array[4] of Decimal;
        TotalBookValue: array[2] of Decimal;
        GroupTotalBookValue: Decimal;
        DateFromProjection: Date;
        DeprAmounts: Decimal;
        Custom1Amount: Decimal;
        NumberOfDays: Integer;
        Custom1NumberOfDays: Integer;
        DaysInFirstPeriod: Integer;
        Done: Boolean;
        NotFirstGroupTotal: Boolean;
        SalesPriceFieldname: Text[80];
        GainLossFieldname: Text[50];
        ProjectedDisposal: Boolean;
        DoProjectedDisposal: Boolean;
        EntryPrinted: Boolean;
        GroupCodeNameTxt: Label ' ,FA Class,FA Subclass,FA Location,Main Asset,Global Dimension 1,Global Dimension 2,FA Posting Group';
        BudgetNameCode: Code[10];
        OldValue: Code[20];
        NewValue: Code[20];
        BalAccount: Boolean;
        YouMustSpecifyErr: Label 'You must specify %1.', Comment = '1 - G/L Budget Name caption';
        TempDeprDate: Date;
        GroupTotalsInt: Integer;
        Year365Days: Boolean;
        YouMustCreateAccPeriodsErr: Label 'You must create accounting periods until %1 to use 365 days depreciation and ''Use Accounting Periods''.', Comment = '1 - Date';

        NumberOfDaysCtrlEditable: Boolean;
        PageNoLbl: Label 'Page';
        FAProjectedValueLbl: Label 'Fixed Asset - Projected Value';
        FAPostingDateLbl: Label 'FA Posting Date';
        BookValueLbl: Label 'Book Value';
        PostedEntryLbl: Label 'Posted Entry';
        TotalLbl: Label 'Total';
        ProjectedAmountsPerDateLbl: Label 'Projected Amounts per Date';
        FABufferProjectionFAPostingDateLbl: Label 'FA Posting Date';
        FABufferProjectionDepreciationLbl: Label 'Depreciation';
        FABufferProjectedValueLbl: Label 'Fixed Asset - Projected Value';
        DeprAmount: Decimal;
        "--- CS_105--": Integer;
        LogFileName: Text;
        TotalDeprAmount: Decimal;
        CompanyInfo: Record "Company Information";
        CurrentAsset: Code[20];
        ExportFileName: Text;
        BackupFileName: Text;
        Assetcount: Integer;
        ExportToFile: Boolean;
        DataText: BigText;
        inStream: InStream;
        outStream: OutStream;
        TempBLOB: codeunit "Temp Blob";
        InterfaceMessage: Codeunit "Interface Message";

    local procedure SkipRecord(): Boolean
    begin
        EXIT(
          "Fixed Asset".Inactive OR
          (FADeprBook."Acquisition Date" = 0D) OR
          (FADeprBook."Acquisition Date" > EndingDate) OR
          (FADeprBook."Last Depreciation Date" > EndingDate) OR
          (FADeprBook."Disposal Date" > 0D));
    end;

    local procedure TransferValues()
    begin
        FADeprBook.CALCFIELDS("Book Value", Depreciation, "Custom 1");
        DateFromProjection := 0D;
        EntryAmounts[1] := FADeprBook."Book Value";
        EntryAmounts[2] := FADeprBook."Custom 1";
        EntryAmounts[3] := DepreciationCalculation.DeprInFiscalYear("Fixed Asset"."No.", DeprBookCode, StartingDate);
        TotalBookValue[1] := TotalBookValue[1] + FADeprBook."Book Value";
        TotalBookValue[2] := TotalBookValue[2] + FADeprBook."Book Value";
        GroupTotalBookValue += FADeprBook."Book Value";
        NewFiscalYear := FADateCalculation.GetFiscalYear(DeprBookCode, StartingDate);
        EndFiscalYear := FADateCalculation.CalculateDate(
            DepreciationCalculation.Yesterday(NewFiscalYear, Year365Days), DaysInFiscalYear, Year365Days);
        TempDeprDate := FADeprBook."Temp. Ending Date";

        IF DeprBook."Use Custom 1 Depreciation" THEN
            Custom1DeprUntil := FADeprBook."Depr. Ending Date (Custom 1)"
        ELSE
            Custom1DeprUntil := 0D;

        IF Custom1DeprUntil > 0D THEN
            EntryAmounts[4] := GetDeprBasis;
        UntilDate := 0D;
        AssetAmounts[1] := 0;
        AssetAmounts[2] := 0;
        AssetAmounts[3] := 0;
        AssetAmounts[4] := 0;
    end;

    local procedure CalculateFirstDeprAmount(var Done: Boolean)
    var
        FirstTime: Boolean;
    begin
        FirstTime := TRUE;
        UntilDate := StartingDate;
        REPEAT
            IF NOT FirstTime THEN
                GetNextDate;
            FirstTime := FALSE;
            CalculateDepr.Calculate(
              DeprAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays,
              "Fixed Asset"."No.", DeprBookCode, UntilDate, EntryAmounts, 0D, DaysInFirstPeriod);
            Done := (DeprAmount <> 0) OR (Custom1Amount <> 0);
        UNTIL (UntilDate >= EndingDate) OR Done;
        EntryAmounts[3] :=
          DepreciationCalculation.DeprInFiscalYear("Fixed Asset"."No.", DeprBookCode, UntilDate);
    end;

    local procedure CalculateSecondDeprAmount(var Done: Boolean)
    begin
        GetNextDate;
        CalculateDepr.Calculate(
          DeprAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays,
          "Fixed Asset"."No.", DeprBookCode, UntilDate, EntryAmounts, DateFromProjection, 0);
        Done := CalculationDone(
            (DeprAmount <> 0) OR (Custom1Amount <> 0), DateFromProjection);
    end;

    local procedure GetNextDate()
    var
        UntilDate2: Date;
    begin
        UntilDate2 := GetPeriodEndingDate(UseAccountingPeriod, UntilDate, PeriodLength);
        IF Custom1DeprUntil > 0D THEN
            IF (UntilDate < Custom1DeprUntil) AND (UntilDate2 > Custom1DeprUntil) THEN
                UntilDate2 := Custom1DeprUntil;

        IF TempDeprDate > 0D THEN
            IF (UntilDate < TempDeprDate) AND (UntilDate2 > TempDeprDate) THEN
                UntilDate2 := TempDeprDate;

        IF (UntilDate < EndFiscalYear) AND (UntilDate2 > EndFiscalYear) THEN
            UntilDate2 := EndFiscalYear;

        IF UntilDate = EndFiscalYear THEN BEGIN
            EntryAmounts[3] := 0;
            NewFiscalYear := DepreciationCalculation.ToMorrow(EndFiscalYear, Year365Days);
            EndFiscalYear := FADateCalculation.CalculateDate(EndFiscalYear, DaysInFiscalYear, Year365Days);
        END;

        DateFromProjection := DepreciationCalculation.ToMorrow(UntilDate, Year365Days);
        UntilDate := UntilDate2;
        IF UntilDate >= EndingDate THEN
            UntilDate := EndingDate;
    end;

    local procedure GetPeriodEndingDate(UseAccountingPeriod: Boolean; PeriodEndingDate: Date; var PeriodLength: Integer): Date
    var
        AccountingPeriod: Record "Accounting Period";
        UntilDate2: Date;
    begin
        IF NOT UseAccountingPeriod OR AccountingPeriod.ISEMPTY THEN
            EXIT(FADateCalculation.CalculateDate(PeriodEndingDate, PeriodLength, Year365Days));
        AccountingPeriod.SETFILTER(
          "Starting Date", '>=%1', DepreciationCalculation.ToMorrow(PeriodEndingDate, Year365Days) + 1);
        IF AccountingPeriod.FINDFIRST THEN BEGIN
            IF DATE2DMY(AccountingPeriod."Starting Date", 1) <> 31 THEN
                UntilDate2 := DepreciationCalculation.Yesterday(AccountingPeriod."Starting Date", Year365Days)
            ELSE
                UntilDate2 := AccountingPeriod."Starting Date" - 1;
            PeriodLength :=
              DepreciationCalculation.DeprDays(
                DepreciationCalculation.ToMorrow(PeriodEndingDate, Year365Days), UntilDate2, Year365Days);
            IF (PeriodLength <= 5) OR (PeriodLength > DaysInFiscalYear) THEN
                PeriodLength := DaysInFiscalYear;
            EXIT(UntilDate2);
        END;
        IF Year365Days THEN
            ERROR(YouMustCreateAccPeriodsErr, DepreciationCalculation.ToMorrow(EndingDate, Year365Days) + 1);
        EXIT(FADateCalculation.CalculateDate(PeriodEndingDate, PeriodLength, Year365Days));
    end;

    local procedure MakeGroupTotalText()
    begin
        CASE GroupTotals OF
            GroupTotals::"FA Class":
                GroupCodeName := "Fixed Asset".FIELDCAPTION("FA Class Code");
            GroupTotals::"FA Subclass":
                GroupCodeName := "Fixed Asset".FIELDCAPTION("FA Subclass Code");
            GroupTotals::"FA Location":
                GroupCodeName := "Fixed Asset".FIELDCAPTION("FA Location Code");
            GroupTotals::"Main Asset":
                GroupCodeName := "Fixed Asset".FIELDCAPTION("Main Asset/Component");
            GroupTotals::"Global Dimension 1":
                GroupCodeName := "Fixed Asset".FIELDCAPTION("Global Dimension 1 Code");
            GroupTotals::"Global Dimension 2":
                GroupCodeName := "Fixed Asset".FIELDCAPTION("Global Dimension 2 Code");
            GroupTotals::"FA Posting Group":
                GroupCodeName := "Fixed Asset".FIELDCAPTION("FA Posting Group");
        END;
        IF GroupCodeName <> '' THEN BEGIN
            GroupCodeName2 := GroupCodeName;
            IF GroupTotals = GroupTotals::"Main Asset" THEN
                GroupCodeName2 := STRSUBSTNO('%1', SELECTSTR(GroupTotals + 1, GroupCodeNameTxt));
            GroupCodeName := STRSUBSTNO('%1%2 %3', GroupTotalsTxt, ':', GroupCodeName2);
        END;
    end;

    local procedure ValidateDates()
    begin
        FAGenReport.ValidateDeprDates(StartingDate, EndingDate);
        EndingDate2 := EndingDate;
        StartingDate2 := StartingDate;
    end;

    local procedure MakeGroupHeadLine()
    begin
        CASE GroupTotals OF
            GroupTotals::"FA Class":
                GroupHeadLine := "Fixed Asset"."FA Class Code";
            GroupTotals::"FA Subclass":
                GroupHeadLine := "Fixed Asset"."FA Subclass Code";
            GroupTotals::"FA Location":
                GroupHeadLine := "Fixed Asset"."FA Location Code";
            GroupTotals::"Main Asset":
                BEGIN
                    FA."Main Asset/Component" := FA."Main Asset/Component"::"Main Asset";
                    GroupHeadLine :=
                      STRSUBSTNO('%1 %2', FA."Main Asset/Component", "Fixed Asset"."Component of Main Asset");
                    IF "Fixed Asset"."Component of Main Asset" = '' THEN
                        GroupHeadLine := STRSUBSTNO('%1%2', GroupHeadLine, '*****');
                END;
            GroupTotals::"Global Dimension 1":
                GroupHeadLine := "Fixed Asset"."Global Dimension 1 Code";
            GroupTotals::"Global Dimension 2":
                GroupHeadLine := "Fixed Asset"."Global Dimension 2 Code";
            GroupTotals::"FA Posting Group":
                GroupHeadLine := "Fixed Asset"."FA Posting Group";
        END;
        IF GroupHeadLine = '' THEN
            GroupHeadLine := '*****';
    end;

    local procedure UpdateTotals()
    var
        BudgetDepreciation: Codeunit "Budget Depreciation";
        EntryNo: Integer;
        CodeName: Code[20];
    begin
        EntryAmounts[1] := EntryAmounts[1] + DeprAmount + Custom1Amount;
        IF Custom1DeprUntil > 0D THEN
            IF UntilDate <= Custom1DeprUntil THEN
                EntryAmounts[4] := EntryAmounts[4] + DeprAmount + Custom1Amount;
        EntryAmounts[2] := EntryAmounts[2] + Custom1Amount;
        EntryAmounts[3] := EntryAmounts[3] + DeprAmount + Custom1Amount;
        AssetAmounts[1] := AssetAmounts[1] + DeprAmount;
        AssetAmounts[2] := AssetAmounts[2] + Custom1Amount;
        GroupAmounts[1] := GroupAmounts[1] + DeprAmount;
        GroupAmounts[2] := GroupAmounts[2] + Custom1Amount;
        TotalAmounts[1] := TotalAmounts[1] + DeprAmount;
        TotalAmounts[2] := TotalAmounts[2] + Custom1Amount;
        TotalBookValue[1] := TotalBookValue[1] + DeprAmount + Custom1Amount;
        TotalBookValue[2] := TotalBookValue[2] + DeprAmount + Custom1Amount;
        GroupTotalBookValue += DeprAmount + Custom1Amount;
        IF BudgetNameCode <> '' THEN
            BudgetDepreciation.CopyProjectedValueToBudget(
              FADeprBook, BudgetNameCode, UntilDate, DeprAmount, Custom1Amount, BalAccount);

        IF (UntilDate > 0D) OR PrintAmountsPerDate THEN BEGIN
            TempFABufferProjection.RESET;
            IF TempFABufferProjection.FIND('+') THEN
                EntryNo := TempFABufferProjection."Entry No." + 1
            ELSE
                EntryNo := 1;
            TempFABufferProjection.SETRANGE("FA Posting Date", UntilDate);
            IF GroupTotals <> GroupTotals::" " THEN BEGIN
                CASE GroupTotals OF
                    GroupTotals::"FA Class":
                        CodeName := "Fixed Asset"."FA Class Code";
                    GroupTotals::"FA Subclass":
                        CodeName := "Fixed Asset"."FA Subclass Code";
                    GroupTotals::"FA Location":
                        CodeName := "Fixed Asset"."FA Location Code";
                    GroupTotals::"Main Asset":
                        CodeName := "Fixed Asset"."Component of Main Asset";
                    GroupTotals::"Global Dimension 1":
                        CodeName := "Fixed Asset"."Global Dimension 1 Code";
                    GroupTotals::"Global Dimension 2":
                        CodeName := "Fixed Asset"."Global Dimension 2 Code";
                    GroupTotals::"FA Posting Group":
                        CodeName := "Fixed Asset"."FA Posting Group";
                END;
                TempFABufferProjection.SETRANGE("Code Name", CodeName);
            END;
            IF NOT TempFABufferProjection.FIND('=><') THEN BEGIN
                TempFABufferProjection.INIT;
                TempFABufferProjection."Code Name" := CodeName;
                TempFABufferProjection."FA Posting Date" := UntilDate;
                TempFABufferProjection."Entry No." := EntryNo;
                TempFABufferProjection.Depreciation := DeprAmount;
                TempFABufferProjection."Custom 1" := Custom1Amount;
                TempFABufferProjection.INSERT;
            END ELSE BEGIN
                TempFABufferProjection.Depreciation := TempFABufferProjection.Depreciation + DeprAmount;
                TempFABufferProjection."Custom 1" := TempFABufferProjection."Custom 1" + Custom1Amount;
                TempFABufferProjection.MODIFY;
            END;
        END;
    end;

    local procedure InitGroupTotals()
    begin
        GroupAmounts[1] := 0;
        GroupAmounts[2] := 0;
        GroupAmounts[3] := 0;
        GroupAmounts[4] := 0;
        GroupTotalBookValue := 0;
        IF NotFirstGroupTotal THEN
            TotalBookValue[1] := 0
        ELSE
            TotalBookValue[1] := EntryAmounts[1];
        NotFirstGroupTotal := TRUE;
    end;

    local procedure GetDeprBasis(): Decimal
    var
        FALedgEntry: Record "FA Ledger Entry";
    begin
        FALedgEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "Part of Book Value", "FA Posting Date");
        FALedgEntry.SETRANGE("FA No.", "Fixed Asset"."No.");
        FALedgEntry.SETRANGE("Depreciation Book Code", DeprBookCode);
        FALedgEntry.SETRANGE("Part of Book Value", TRUE);
        FALedgEntry.SETRANGE("FA Posting Date", 0D, Custom1DeprUntil);
        FALedgEntry.CALCSUMS(Amount);
        EXIT(FALedgEntry.Amount);
    end;

    local procedure CalculateGainLoss()
    var
        CalculateDisposal: Codeunit "Calculate Disposal";
        EntryAmounts: array[14] of Decimal;
        PrevAmount: array[2] of Decimal;
    begin
        PrevAmount[1] := AssetAmounts[3];
        PrevAmount[2] := AssetAmounts[4];

        CalculateDisposal.CalcGainLoss("Fixed Asset"."No.", DeprBookCode, EntryAmounts);
        AssetAmounts[3] := FADeprBook."Projected Proceeds on Disposal";
        IF EntryAmounts[1] <> 0 THEN
            AssetAmounts[4] := EntryAmounts[1]
        ELSE
            AssetAmounts[4] := EntryAmounts[2];
        AssetAmounts[4] :=
          AssetAmounts[4] + AssetAmounts[1] + AssetAmounts[2] - FADeprBook."Projected Proceeds on Disposal";

        GroupAmounts[3] += AssetAmounts[3] - PrevAmount[1];
        GroupAmounts[4] += AssetAmounts[4] - PrevAmount[2];
    end;

    local procedure CalculationDone(Done: Boolean; FirstDeprDate: Date): Boolean
    var
        TableDeprCalculation: Codeunit "Table Depr. Calculation";
    begin
        IF Done OR
           (FADeprBook."Depreciation Method" <> FADeprBook."Depreciation Method"::"User-Defined")
        THEN
            EXIT(Done);
        EXIT(
          TableDeprCalculation.GetTablePercent(
            DeprBookCode, FADeprBook."Depreciation Table Code",
            FADeprBook."First User-Defined Depr. Date", FirstDeprDate, UntilDate) = 0);
    end;

    local procedure UpdateReqForm()
    begin
        PageUpdateReqForm;
    end;

    local procedure PageUpdateReqForm()
    var
        DeprBook: Record "Depreciation Book";
    begin
        IF DeprBookCode <> '' THEN
            DeprBook.GET(DeprBookCode);

        PeriodLength := 0;
        IF DeprBook."Fiscal Year 365 Days" AND NOT UseAccountingPeriod THEN
            PeriodLength := 365;
    end;

    procedure SetMandatoryFields(DepreciationBookCodeFrom: Code[10]; StartingDateFrom: Date; EndingDateFrom: Date)
    begin
        DeprBookCode := DepreciationBookCodeFrom;
        StartingDate := StartingDateFrom;
        EndingDate := EndingDateFrom;
    end;

    procedure SetPeriodFields(PeriodLengthFrom: Integer; DaysInFirstPeriodFrom: Integer; IncludePostedFromFrom: Date; UseAccountingPeriodFrom: Boolean)
    begin
        PeriodLength := PeriodLengthFrom;
        DaysInFirstPeriod := DaysInFirstPeriodFrom;
        IncludePostedFrom := IncludePostedFromFrom;
        UseAccountingPeriod := UseAccountingPeriodFrom;
    end;

    procedure SetTotalFields(GroupTotalsFrom: Option; PrintDetailsFrom: Boolean)
    begin
        GroupTotals := GroupTotalsFrom;
        PrintDetails := PrintDetailsFrom;
    end;

    procedure SetBudgetField(BudgetNameCodeFrom: Code[10]; BalAccountFrom: Boolean; ProjectedDisposalFrom: Boolean; PrintAmountsPerDateFrom: Boolean)
    begin
        BudgetNameCode := BudgetNameCodeFrom;
        BalAccount := BalAccountFrom;
        ProjectedDisposal := ProjectedDisposalFrom;
        PrintAmountsPerDate := PrintAmountsPerDateFrom;
    end;

    procedure GetFASetup()
    begin
        IF DeprBookCode = '' THEN BEGIN
            FASetup.GET;
            DeprBookCode := FASetup."Default Depr. Book";
        END;
        UpdateReqForm;
    end;

    local procedure UpdateGroupTotals()
    begin
        GroupAmounts[1] := GroupAmounts[1] + DeprAmount;
        TotalAmounts[1] := TotalAmounts[1] + DeprAmount;
    end;

    local procedure "--CS_105--"()
    begin
    end;

    local procedure InitTotalDeprAmt(Asset: Code[20])
    var
        Tb: Text;
        Line: Text;
        TempFile: File;
        Cr: Char;
    begin
        Tb[1] := 9;
        Cr := 13;

        IF (CurrentAsset <> '') THEN BEGIN
            Line := Tb + Tb + FORMAT(CALCDATE('1D', StartingDate), 0, '<Year4>/<Month,2>') +
                    Tb + Tb + Tb + Tb + Tb + Tb + Tb + Tb + Tb + Tb + Tb +
                    Tb + Tb + Tb + Tb + Tb + Tb + Tb + Tb + Tb + Tb + Tb +
                    CurrentAsset + Tb +
                    '0' + Tb + Tb +
                    FORMAT(TotalDeprAmount, 0, '<Integer><Decimals>') + Tb +
                    '0' + Tb + '0' + Tb + '0' + Tb + '0' + Tb + '0' + Tb + '0' + Tb +
                    '0' + Tb + '0' + Tb + '0' + Tb + '0' + Tb + '0' + Tb +
                    Tb + Tb + Tb + Cr;
            SaveLineToFile(Line);
            Assetcount += 1;
        END;

        TotalDeprAmount := 0;
        CurrentAsset := Asset;

        IF Asset = 'END' THEN BEGIN
            InterfaceMessage.UpdateInterfaceMessage(1, 4, 'Exported ' + FORMAT(Assetcount) + ' Assets');
            InterfaceMessage.UpdateInterfaceMessage(1, 4, '-----End Export Fixed Assets Projection ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ' -----');
            Tb := 'END';
            DataText.AddText(Tb);
            DataText.Write(outStream);
        END;
    end;

    local procedure AddTotalDeprAmt(AddAmount: Decimal)
    begin

        TotalDeprAmount += AddAmount;

        //MESSAGE(CurrentAsset + ' ' + FORMAT(TotalDeprAmount));
    end;

    local procedure SaveLineToFile(MessageString: Text)
    begin
        DataText.AddText(MessageString);
    end;

    local procedure InitFile()
    begin
        ExportFileName := 'A1WUD_' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.tsv';
    end;


}

