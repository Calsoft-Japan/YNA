report 50005 "Journal Test - Applied Entries"
{
    // ==================================================================
    // Ver No.   Date        Sign. ID      Description
    // ------------------------------------------------------------------
    // CS1.0     2016-08-16  Tony  FDD213  Journal Test - Applied Entries Report
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Journal Test - Applied Entries.rdlc';

    Caption = 'Journal Test - Applied Entries';
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Gen. Journal Batch"; "Gen. Journal Batch")
        {
            DataItemTableView = SORTING("Journal Template Name", Name);
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                PrintOnlyIfDetail = true;
                column(ReportTitle; ReportTitle)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(CompanyInformation_Name; CompanyInformation.Name)
                {
                }
                column(CurrReport_PAGENO; 0)
                {
                }
                column(USERID; USERID)
                {
                }
                column(JournalTemplateName; "Gen. Journal Batch"."Journal Template Name")
                {
                }
                column(JournalBatchName; "Gen. Journal Batch".Name)
                {
                }
                column(TIME; TIME)
                {
                }
                column(TABLECAPTION__GenJnlLineFilter; "Gen. Journal Line".TABLECAPTION + ': ' + GenJnlLineFilter)
                {
                }
                column(USText001; USText001)
                {
                }
                column(GenJnlLineFilter; GenJnlLineFilter)
                {
                }
                column(GenJnlTemplate_Force_Doc_Balance; GenJnlTemplate."Force Doc. Balance")
                {
                }
                column(Integer_Number; Number)
                {
                }
                column(PAGENO_Caption; PAGENO_Caption)
                {
                }
                column(Journal_Template_Name_Caption; Journal_Template_Name_Caption)
                {
                }
                column(Journal_Batch_Caption; Journal_Batch_Caption)
                {
                }
                column(Bank_Payment_Type_Caption; Bank_Payment_Type_Caption)
                {
                }
                column(Bal_Account_Number_Caption; Bal_Account_Number_Caption)
                {
                }
                column(TB_Posting_Date_Caption; TB_Posting_Date_Caption)
                {
                }
                column(TB_Description_Caption; TB_Description_Caption)
                {
                }
                column(TB_Pay_To_Vendor_Caption; TB_Pay_To_Vendor_Caption)
                {
                }
                column(TB_Vendor_Name_Caption; TB_Vendor_Name_Caption)
                {
                }
                column(TB_Doc_Date_Caption; TB_Doc_Date_Caption)
                {
                }
                column(TB_Buy_From_Vendor_Caption; TB_Buy_From_Vendor_Caption)
                {
                }
                column(TB_External_Document_No_Caption; TB_External_Document_No_Caption)
                {
                }
                column(TB_Due_Date_Caption; TB_Due_Date_Caption)
                {
                }
                column(TB_Amount_Caption; TB_Amount_Caption)
                {
                }
                column(TB_Amount_To_Apply_Caption; TB_Amount_To_Apply_Caption)
                {
                }
                column(TB_Document_No_Caption; TB_Document_No_Caption)
                {
                }
                column(TB_Amount_USD_Caption; TB_Amount_USD_Caption)
                {
                }
                column(TB_Amount_To_Apply_USD_Caption; TB_Amount_To_Apply_USD_Caption)
                {
                }
                column(TB_GLE_Account_No_Caption; TB_GLE_Account_No_Caption)
                {
                }
                column(TB_GLE_Dept_Code_Caption; TB_GLE_Dept_Code_Caption)
                {
                }
                column(TB_GLE_KG_Caption; TB_GLE_KG_Caption)
                {
                }
                column(TB_GLE_Desctiption_Caption; TB_GLE_Desctiption_Caption)
                {
                }
                column(TB_GLE_Amount_Caption; TB_GLE_Amount_Caption)
                {
                }
                column(Total_Amount; sumAmount)
                {
                }
                column(Total_Balance; sumBalance)
                {
                }
                column(Subtotal_Amount; subAmount)
                {
                }
                column(isPaymentJournal; isPaymentJournal)
                {
                }
                dataitem("Gen. Journal Line"; "Gen. Journal Line")
                {
                    DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                   "Journal Batch Name" = FIELD(Name);
                    DataItemLinkReference = "Gen. Journal Batch";
                    DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Bank Payment Type", "Bal. Account No.", "Posting Date", "Document No.");
                    RequestFilterFields = "Posting Date";
                    column(Posting_Date; "Posting Date")
                    {
                    }
                    column(Document_Type; "Document Type")
                    {
                    }
                    column(Document_No; "Document No.")
                    {
                    }
                    column(Account_Type; "Account Type")
                    {
                    }
                    column(Account_No; "Account No.")
                    {
                    }
                    column(AccountName; AccountName)
                    {
                    }
                    column(Description; Description)
                    {
                    }
                    column(Amount; Amount)
                    {
                    }
                    column(Currency_Code; "Currency Code")
                    {
                    }
                    column(Bal_Account_No; "Bal. Account No.")
                    {
                    }
                    column(Bal_Account_Type; "Bal. Account Type")
                    {
                    }
                    column(Bal_Account_Description; BalAccount_Desp)
                    {
                    }
                    column(Bank_Payment_Type; "Bank Payment Type")
                    {
                    }
                    column(Applies_to_Doc_Type; "Applies-to Doc. Type")
                    {
                    }
                    column(Applies_to_Doc_No; "Applies-to Doc. No.")
                    {
                    }
                    column(Amount_LCY; "Amount (LCY)")
                    {
                    }
                    column(Balance_LCY; "Balance (LCY)")
                    {
                        IncludeCaption = true;
                    }
                    column(Journal_Template_Name; "Journal Template Name")
                    {
                    }
                    column(Journal_Batch_Name; "Journal Batch Name")
                    {
                    }
                    column(Line_No; "Line No.")
                    {
                    }
                    column(Amount_LCY_Caption; CAPTIONCLASSTRANSLATE('101,0,Total (%1)'))
                    {
                    }
                    column(ShowNone; isDisplayNone)
                    {
                    }
                    column(Gross_Amount; GrossAmount)
                    {
                    }
                    column(The_Address; theAddress)
                    {
                    }
                    dataitem(VendorLedgerEntry; Integer)
                    {
                        //The property 'DataItemTableView' shouldn't have an empty value.
                        //DataItemTableView = '';
                        column(VLE_EntryNo; mEntryNo)
                        {
                        }
                        column(VLE_Document_Date; mDocDate)
                        {
                        }
                        column(VLE_Vendor_No; mNo)
                        {
                        }
                        column(VLE_External_Document_No; ExtDocNo)
                        {
                        }
                        column(VLE_Due_Date; mDueDate)
                        {
                        }
                        column(VLE_Description; mDescription)
                        {
                        }
                        column(VLE_Amount_to_Apply; AmountToApply)
                        {
                        }
                        column(VLE_Amount_to_Apply_LCY; NetAmount)
                        {
                        }
                        column(VLE_Currency_Code; mCC)
                        {
                        }
                        column(VLE_Document_No; mDocNo)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            tRemainingAmount: Decimal;
                            //tDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
                            tDocType: Enum "Gen. Journal Document Type";
                            tRPDP: Decimal;
                            tPmtDiscountDate: Date;
                            tAPT: Decimal;
                            tAPDT: Boolean;
                        begin
                            IF Number = 1 THEN BEGIN
                                IF isPaymentJournal THEN
                                    tempVLE.FIND('-')
                                ELSE
                                    tempCLE.FIND('-');
                            END
                            ELSE BEGIN
                                IF isPaymentJournal THEN
                                    tempVLE.NEXT
                                ELSE
                                    tempCLE.NEXT;
                            END;

                            TotalAppliedVendorEntryCounts := TotalAppliedVendorEntryCounts + 1;
                            IF isPaymentJournal THEN BEGIN
                                tempVLE.CALCFIELDS(tempVLE."Remaining Amount");
                                tRemainingAmount := tempVLE."Remaining Amount";
                                AmountToApply_LCY := tempVLE."Amount to Apply";
                                ExtDocNo := COPYSTR(tempVLE."External Document No.", 1, 20);
                                mEntryNo := tempVLE."Entry No.";
                                mDocDate := tempVLE."Document Date";
                                mNo := tempVLE."Vendor No.";
                                mDueDate := tempVLE."Due Date";
                                mDescription := tempVLE.Description;
                                mCC := tempVLE."Currency Code";
                                mDocNo := tempVLE."Document No.";
                                AmountToApply := tempVLE."Amount to Apply";
                                tRPDP := tempVLE."Remaining Pmt. Disc. Possible";
                                tDocType := tempVLE."Document Type";
                                tPmtDiscountDate := tempVLE."Pmt. Discount Date";
                                tAPT := tempVLE."Accepted Payment Tolerance";
                                tAPDT := tempVLE."Accepted Pmt. Disc. Tolerance"
                            END
                            ELSE BEGIN
                                tempCLE.CALCFIELDS(tempCLE."Remaining Amount");
                                tRemainingAmount := tempCLE."Remaining Amount";
                                AmountToApply_LCY := tempCLE."Amount to Apply";
                                ExtDocNo := COPYSTR(tempCLE."External Document No.", 1, 13);
                                mEntryNo := tempCLE."Entry No.";
                                mDocDate := tempCLE."Document Date";
                                mNo := tempCLE."Customer No.";
                                mDueDate := tempCLE."Due Date";
                                mDescription := tempCLE.Description;
                                mCC := tempCLE."Currency Code";
                                mDocNo := tempCLE."Document No.";
                                AmountToApply := tempCLE."Amount to Apply";
                                tRPDP := tempCLE."Remaining Pmt. Disc. Possible";
                                tDocType := tempCLE."Document Type";
                                tPmtDiscountDate := tempCLE."Pmt. Discount Date";
                                tAPT := tempCLE."Accepted Payment Tolerance";
                                tAPDT := tempCLE."Accepted Pmt. Disc. Tolerance";
                            END;


                            IF mCC <> '' THEN BEGIN
                                IF mCC <> Currency.Code THEN BEGIN
                                    tRemainingAmount := ROUND(CurrExchRate.ExchangeAmtFCYToFCY(
                                                                   "Gen. Journal Line"."Posting Date",
                                                                   mCC,
                                                                   Currency.Code,
                                                                   tRemainingAmount),
                                                                   Currency."Amount Rounding Precision");
                                    AmountToApply := ROUND(CurrExchRate.ExchangeAmtFCYToFCY(
                                                                   "Gen. Journal Line"."Posting Date",
                                                                   mCC,
                                                                   Currency.Code,
                                                                   AmountToApply),
                                                                   Currency."Amount Rounding Precision");
                                    tAPT := ROUND(CurrExchRate.ExchangeAmtFCYToFCY(
                                                                   "Gen. Journal Line"."Posting Date",
                                                                   mCC,
                                                                   Currency.Code,
                                                                   tAPT),
                                                                   Currency."Amount Rounding Precision");
                                    tRPDP := ROUND(CurrExchRate.ExchangeAmtFCYToFCY(
                                                                   "Gen. Journal Line"."Posting Date",
                                                                   mCC,
                                                                   Currency.Code,
                                                                   tRPDP),
                                                                   Currency."Amount Rounding Precision");

                                    AmountToApply_LCY := ROUND(CurrExchRate.ExchangeAmtFCYToFCY(
                                                                   "Gen. Journal Line"."Posting Date",
                                                                   mCC,
                                                                   Currency.Code,
                                                                   AmountToApply),
                                                                   Currency."Amount Rounding Precision");

                                END
                                ELSE BEGIN
                                    tRemainingAmount := ROUND(CurrExchRate.ExchangeAmtFCYToFCY(
                                                                   "Gen. Journal Line"."Posting Date",
                                                                   mCC,
                                                                   '',
                                                                   tRemainingAmount),
                                                                   Currency."Amount Rounding Precision");
                                    tRPDP := ROUND(CurrExchRate.ExchangeAmtFCYToFCY(
                                                                   "Gen. Journal Line"."Posting Date",
                                                                   mCC,
                                                                   '',
                                                                   tRPDP),
                                                                   Currency."Amount Rounding Precision");

                                    AmountToApply_LCY := ROUND(CurrExchRate.ExchangeAmtFCYToFCY(
                                                                   "Gen. Journal Line"."Posting Date",
                                                                   mCC,
                                                                   '',
                                                                   AmountToApply),
                                                                   Currency."Amount Rounding Precision");
                                END;
                            END;

                            AmountDue := tRemainingAmount;
                            AmountPmtTolerance := tAPT;
                            AmountDiscounted := 0;
                            AmountPmtDiscTolerance := 0;
                            IF (tRPDP <> 0) AND ((tPmtDiscountDate >= "Gen. Journal Line"."Posting Date") OR tAPDT) AND
                               (RemainingAmountToApply + AmountPmtTolerance + tRPDP >= AmountDue) THEN BEGIN
                                IF tPmtDiscountDate >= "Gen. Journal Line"."Posting Date" THEN
                                    AmountDiscounted := tRPDP
                                ELSE
                                    AmountPmtDiscTolerance := tRPDP;
                            END;
                            AmountApplied := RemainingAmountToApply + AmountPmtTolerance + AmountDiscounted + AmountPmtDiscTolerance;
                            IF AmountApplied > AmountToApply THEN
                                AmountApplied := AmountToApply;
                            AmountPaid := AmountApplied - AmountPmtTolerance - AmountDiscounted - AmountPmtDiscTolerance;
                            IF AmountApplied > AmountDue THEN
                                AmountApplied := AmountDue;

                            IF (tDocType = tDocType::Invoice) AND
                               ("Gen. Journal Line"."Posting Date" <= tPmtDiscountDate) THEN
                                NetAmount := (tRemainingAmount - tRPDP)
                            ELSE
                                NetAmount := tRemainingAmount;
                            RemainingAmountToApply := RemainingAmountToApply - AmountPaid;
                            TotalAmountApplied := TotalAmountApplied + AmountApplied;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF isPaymentJournal THEN
                                SETRANGE(Number, 1, tempVLE.COUNT)
                            ELSE
                                SETRANGE(Number, 1, tempCLE.COUNT);
                        end;
                    }
                    dataitem(TempLoop; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(TempLoop_Number; Number)
                        {
                        }
                    }
                    dataitem(ErrorLoop; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(ErrorText_Number; ErrorText[Number])
                        {
                        }
                        column(ErrorCounter; ErrorCounter)
                        {
                        }
                        column(ErrorLoop_Number; Number)
                        {
                        }
                        column(ErrorText_Number_Caption; ErrorText_Number_Caption)
                        {
                        }

                        trigger OnPostDataItem()
                        begin
                            ErrorCounter := 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, ErrorCounter);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        PaymentTerms: Record "Payment Terms";
                        DimMgt: Codeunit DimensionManagement;
                        TableID: array[10] of Integer;
                        No: array[10] of Code[20];
                    begin
                        IF "Currency Code" = '' THEN
                            "Amount (LCY)" := Amount;

                        UpdateLineBalance;

                        BalAccount_Desp := '';
                        AccountName := '';
                        theAddress := '';
                        CLEAR(BankAcct2);
                        IF ("Bal. Account No." <> '') AND ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") THEN BEGIN
                            BankAcct2.GET("Bal. Account No.");
                            BalAccount_Desp := BankAcct2.Name;
                        END
                        ELSE
                            IF ("Bal. Account No." <> '') AND ("Bal. Account Type" = "Bal. Account Type"::Vendor) THEN BEGIN
                                CLEAR(Vendor2);
                                Vendor2.GET("Bal. Account No.");
                                BalAccount_Desp := Vendor2.Name;
                            END;
                        IF ("Account No." <> '') THEN BEGIN
                            CASE "Account Type" OF
                                "Account Type"::Vendor:
                                    BEGIN
                                        CLEAR(Vendor2);
                                        Vendor2.GET("Account No.");
                                        AccountName := Vendor2.Name;
                                        theAddress := Vendor2.Address;
                                        IF Vendor2."Address 2" <> '' THEN
                                            theAddress := theAddress + Vendor2."Address 2" + ', ';
                                        IF Vendor2.City <> '' THEN
                                            theAddress := theAddress + Vendor2.City + ', ';
                                        IF Vendor2.County <> '' THEN
                                            theAddress := theAddress + Vendor2.County + ' ';
                                        IF Vendor2."Post Code" <> '' THEN
                                            theAddress := theAddress + Vendor2."Post Code";
                                    END;
                                "Account Type"::Customer:
                                    BEGIN
                                        CLEAR(Customer2);
                                        Customer2.GET("Account No.");
                                        AccountName := Customer2.Name;
                                        theAddress := Customer2.Address;
                                        IF Customer2."Address 2" <> '' THEN
                                            theAddress := theAddress + Customer2."Address 2" + ', ';
                                        IF Customer2.City <> '' THEN
                                            theAddress := theAddress + Customer2.City + ', ';
                                        IF Customer2.County <> '' THEN
                                            theAddress := theAddress + Customer2.County + ' ';
                                        IF Customer2."Post Code" <> '' THEN
                                            theAddress := theAddress + Customer2."Post Code";
                                    END;
                            END;
                        END;

                        AccName := '';
                        BalAccName := '';

                        IF NOT EmptyLine THEN BEGIN
                            MakeRecurringTexts("Gen. Journal Line");

                            AmountError := FALSE;

                            IF ("Account No." = '') AND ("Bal. Account No." = '') THEN
                                AddError(STRSUBSTNO(Text001, FIELDCAPTION("Account No."), FIELDCAPTION("Bal. Account No.")))
                            ELSE
                                IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                                THEN
                                    TestFixedAssetFields("Gen. Journal Line");
                            CheckICDocument;
                            IF "Account No." <> '' THEN
                                CASE "Account Type" OF
                                    "Account Type"::"G/L Account":
                                        BEGIN
                                            IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                                               ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
                                            THEN BEGIN
                                                IF "Gen. Posting Type" = "Gen. Posting Type"::" " THEN
                                                    AddError(STRSUBSTNO(Text002, FIELDCAPTION("Gen. Posting Type")));
                                            END;
                                            IF ("Gen. Posting Type" <> "Gen. Posting Type"::" ") AND
                                               ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                                            THEN BEGIN
                                                IF "VAT Amount" + "VAT Base Amount" <> Amount THEN
                                                    AddError(
                                                      STRSUBSTNO(
                                                        Text003, FIELDCAPTION("VAT Amount"), FIELDCAPTION("VAT Base Amount"),
                                                        FIELDCAPTION(Amount)));
                                                IF "Currency Code" <> '' THEN
                                                    IF "VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)" THEN
                                                        AddError(
                                                          STRSUBSTNO(
                                                            Text003, FIELDCAPTION("VAT Amount (LCY)"),
                                                            FIELDCAPTION("VAT Base Amount (LCY)"), FIELDCAPTION("Amount (LCY)")));
                                            END;
                                        END;
                                    "Account Type"::Customer, "Account Type"::Vendor:
                                        BEGIN
                                            IF "Gen. Posting Type" <> "Gen. Posting Type"::" " THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text004,
                                                    FIELDCAPTION("Gen. Posting Type"), FIELDCAPTION("Account Type"), "Account Type"));

                                            IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                                               ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
                                            THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text005,
                                                    FIELDCAPTION("Gen. Bus. Posting Group"), FIELDCAPTION("Gen. Prod. Posting Group"),
                                                    FIELDCAPTION("VAT Bus. Posting Group"), FIELDCAPTION("VAT Prod. Posting Group"),
                                                    FIELDCAPTION("Account Type"), "Account Type"));

                                            IF "Document Type" <> "Document Type"::" " THEN BEGIN
                                                IF "Account Type" = "Account Type"::Customer THEN
                                                    CASE "Document Type" OF
                                                        "Document Type"::"Credit Memo":
                                                            WarningIfPositiveAmt("Gen. Journal Line");
                                                        "Document Type"::Payment:
                                                            IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") AND
                                                               ("Applies-to Doc. No." <> '')
                                                            THEN
                                                                WarningIfNegativeAmt("Gen. Journal Line")
                                                            ELSE
                                                                WarningIfPositiveAmt("Gen. Journal Line");
                                                        "Document Type"::Refund:
                                                            WarningIfNegativeAmt("Gen. Journal Line");
                                                        ELSE
                                                            WarningIfNegativeAmt("Gen. Journal Line");
                                                    END
                                                ELSE
                                                    CASE "Document Type" OF
                                                        "Document Type"::"Credit Memo":
                                                            WarningIfNegativeAmt("Gen. Journal Line");
                                                        "Document Type"::Payment:
                                                            IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") AND
                                                               ("Applies-to Doc. No." <> '')
                                                            THEN
                                                                WarningIfPositiveAmt("Gen. Journal Line")
                                                            ELSE
                                                                WarningIfNegativeAmt("Gen. Journal Line");
                                                        "Document Type"::Refund:
                                                            WarningIfPositiveAmt("Gen. Journal Line");
                                                        ELSE
                                                            WarningIfPositiveAmt("Gen. Journal Line");
                                                    END
                                            END;

                                            IF Amount * "Sales/Purch. (LCY)" < 0 THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text008,
                                                    FIELDCAPTION("Sales/Purch. (LCY)"), FIELDCAPTION(Amount)));
                                            IF "Job No." <> '' THEN
                                                AddError(STRSUBSTNO(Text009, FIELDCAPTION("Job No.")));
                                        END;
                                    "Account Type"::"Bank Account":
                                        BEGIN
                                            IF "Gen. Posting Type" <> "Gen. Posting Type"::" " THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text004,
                                                    FIELDCAPTION("Gen. Posting Type"), FIELDCAPTION("Account Type"), "Account Type"));

                                            IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                                               ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
                                            THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text005,
                                                    FIELDCAPTION("Gen. Bus. Posting Group"), FIELDCAPTION("Gen. Prod. Posting Group"),
                                                    FIELDCAPTION("VAT Bus. Posting Group"), FIELDCAPTION("VAT Prod. Posting Group"),
                                                    FIELDCAPTION("Account Type"), "Account Type"));

                                            IF "Job No." <> '' THEN
                                                AddError(STRSUBSTNO(Text009, FIELDCAPTION("Job No.")));
                                            IF (Amount < 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") THEN
                                                IF NOT "Check Printed" THEN
                                                    AddError(STRSUBSTNO(Text010,
                                                        FIELDCAPTION("Check Printed"), "Bank Payment Type"::"Electronic Payment"));
                                        END;
                                    "Account Type"::"Fixed Asset":
                                        TestFixedAsset("Gen. Journal Line");
                                END;

                            IF "Bal. Account No." <> '' THEN
                                CASE "Bal. Account Type" OF
                                    "Bal. Account Type"::"G/L Account":
                                        BEGIN
                                            IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                                               ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
                                            THEN BEGIN
                                                IF "Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::" " THEN
                                                    AddError(STRSUBSTNO(Text002, FIELDCAPTION("Bal. Gen. Posting Type")));
                                            END;
                                            IF ("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ") AND
                                               ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                                            THEN BEGIN
                                                IF "Bal. VAT Amount" + "Bal. VAT Base Amount" <> -Amount THEN
                                                    AddError(
                                                      STRSUBSTNO(
                                                        Text011, FIELDCAPTION("Bal. VAT Amount"), FIELDCAPTION("Bal. VAT Base Amount"),
                                                        FIELDCAPTION(Amount)));
                                                IF "Currency Code" <> '' THEN
                                                    IF "Bal. VAT Amount (LCY)" + "Bal. VAT Base Amount (LCY)" <> -"Amount (LCY)" THEN
                                                        AddError(
                                                          STRSUBSTNO(
                                                            Text011, FIELDCAPTION("Bal. VAT Amount (LCY)"),
                                                            FIELDCAPTION("Bal. VAT Base Amount (LCY)"), FIELDCAPTION("Amount (LCY)")));
                                            END;
                                        END;
                                    "Bal. Account Type"::Customer, "Bal. Account Type"::Vendor:
                                        BEGIN
                                            IF "Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" " THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text004,
                                                    FIELDCAPTION("Bal. Gen. Posting Type"), FIELDCAPTION("Bal. Account Type"), "Bal. Account Type"));

                                            IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                                               ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
                                            THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text005,
                                                    FIELDCAPTION("Bal. Gen. Bus. Posting Group"), FIELDCAPTION("Bal. Gen. Prod. Posting Group"),
                                                    FIELDCAPTION("Bal. VAT Bus. Posting Group"), FIELDCAPTION("Bal. VAT Prod. Posting Group"),
                                                    FIELDCAPTION("Bal. Account Type"), "Bal. Account Type"));

                                            IF "Document Type" <> "Document Type"::" " THEN BEGIN
                                                IF ("Bal. Account Type" = "Bal. Account Type"::Customer) =
                                                   ("Document Type" IN ["Document Type"::Payment, "Document Type"::"Credit Memo"])
                                                THEN
                                                    WarningIfNegativeAmt("Gen. Journal Line")
                                                ELSE
                                                    WarningIfPositiveAmt("Gen. Journal Line")
                                            END;
                                            IF Amount * "Sales/Purch. (LCY)" > 0 THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text012,
                                                    FIELDCAPTION("Sales/Purch. (LCY)"), FIELDCAPTION(Amount)));
                                            IF "Job No." <> '' THEN
                                                AddError(STRSUBSTNO(Text009, FIELDCAPTION("Job No.")));
                                        END;
                                    "Bal. Account Type"::"Bank Account":
                                        BEGIN
                                            IF "Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" " THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text004,
                                                    FIELDCAPTION("Bal. Gen. Posting Type"), FIELDCAPTION("Bal. Account Type"), "Bal. Account Type"));

                                            IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                                               ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
                                            THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text005,
                                                    FIELDCAPTION("Bal. Gen. Bus. Posting Group"), FIELDCAPTION("Bal. Gen. Prod. Posting Group"),
                                                    FIELDCAPTION("Bal. VAT Bus. Posting Group"), FIELDCAPTION("Bal. VAT Prod. Posting Group"),
                                                    FIELDCAPTION("Bal. Account Type"), "Bal. Account Type"));

                                            IF "Job No." <> '' THEN
                                                AddError(STRSUBSTNO(Text009, FIELDCAPTION("Job No.")));
                                            IF (Amount > 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") THEN
                                                IF NOT "Check Printed" THEN
                                                    AddError(STRSUBSTNO(Text010,
                                                        FIELDCAPTION("Check Printed"), "Bank Payment Type"::"Electronic Payment"));
                                        END;
                                    "Bal. Account Type"::"Fixed Asset":
                                        TestFixedAsset("Gen. Journal Line");
                                END;

                            IF ("Account No." <> '') AND
                               NOT "System-Created Entry" AND
                               ("Gen. Posting Type" = "Gen. Posting Type"::" ") AND
                               (Amount = 0) AND
                               NOT GenJnlTemplate.Recurring AND
                               NOT "Allow Zero-Amount Posting" AND
                               ("Account Type" <> "Account Type"::"Fixed Asset")
                            THEN
                                WarningIfZeroAmt("Gen. Journal Line");

                            CheckRecurringLine("Gen. Journal Line");
                            CheckAllocations("Gen. Journal Line");

                            IF "Posting Date" = 0D THEN
                                AddError(STRSUBSTNO(Text002, FIELDCAPTION("Posting Date")))
                            ELSE BEGIN
                                //closDate := CLOSINGDATE("Posting Date");
                                //normDate := NORMALDATE(closDate);
                                IF "Posting Date" <> NORMALDATE("Posting Date") THEN
                                    IF ("Account Type" <> "Account Type"::"G/L Account") OR
                                       ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
                                    THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text013, FIELDCAPTION("Posting Date")));

                                IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                                    IF USERID <> '' THEN
                                        IF UserSetup.GET(USERID) THEN BEGIN
                                            AllowPostingFrom := UserSetup."Allow Posting From";
                                            AllowPostingTo := UserSetup."Allow Posting To";
                                        END;
                                    IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                                        AllowPostingFrom := GLSetup."Allow Posting From";
                                        AllowPostingTo := GLSetup."Allow Posting To";
                                    END;
                                    IF AllowPostingTo = 0D THEN
                                        AllowPostingTo := 99991231D;
                                END;
                                IF ("Posting Date" < AllowPostingFrom) OR ("Posting Date" > AllowPostingTo) THEN
                                    AddError(
                                      STRSUBSTNO(
                                        Text014, FORMAT("Posting Date")));

                                IF "Gen. Journal Batch"."No. Series" <> '' THEN BEGIN
                                    IF NoSeries."Date Order" AND ("Posting Date" < LastEntrdDate) THEN
                                        AddError(Text015);
                                    LastEntrdDate := "Posting Date";
                                END;
                            END;

                            IF "Document Date" <> 0D THEN BEGIN
                                //closDate := CLOSINGDATE("Document Date");
                                //normDate := NORMALDATE(closDate);
                                IF ("Document Date" <> NORMALDATE("Document Date")) AND
                                   (("Account Type" <> "Account Type"::"G/L Account") OR
                                    ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account"))
                                THEN
                                    AddError(
                                      STRSUBSTNO(
                                        Text013, FIELDCAPTION("Document Date")));

                            END;
                            IF "Document No." = '' THEN
                                AddError(STRSUBSTNO(Text002, FIELDCAPTION("Document No.")))
                            ELSE
                                IF "Gen. Journal Batch"."No. Series" <> '' THEN BEGIN
                                    IF (LastEntrdDocNo <> '') AND
                                       ("Document No." <> LastEntrdDocNo) AND
                                       ("Document No." <> INCSTR(LastEntrdDocNo))
                                    THEN
                                        AddError(Text016);
                                    LastEntrdDocNo := "Document No.";
                                END;

                            IF ("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Fixed Asset"]) AND
                               ("Bal. Account Type" IN ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor, "Bal. Account Type"::"Fixed Asset"])
                            THEN
                                AddError(
                                  STRSUBSTNO(
                                    Text017,
                                    FIELDCAPTION("Account Type"), FIELDCAPTION("Bal. Account Type")));

                            IF Amount * "Amount (LCY)" < 0 THEN
                                AddError(
                                  STRSUBSTNO(
                                    Text008, FIELDCAPTION("Amount (LCY)"), FIELDCAPTION(Amount)));

                            IF ("Account Type" = "Account Type"::"G/L Account") AND
                               ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")
                            THEN
                                IF "Applies-to Doc. No." <> '' THEN
                                    AddError(STRSUBSTNO(Text009, FIELDCAPTION("Applies-to Doc. No.")));

                            IF (("Account Type" = "Account Type"::"G/L Account") AND
                                ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
                               ("Document Type" <> "Document Type"::Invoice)
                            THEN
                                IF PaymentTerms.GET("Payment Terms Code") THEN BEGIN
                                    IF ("Document Type" = "Document Type"::"Credit Memo") AND
                                       (NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                                    THEN BEGIN
                                        IF "Pmt. Discount Date" <> 0D THEN
                                            AddError(STRSUBSTNO(Text009, FIELDCAPTION("Pmt. Discount Date")));
                                        IF "Payment Discount %" <> 0 THEN
                                            AddError(STRSUBSTNO(Text018, FIELDCAPTION("Payment Discount %")));
                                    END;
                                END ELSE BEGIN
                                    IF "Pmt. Discount Date" <> 0D THEN
                                        AddError(STRSUBSTNO(Text009, FIELDCAPTION("Pmt. Discount Date")));
                                    IF "Payment Discount %" <> 0 THEN
                                        AddError(STRSUBSTNO(Text018, FIELDCAPTION("Payment Discount %")));
                                END;

                            IF (("Account Type" = "Account Type"::"G/L Account") AND
                                ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
                               ("Applies-to Doc. No." <> '')
                            THEN
                                IF "Applies-to ID" <> '' THEN
                                    AddError(STRSUBSTNO(Text009, FIELDCAPTION("Applies-to ID")));

                            IF ("Account Type" <> "Account Type"::"Bank Account") AND
                               ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
                            THEN
                                IF GenJnlLine2."Bank Payment Type" <> GenJnlLine2."Bank Payment Type"::" " THEN
                                    AddError(STRSUBSTNO(Text009, FIELDCAPTION("Bank Payment Type")));

                            IF ("Account No." <> '') AND ("Bal. Account No." <> '') THEN BEGIN
                                PurchPostingType := FALSE;
                                SalesPostingType := FALSE;
                            END;
                            IF "Account No." <> '' THEN
                                CASE "Account Type" OF
                                    "Account Type"::"G/L Account":
                                        CheckGLAcc("Gen. Journal Line", AccName);
                                    "Account Type"::Customer:
                                        CheckCust("Gen. Journal Line", AccName);
                                    "Account Type"::Vendor:
                                        CheckVend("Gen. Journal Line", AccName);
                                    "Account Type"::"Bank Account":
                                        CheckBankAcc("Gen. Journal Line", AccName);
                                    "Account Type"::"Fixed Asset":
                                        CheckFixedAsset("Gen. Journal Line", AccName);
                                    "Account Type"::"IC Partner":
                                        CheckICPartner("Gen. Journal Line", AccName);
                                END;
                            IF "Bal. Account No." <> '' THEN BEGIN
                                ExchAccGLJnlLine.RUN("Gen. Journal Line");
                                CASE "Account Type" OF
                                    "Account Type"::"G/L Account":
                                        CheckGLAcc("Gen. Journal Line", BalAccName);
                                    "Account Type"::Customer:
                                        CheckCust("Gen. Journal Line", BalAccName);
                                    "Account Type"::Vendor:
                                        CheckVend("Gen. Journal Line", BalAccName);
                                    "Account Type"::"Bank Account":
                                        CheckBankAcc("Gen. Journal Line", BalAccName);
                                    "Account Type"::"Fixed Asset":
                                        CheckFixedAsset("Gen. Journal Line", BalAccName);
                                    "Account Type"::"IC Partner":
                                        CheckICPartner("Gen. Journal Line", AccName);
                                END;
                                ExchAccGLJnlLine.RUN("Gen. Journal Line");
                            END;

                            IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                                AddError(DimMgt.GetDimCombErr);

                            TableID[1] := DimMgt.TypeToTableID1("Account Type".AsInteger());
                            No[1] := "Account No.";
                            TableID[2] := DimMgt.TypeToTableID1("Bal. Account Type".AsInteger());
                            No[2] := "Bal. Account No.";
                            TableID[3] := DATABASE::Job;
                            No[3] := "Job No.";
                            TableID[4] := DATABASE::"Salesperson/Purchaser";
                            No[4] := "Salespers./Purch. Code";
                            TableID[5] := DATABASE::Campaign;
                            No[5] := "Campaign No.";
                            IF NOT DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") THEN
                                AddError(DimMgt.GetDimValuePostingErr);
                            IF "Bank Payment Type" = "Bank Payment Type"::"Electronic Payment" THEN BEGIN
                                IF NOT "Check Transmitted" THEN
                                    AddError(STRSUBSTNO(Text010,
                                        FIELDCAPTION("Check Transmitted"), "Bank Payment Type"::"Electronic Payment"));
                                IF NOT "Check Exported" THEN
                                    AddError(STRSUBSTNO(Text010,
                                        FIELDCAPTION("Check Exported"), "Bank Payment Type"::"Electronic Payment"));
                            END;
                        END;

                        CheckBalance;
                        TotalAppliedVendorEntryCounts := 0;

                        RemainingAmountToApply := -Amount;
                        GetCurrencyRecord(Currency, "Currency Code");

                        //CS1.03 BEGIN Vendir Ledger Entry
                        GrossAmount := 0;
                        IF ("Applies-to ID" <> '') OR ("Applies-to Doc. No." <> '') THEN BEGIN
                            CASE "Account Type" OF
                                "Account Type"::Vendor:
                                    BEGIN
                                        tempVLE.DELETEALL;
                                        OldVendLedgEntry.RESET;
                                        //OldVendLedgEntry.SETCURRENTKEY("Due Date","External Document No.");
                                        OldVendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                                        OldVendLedgEntry.SETRANGE("Vendor No.", "Account No.");
                                        IF "Applies-to ID" <> '' THEN BEGIN
                                            OldVendLedgEntry.SETRANGE(Open, TRUE);
                                            OldVendLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                                        END;
                                        IF "Applies-to Doc. No." <> '' THEN BEGIN
                                            OldVendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                                            OldVendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                                        END;
                                        IF OldVendLedgEntry.FIND('-') THEN BEGIN
                                            REPEAT
                                                tempVLE.INIT;
                                                tempVLE.TRANSFERFIELDS(OldVendLedgEntry);
                                                tempVLE.INSERT;
                                                GrossAmount := GrossAmount - OldVendLedgEntry."Amount to Apply";
                                            UNTIL OldVendLedgEntry.NEXT = 0;
                                        END;
                                    END;
                                "Account Type"::Customer:
                                    BEGIN
                                        tempCLE.DELETEALL;
                                        OldCustLedgEntry.RESET;
                                        OldCustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                                        OldCustLedgEntry.SETRANGE("Customer No.", "Account No.");
                                        IF "Applies-to ID" <> '' THEN BEGIN
                                            OldCustLedgEntry.SETRANGE(Open, TRUE);
                                            OldCustLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                                        END;
                                        IF "Applies-to Doc. No." <> '' THEN BEGIN
                                            OldCustLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                                            OldCustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                                        END;
                                        IF OldCustLedgEntry.FIND('-') THEN BEGIN
                                            REPEAT
                                                tempCLE.INIT;
                                                tempCLE.TRANSFERFIELDS(OldCustLedgEntry);
                                                tempCLE.INSERT;
                                                GrossAmount := GrossAmount - OldCustLedgEntry."Amount to Apply";
                                            UNTIL OldCustLedgEntry.NEXT = 0;
                                        END;
                                    END;
                            END;
                        END;

                        isDisplayNone := 0;
                        IF (tempVLE.COUNT = 0) AND isPaymentJournal OR (tempCLE.COUNT = 0) AND NOT isPaymentJournal THEN
                            isDisplayNone := 1;
                        IF BalAccountNo <> "Bal. Account No." THEN BEGIN
                            subAmount := 0;
                            BalAccountNo := "Bal. Account No.";
                        END;
                        sumAmount := sumAmount + "Amount (LCY)";
                        sumBalance := sumBalance + "Balance (LCY)";
                        subAmount := subAmount + "Amount (LCY)";
                        //CS1.03 END
                    end;

                    trigger OnPreDataItem()
                    begin
                        GenJnlTemplate.GET("Gen. Journal Batch"."Journal Template Name");
                        IF GenJnlTemplate.Recurring THEN BEGIN
                            IF GETFILTER("Posting Date") <> '' THEN
                                AddError(
                                  STRSUBSTNO(
                                    Text000,
                                    FIELDCAPTION("Posting Date")));
                            SETRANGE("Posting Date", 0D, WORKDATE);
                            IF GETFILTER("Expiration Date") <> '' THEN
                                AddError(
                                  STRSUBSTNO(
                                    Text000,
                                    FIELDCAPTION("Expiration Date")));
                            SETFILTER("Expiration Date", '%1 | %2..', 0D, WORKDATE);
                        END;

                        IF "Gen. Journal Batch"."No. Series" <> '' THEN BEGIN
                            NoSeries.GET("Gen. Journal Batch"."No. Series");
                            LastEntrdDocNo := '';
                            LastEntrdDate := 0D;
                        END;

                        CurrentCustomerVendors := 0;
                        VATEntryCreated := FALSE;

                        GenJnlLine2.RESET;
                        GenJnlLine2.COPYFILTERS("Gen. Journal Line");

                        GLAccNetChange.DELETEALL;
                        //CurrReport.CREATETOTALS("Amount (LCY)", "Balance (LCY)");
                    end;
                }
                dataitem(ReconcileLoop; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(GLAccNetChange_No; GLAccNetChange."No.")
                    {
                    }
                    column(GLAccNetChange_Name; GLAccNetChange.Name)
                    {
                    }
                    column(GLAccNetChange__Net_Change_in_Jnl; GLAccNetChange."Net Change in Jnl.")
                    {
                    }
                    column(GLAccNetChange__Balance_after_Posting; GLAccNetChange."Balance after Posting")
                    {
                    }
                    column(ReconcileLoop_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Number = 1 THEN
                            GLAccNetChange.FIND('-')
                        ELSE
                            GLAccNetChange.NEXT;
                    end;

                    trigger OnPostDataItem()
                    begin
                        GLAccNetChange.DELETEALL;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE(Number, 1, GLAccNetChange.COUNT);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                //CurrReport.PAGENO := 1;
                isPaymentJournal := FALSE;
                IF GenJnlTemplate.GET("Gen. Journal Batch"."Journal Template Name") THEN BEGIN
                    isPaymentJournal := GenJnlTemplate.Type = GenJnlTemplate.Type::Payments;
                END;
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.GET;
                SalesSetup.GET;
                PurchSetup.GET;
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
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GenJnlLineFilter := "Gen. Journal Line".GETFILTERS;
        CompanyInformation.GET;
        sumAmount := 0;
        sumBalance := 0;
        BalAccountNo := '';
    end;

    var
        Text000: Label '%1 cannot be filtered when you post recurring journals.';
        Text001: Label '%1 or %2 must be specified.';
        Text002: Label '%1 must be specified.';
        Text003: Label '%1 + %2 must be %3.';
        Text004: Label '%1 must be " " when %2 is %3.';
        Text005: Label '%1, %2, %3 or %4 must not be completed when %5 is %6.';
        Text006: Label '%1 must be negative.';
        Text007: Label '%1 must be positive.';
        Text008: Label '%1 must have the same sign as %2.';
        Text009: Label '%1 cannot be specified.';
        Text010: Label '%1 must be Yes for a(n) %2.';
        Text011: Label '%1 + %2 must be -%3.';
        Text012: Label '%1 must have a different sign than %2.';
        Text013: Label '%1 must only be a closing date for G/L entries.';
        Text014: Label '%1 is not within your allowed range of posting dates.';
        Text015: Label 'The lines are not listed according to Posting Date because they were not entered in that order.';
        Text016: Label 'There is a gap in the number series.';
        Text017: Label '%1 or %2 must be G/L Account or Bank Account.';
        Text018: Label '%1 must be 0.';
        Text019: Label '%1 cannot be specified when using recurring journals.';
        Text020: Label '%1 must not be %2 when %3 = %4.';
        Text021: Label 'Allocations can only be used with recurring journals.';
        Text022: Label 'Please specify %1 in the %2 allocation lines.';
        Text023: Label '<Month Text>';
        Text024: Label '%1 %2 posted on %3, must be separated by an empty line';
        Text025: Label '%1 %2 is out of balance by %3.';
        Text026: Label 'The reversing entries for %1 %2 are out of balance by %3.';
        Text027: Label 'As of %1, the lines are out of balance by %2.';
        Text028: Label 'As of %1, the reversing entries are out of balance by %2.';
        Text029: Label 'The total of the lines is out of balance by %1.';
        Text030: Label 'The total of the reversing entries is out of balance by %1.';
        Text031: Label '%1 %2 does not exist.';
        Text032: Label '%1 must be %2 for %3 %4.';
        Text036: Label '%1 %2 %3 does not exist.';
        Text037: Label '%1 must be %2.';
        Text038: Label 'The currency %1 cannot be found. Please check the currency table.';
        Text039: Label 'Sales %1 %2 already exists.';
        Text040: Label 'Purchase %1 %2 already exists.';
        Text041: Label '%1 must be entered.';
        Text042: Label '%1 must not be filled when %2 is different in %3 and %4.';
        Text043: Label '%1 %2 must not have %3 = %4.';
        Text044: Label '%1 must not be specified in fixed asset journal lines.';
        Text045: Label '%1 must be specified in fixed asset journal lines.';
        Text046: Label '%1 must be different than %2.';
        Text047: Label '%1 and %2 must not both be %3.';
        Text048: Label '%1  must not be specified when %2 = %3.';
        Text049: Label '%1 must not be specified when %2 = %3.';
        Text050: Label 'must not be specified together with %1 = %2.';
        Text051: Label '%1 must be identical to %2.';
        Text052: Label '%1 cannot be a closing date.';
        Text053: Label '%1 is not within your range of allowed posting dates.';
        Text054: Label 'Insurance integration is not activated for %1 %2.';
        Text055: Label 'must not be specified when %1 is specified.';
        Text056: Label 'When G/L integration is not activated, %1 must not be posted in the general journal.';
        Text057: Label 'When G/L integration is not activated, %1 must not be specified in the general journal.';
        Text058: Label '%1 must not be specified.';
        Text059: Label 'The combination of Customer and Gen. Posting Type Purchase is not allowed.';
        Text060: Label 'The combination of Vendor and Gen. Posting Type Sales is not allowed.';
        Text061: Label 'The Balance and Reversing Balance recurring methods can be used only with Allocations.';
        Text062: Label '%1 must not be 0.';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        UserSetup: Record "User Setup";
        AccountingPeriod: Record "Accounting Period";
        GLAcc: Record "G/L Account";
        Currency: Record Currency;
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAccPostingGr: Record "Bank Account Posting Group";
        BankAcc: Record "Bank Account";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine2: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        GenJnlAlloc: Record "Gen. Jnl. Allocation";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        OldVendLedgEntry: Record "Vendor Ledger Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        NoSeries: Record "No. Series";
        FA: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FASetup: Record "FA Setup";
        GLAccNetChange: Record "G/L Account Net Change" temporary;
        CompanyInformation: Record "Company Information";
        DimSetEntry: Record "Dimension Set Entry";
        ExchAccGLJnlLine: Codeunit "Exchange Acc. G/L Journal Line";
        GenJnlLineFilter: Text;
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        AllowFAPostingFrom: Date;
        AllowFAPostingTo: Date;
        LastDate: Date;
        //LastDocType: Option Document,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
        LastDocType: Enum "Gen. Journal Document Type";
        LastDocNo: Code[20];
        LastEntrdDocNo: Code[20];
        LastEntrdDate: Date;
        DocBalance: Decimal;
        DocBalanceReverse: Decimal;
        DateBalance: Decimal;
        DateBalanceReverse: Decimal;
        TotalBalance: Decimal;
        TotalBalanceReverse: Decimal;
        AccName: Text[50];
        LastLineNo: Integer;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        AmountError: Boolean;
        ErrorCounter: Integer;
        ErrorText: array[50] of Text[250];
        TempErrorText: Text[250];
        BalAccName: Text[50];
        CurrentCustomerVendors: Integer;
        VATEntryCreated: Boolean;
        CustPosting: Boolean;
        VendPosting: Boolean;
        SalesPostingType: Boolean;
        PurchPostingType: Boolean;
        DimText: Text[120];
        OldDimText: Text[120];
        Continue: Boolean;
        Text063: Label 'Document,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
        Text064: Label '%1 %2 is already used in line %3 (%4 %5).';
        Text065: Label '%1 must not be blocked with type %2 when %3 is %4';
        CurrentICPartner: Code[20];
        Text066: Label 'You cannot enter G/L Account or Bank Account in both %1 and %2.';
        Text067: Label '%1 %2 is linked to %3 %4.';
        Text069: Label '%1 must not be specified when %2 is %3.';
        Text070: Label '%1 must not be specified when the document is not an intercompany transaction.';
        USText001: Label 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.';
        ReportTitle: Label 'Journal  Test - Applied Entries';
        PAGENO_Caption: Label 'Page';
        Journal_Template_Name_Caption: Label 'Journal Template Name:';
        Journal_Batch_Caption: Label 'Journal Batch:';
        Bank_Payment_Type_Caption: Label 'Bank Payment Type:';
        Bal_Account_Number_Caption: Label 'Bal. Account Number / Description:';
        TB_Posting_Date_Caption: Label 'Posting Date';
        TB_Description_Caption: Label 'Description';
        TB_Pay_To_Vendor_Caption: Label 'Pay To Vendor';
        TB_Vendor_Name_Caption: Label 'Vendor Name';
        TB_Doc_Date_Caption: Label 'Doc.Date';
        TB_Buy_From_Vendor_Caption: Label 'Buy From Vendor';
        TB_External_Document_No_Caption: Label 'External Doc. No.';
        TB_Due_Date_Caption: Label 'Due Date';
        TB_Amount_Caption: Label 'Gross';
        TB_Amount_To_Apply_Caption: Label 'Amount to Apply';
        TB_Document_No_Caption: Label 'Document No.';
        TB_Amount_USD_Caption: Label 'Net (USD)';
        TB_Amount_To_Apply_USD_Caption: Label 'Amount to Apply (USD)';
        AccountName: Text[250];
        BalAccount_Desp: Text[250];
        BankAcct2: Record "Bank Account";
        Vendor2: Record Vendor;
        Customer2: Record Customer;
        theAddress: Text[250];
        AmountToApply: Decimal;
        AmountToApply_LCY: Decimal;
        RemainingAmountToApply: Decimal;
        AmountPaid: Decimal;
        AmountDue: Decimal;
        AmountDiscounted: Decimal;
        AmountPmtTolerance: Decimal;
        AmountPmtDiscTolerance: Decimal;
        AmountApplied: Decimal;
        TotalAmountApplied: Decimal;
        TotalAppliedVendorEntryCounts: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        tempVLE: Record "Vendor Ledger Entry" temporary;
        TB_GLE_Account_No_Caption: Label 'G/L Account No.';
        TB_GLE_Dept_Code_Caption: Label 'Dept Code';
        TB_GLE_KG_Caption: Label 'KG -';
        TB_GLE_Desctiption_Caption: Label 'Description';
        TB_GLE_Amount_Caption: Label 'G/L Amount ($)';
        tempCLE: Record "Cust. Ledger Entry" temporary;
        normDate: Date;
        closDate: Date;
        ErrorText_Number_Caption: Label 'Warning!';
        Dimensions_Caption: Label 'Dimensions';
        sumAmount: Decimal;
        sumBalance: Decimal;
        isDisplayNone: Integer;
        subAmount: Decimal;
        BalAccountNo: Code[20];
        GLAcctName: Text[30];
        GLAcct2: Record "G/L Account";
        NetAmount: Decimal;
        GrossAmount: Decimal;
        isPaymentJournal: Boolean;
        ExtDocNo: Code[35];
        mEntryNo: Integer;
        mDocDate: Date;
        mNo: Code[20];
        mDueDate: Date;
        mDescription: Text[62];
        mCC: Code[10];
        mDocNo: Code[20];

    local procedure CheckRecurringLine(GenJnlLine2: Record "Gen. Journal Line")
    begin
        IF GenJnlTemplate.Recurring THEN BEGIN
            IF GenJnlLine2."Recurring Method" = GenJnlLine2."Recurring Method"::" " THEN
                AddError(STRSUBSTNO(Text002, GenJnlLine2.FIELDCAPTION("Recurring Method")));
            IF FORMAT(GenJnlLine2."Recurring Frequency") = '' THEN
                AddError(STRSUBSTNO(Text002, GenJnlLine2.FIELDCAPTION("Recurring Frequency")));
            IF GenJnlLine2."Bal. Account No." <> '' THEN
                AddError(
                  STRSUBSTNO(
                    Text019,
                    GenJnlLine2.FIELDCAPTION("Bal. Account No.")));
            CASE GenJnlLine2."Recurring Method" OF
                GenJnlLine2."Recurring Method"::"V  Variable", GenJnlLine2."Recurring Method"::"RV Reversing Variable",
              GenJnlLine2."Recurring Method"::"F  Fixed", GenJnlLine2."Recurring Method"::"RF Reversing Fixed":
                    WarningIfZeroAmt("Gen. Journal Line");
                GenJnlLine2."Recurring Method"::"B  Balance", GenJnlLine2."Recurring Method"::"RB Reversing Balance":
                    WarningIfNonZeroAmt("Gen. Journal Line");
            END;
            IF GenJnlLine2."Recurring Method".AsInteger() > 2 THEN BEGIN
                IF GenJnlLine2."Account Type" = GenJnlLine2."Account Type"::"Fixed Asset" THEN
                    AddError(
                      STRSUBSTNO(
                        Text020,
                        GenJnlLine2.FIELDCAPTION("Recurring Method"), GenJnlLine2."Recurring Method",
                        GenJnlLine2.FIELDCAPTION("Account Type"), GenJnlLine2."Account Type"));
                IF GenJnlLine2."Bal. Account Type" = GenJnlLine2."Bal. Account Type"::"Fixed Asset" THEN
                    AddError(
                      STRSUBSTNO(
                        Text020,
                        GenJnlLine2.FIELDCAPTION("Recurring Method"), GenJnlLine2."Recurring Method",
                        GenJnlLine2.FIELDCAPTION("Bal. Account Type"), GenJnlLine2."Bal. Account Type"));
            END;
        END ELSE BEGIN
            IF GenJnlLine2."Recurring Method" <> GenJnlLine2."Recurring Method"::" " THEN
                AddError(STRSUBSTNO(Text009, GenJnlLine2.FIELDCAPTION("Recurring Method")));
            IF FORMAT(GenJnlLine2."Recurring Frequency") <> '' THEN
                AddError(STRSUBSTNO(Text009, GenJnlLine2.FIELDCAPTION("Recurring Frequency")));
        END;
    end;

    local procedure CheckAllocations(GenJnlLine2: Record "Gen. Journal Line")
    begin
        IF GenJnlLine2."Recurring Method" IN
   [GenJnlLine2."Recurring Method"::"B  Balance",
    GenJnlLine2."Recurring Method"::"RB Reversing Balance"]
THEN BEGIN
            GenJnlAlloc.RESET;
            GenJnlAlloc.SETRANGE("Journal Template Name", GenJnlLine2."Journal Template Name");
            GenJnlAlloc.SETRANGE("Journal Batch Name", GenJnlLine2."Journal Batch Name");
            GenJnlAlloc.SETRANGE("Journal Line No.", GenJnlLine2."Line No.");
            IF NOT GenJnlAlloc.FINDFIRST THEN
                AddError(Text061);
        END;

        GenJnlAlloc.RESET;
        GenJnlAlloc.SETRANGE("Journal Template Name", GenJnlLine2."Journal Template Name");
        GenJnlAlloc.SETRANGE("Journal Batch Name", GenJnlLine2."Journal Batch Name");
        GenJnlAlloc.SETRANGE("Journal Line No.", GenJnlLine2."Line No.");
        GenJnlAlloc.SETFILTER(Amount, '<>0');
        IF GenJnlAlloc.FINDFIRST THEN
            IF NOT GenJnlTemplate.Recurring THEN
                AddError(Text021)
            ELSE BEGIN
                GenJnlAlloc.SETRANGE("Account No.", '');
                IF GenJnlAlloc.FINDFIRST THEN
                    AddError(
                      STRSUBSTNO(
                        Text022,
                        GenJnlAlloc.FIELDCAPTION("Account No."), GenJnlAlloc.COUNT));
            END;
    end;

    local procedure MakeRecurringTexts(var GenJnlLine2: Record "Gen. Journal Line")
    begin
        IF (GenJnlLine2."Posting Date" <> 0D) AND (GenJnlLine2."Account No." <> '') AND (GenJnlLine2."Recurring Method" <> GenJnlLine2."Recurring Method"::" ") THEN BEGIN
            Day := DATE2DMY(GenJnlLine2."Posting Date", 1);
            Week := DATE2DWY(GenJnlLine2."Posting Date", 2);
            Month := DATE2DMY(GenJnlLine2."Posting Date", 2);
            MonthText := FORMAT(GenJnlLine2."Posting Date", 0, Text023);
            AccountingPeriod.SETRANGE("Starting Date", 0D, GenJnlLine2."Posting Date");
            IF NOT AccountingPeriod.FINDLAST THEN
                AccountingPeriod.Name := '';
            GenJnlLine2."Document No." :=
              DELCHR(
                PADSTR(
                  STRSUBSTNO(GenJnlLine2."Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MAXSTRLEN(GenJnlLine2."Document No.")),
                '>');
            GenJnlLine2.Description :=
              DELCHR(
                PADSTR(
                  STRSUBSTNO(GenJnlLine2.Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MAXSTRLEN(GenJnlLine2.Description)),
                '>');
        END;
    end;

    local procedure CheckBalance()
    var
        GenJnlLine: Record "Gen. Journal Line";
        NextGenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine := "Gen. Journal Line";
        LastLineNo := "Gen. Journal Line"."Line No.";
        IF "Gen. Journal Line".NEXT = 0 THEN;
        NextGenJnlLine := "Gen. Journal Line";
        MakeRecurringTexts(NextGenJnlLine);
        "Gen. Journal Line" := GenJnlLine;
        IF NOT GenJnlLine.EmptyLine THEN BEGIN
            DocBalance := DocBalance + GenJnlLine."Balance (LCY)";
            DateBalance := DateBalance + GenJnlLine."Balance (LCY)";
            TotalBalance := TotalBalance + GenJnlLine."Balance (LCY)";
            IF GenJnlLine."Recurring Method".AsInteger() >= 4 THEN BEGIN
                DocBalanceReverse := DocBalanceReverse + GenJnlLine."Balance (LCY)";
                DateBalanceReverse := DateBalanceReverse + GenJnlLine."Balance (LCY)";
                TotalBalanceReverse := TotalBalanceReverse + GenJnlLine."Balance (LCY)";
            END;
            LastDocType := GenJnlLine."Document Type";
            LastDocNo := GenJnlLine."Document No.";
            LastDate := GenJnlLine."Posting Date";
            IF TotalBalance = 0 THEN BEGIN
                CurrentCustomerVendors := 0;
                VATEntryCreated := FALSE;
            END;
            IF GenJnlTemplate."Force Doc. Balance" THEN BEGIN
                VATEntryCreated :=
                  VATEntryCreated OR
                  ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") AND (GenJnlLine."Account No." <> '') AND
                   (GenJnlLine."Gen. Posting Type" IN [GenJnlLine."Gen. Posting Type"::Purchase, GenJnlLine."Gen. Posting Type"::Sale])) OR
                  ((GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"G/L Account") AND (GenJnlLine."Bal. Account No." <> '') AND
                   (GenJnlLine."Bal. Gen. Posting Type" IN [GenJnlLine."Bal. Gen. Posting Type"::Purchase, GenJnlLine."Bal. Gen. Posting Type"::Sale]));
                IF ((GenJnlLine."Account Type" IN [GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor]) AND
                    (GenJnlLine."Account No." <> '')) OR
                   ((GenJnlLine."Bal. Account Type" IN [GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor]) AND
                    (GenJnlLine."Bal. Account No." <> ''))
                THEN
                    CurrentCustomerVendors := CurrentCustomerVendors + 1;
                IF (CurrentCustomerVendors > 1) AND VATEntryCreated THEN
                    AddError(
                      STRSUBSTNO(
                        Text024,
                        GenJnlLine."Document Type", GenJnlLine."Document No.", GenJnlLine."Posting Date"));
            END;
        END;

        IF (LastDate <> 0D) AND (LastDocNo <> '') AND
   ((NextGenJnlLine."Posting Date" <> LastDate) OR
    (NextGenJnlLine."Document Type" <> LastDocType) OR
    (NextGenJnlLine."Document No." <> LastDocNo) OR
    (NextGenJnlLine."Line No." = LastLineNo))
THEN BEGIN
            IF GenJnlTemplate."Force Doc. Balance" THEN BEGIN
                CASE TRUE OF
                    DocBalance <> 0:
                        AddError(
                          STRSUBSTNO(
                            Text025,
                            SELECTSTR(LastDocType.AsInteger() + 1, Text063), LastDocNo, DocBalance));
                    DocBalanceReverse <> 0:
                        AddError(
                          STRSUBSTNO(
                            Text026,
                            SELECTSTR(LastDocType.AsInteger() + 1, Text063), LastDocNo, DocBalanceReverse));
                END;
                DocBalance := 0;
                DocBalanceReverse := 0;
            END;
            IF (NextGenJnlLine."Posting Date" <> LastDate) OR
               (NextGenJnlLine."Document Type" <> LastDocType) OR (NextGenJnlLine."Document No." <> LastDocNo)
            THEN BEGIN
                CurrentCustomerVendors := 0;
                VATEntryCreated := FALSE;
                CustPosting := FALSE;
                VendPosting := FALSE;
                SalesPostingType := FALSE;
                PurchPostingType := FALSE;
            END;
        END;

        IF (LastDate <> 0D) AND ((NextGenJnlLine."Posting Date" <> LastDate) OR (NextGenJnlLine."Line No." = LastLineNo)) THEN BEGIN
            CASE TRUE OF
                DateBalance <> 0:
                    AddError(
                      STRSUBSTNO(
                        Text027,
                        LastDate, DateBalance));
                DateBalanceReverse <> 0:
                    AddError(
                      STRSUBSTNO(
                        Text028,
                        LastDate, DateBalanceReverse));
            END;
            DocBalance := 0;
            DocBalanceReverse := 0;
            DateBalance := 0;
            DateBalanceReverse := 0;
        END;

        IF NextGenJnlLine."Line No." = LastLineNo THEN BEGIN
            CASE TRUE OF
                TotalBalance <> 0:
                    AddError(
                      STRSUBSTNO(
                        Text029,
                        TotalBalance));
                TotalBalanceReverse <> 0:
                    AddError(
                      STRSUBSTNO(
                        Text030,
                        TotalBalanceReverse));
            END;
            DocBalance := 0;
            DocBalanceReverse := 0;
            DateBalance := 0;
            DateBalanceReverse := 0;
            TotalBalance := 0;
            TotalBalanceReverse := 0;
            LastDate := 0D;
            LastDocType := LastDocType::" ";
            LastDocNo := '';
        END;
    end;

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;

    local procedure ReconcileGLAccNo(GLAccNo: Code[20]; ReconcileAmount: Decimal)
    begin
        IF NOT GLAccNetChange.GET(GLAccNo) THEN BEGIN
            GLAcc.GET(GLAccNo);
            GLAcc.CALCFIELDS("Balance at Date");
            GLAccNetChange.INIT;
            GLAccNetChange."No." := GLAcc."No.";
            GLAccNetChange.Name := GLAcc.Name;
            GLAccNetChange."Balance after Posting" := GLAcc."Balance at Date";
            GLAccNetChange.INSERT;
        END;
        GLAccNetChange."Net Change in Jnl." := GLAccNetChange."Net Change in Jnl." + ReconcileAmount;
        GLAccNetChange."Balance after Posting" := GLAccNetChange."Balance after Posting" + ReconcileAmount;
        GLAccNetChange.MODIFY;
    end;

    local procedure CheckGLAcc(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[50])
    begin
        IF NOT GLAcc.GET(GenJnlLine."Account No.") THEN
            AddError(
              STRSUBSTNO(
                Text031,
                GLAcc.TABLECAPTION, GenJnlLine."Account No."))
        ELSE BEGIN
            AccName := GLAcc.Name;

            IF GLAcc.Blocked THEN
                AddError(
                  STRSUBSTNO(
                    Text032,
                    GLAcc.FIELDCAPTION(Blocked), FALSE, GLAcc.TABLECAPTION, GenJnlLine."Account No."));
            IF GLAcc."Account Type" <> GLAcc."Account Type"::Posting THEN BEGIN
                GLAcc."Account Type" := GLAcc."Account Type"::Posting;
                AddError(
                  STRSUBSTNO(
                    Text032,
                    GLAcc.FIELDCAPTION("Account Type"), GLAcc."Account Type", GLAcc.TABLECAPTION, GenJnlLine."Account No."));
            END;
            IF NOT GenJnlLine."System-Created Entry" THEN BEGIN
                //closDate := CLOSINGDATE("Posting Date");
                //normDate := NORMALDATE(closDate);
                IF GenJnlLine."Posting Date" = NORMALDATE(GenJnlLine."Posting Date") THEN
                    IF NOT GLAcc."Direct Posting" THEN
                        AddError(
                          STRSUBSTNO(
                            Text032,
                            GLAcc.FIELDCAPTION("Direct Posting"), TRUE, GLAcc.TABLECAPTION, GenJnlLine."Account No."));
            END;
            IF GenJnlLine."Gen. Posting Type" <> GenJnlLine."Gen. Posting Type"::" " THEN BEGIN
                CASE GenJnlLine."Gen. Posting Type" OF
                    GenJnlLine."Gen. Posting Type"::Sale:
                        SalesPostingType := TRUE;
                    GenJnlLine."Gen. Posting Type"::Purchase:
                        PurchPostingType := TRUE;
                END;
                TestPostingType;

                IF NOT VATPostingSetup.GET(GenJnlLine."VAT Bus. Posting Group", GenJnlLine."VAT Prod. Posting Group") THEN
                    AddError(
                      STRSUBSTNO(
                        Text036,
                        VATPostingSetup.TABLECAPTION, GenJnlLine."VAT Bus. Posting Group", GenJnlLine."VAT Prod. Posting Group"))
                ELSE
                    IF GenJnlLine."VAT Calculation Type" <> VATPostingSetup."VAT Calculation Type" THEN
                        AddError(
                          STRSUBSTNO(
                            Text037,
                            GenJnlLine.FIELDCAPTION("VAT Calculation Type"), VATPostingSetup."VAT Calculation Type"))
            END;

            IF GLAcc."Reconciliation Account" THEN
                ReconcileGLAccNo(GenJnlLine."Account No.", ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."VAT %" / 100)));
        END;
    end;

    local procedure CheckCust(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[50])
    begin
        IF NOT Cust.GET(GenJnlLine."Account No.") THEN
            AddError(
              STRSUBSTNO(
                Text031,
                Cust.TABLECAPTION, GenJnlLine."Account No."))
        ELSE BEGIN
            AccName := Cust.Name;
            IF ((Cust.Blocked = Cust.Blocked::All) OR
                ((Cust.Blocked IN [Cust.Blocked::Invoice, Cust.Blocked::Ship]) AND
                 (GenJnlLine."Document Type" IN [GenJnlLine."Document Type"::Invoice, GenJnlLine."Document Type"::" "]))
                )
            THEN
                AddError(
                  STRSUBSTNO(
                    Text065,
                    GenJnlLine."Account Type", Cust.Blocked, GenJnlLine.FIELDCAPTION("Document Type"), GenJnlLine."Document Type"));
            IF GenJnlLine."Currency Code" <> '' THEN
                IF NOT Currency.GET(GenJnlLine."Currency Code") THEN
                    AddError(
                      STRSUBSTNO(
                        Text038,
                        GenJnlLine."Currency Code"));
            IF (Cust."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) THEN
                IF ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
                    IF ICPartner.Blocked THEN
                        AddError(
                          STRSUBSTNO(
                            '%1 %2',
                            STRSUBSTNO(
                              Text067,
                              Cust.TABLECAPTION, GenJnlLine."Account No.", ICPartner.TABLECAPTION, GenJnlLine."IC Partner Code"),
                            STRSUBSTNO(
                              Text032,
                              ICPartner.FIELDCAPTION(Blocked), FALSE, ICPartner.TABLECAPTION, Cust."IC Partner Code")));
                END ELSE
                    AddError(
                      STRSUBSTNO(
                        '%1 %2',
                        STRSUBSTNO(
                          Text067,
                          Cust.TABLECAPTION, GenJnlLine."Account No.", ICPartner.TABLECAPTION, Cust."IC Partner Code"),
                        STRSUBSTNO(
                          Text031,
                          ICPartner.TABLECAPTION, Cust."IC Partner Code")));
            CustPosting := TRUE;
            TestPostingType;

            IF GenJnlLine."Recurring Method" = GenJnlLine."Recurring Method"::" " THEN
                IF GenJnlLine."Document Type" IN
                   [GenJnlLine."Document Type"::Invoice, GenJnlLine."Document Type"::"Credit Memo",
                    GenJnlLine."Document Type"::"Finance Charge Memo", GenJnlLine."Document Type"::Reminder]
                THEN BEGIN
                    OldCustLedgEntry.RESET;
                    OldCustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                    OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
                    OldCustLedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
                    IF OldCustLedgEntry.FINDFIRST THEN
                        AddError(
                          STRSUBSTNO(
                            Text039, GenJnlLine."Document Type", GenJnlLine."Document No."));

                    IF SalesSetup."Ext. Doc. No. Mandatory" OR
                       (GenJnlLine."External Document No." <> '')
                    THEN BEGIN
                        IF GenJnlLine."External Document No." = '' THEN
                            AddError(
                              STRSUBSTNO(
                                Text041, GenJnlLine.FIELDCAPTION("External Document No.")));

                        OldCustLedgEntry.RESET;
                        OldCustLedgEntry.SETCURRENTKEY("Document Type", "External Document No.", "Customer No.");
                        OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
                        OldCustLedgEntry.SETRANGE("Customer No.", GenJnlLine."Account No.");
                        OldCustLedgEntry.SETRANGE("External Document No.", GenJnlLine."External Document No.");
                        IF OldCustLedgEntry.FINDFIRST THEN
                            AddError(
                              STRSUBSTNO(
                                Text039,
                                GenJnlLine."Document Type", GenJnlLine."External Document No."));
                        CheckAgainstPrevLines("Gen. Journal Line");
                    END;
                END;
        END;
    end;

    local procedure CheckVend(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[50])
    begin
        IF NOT Vend.GET(GenJnlLine."Account No.") THEN
            AddError(
              STRSUBSTNO(
                Text031,
                Vend.TABLECAPTION, GenJnlLine."Account No."))
        ELSE BEGIN
            AccName := Vend.Name;

            IF ((Vend.Blocked = Vend.Blocked::All) OR
                ((Vend.Blocked = Vend.Blocked::Payment) AND (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment))
                )
            THEN
                AddError(
                  STRSUBSTNO(
                    Text065,
                    GenJnlLine."Account Type", Vend.Blocked, GenJnlLine.FIELDCAPTION("Document Type"), GenJnlLine."Document Type"));

            IF GenJnlLine."Currency Code" <> '' THEN
                IF NOT Currency.GET(GenJnlLine."Currency Code") THEN
                    AddError(
                      STRSUBSTNO(
                        Text038,
                        GenJnlLine."Currency Code"));

            IF (Vend."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) THEN
                IF ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
                    IF ICPartner.Blocked THEN
                        AddError(
                          STRSUBSTNO(
                            '%1 %2',
                            STRSUBSTNO(
                              Text067,
                              Vend.TABLECAPTION, GenJnlLine."Account No.", ICPartner.TABLECAPTION, Vend."IC Partner Code"),
                            STRSUBSTNO(
                              Text032,
                              ICPartner.FIELDCAPTION(Blocked), FALSE, ICPartner.TABLECAPTION, Vend."IC Partner Code")));
                END ELSE
                    AddError(
                      STRSUBSTNO(
                        '%1 %2',
                        STRSUBSTNO(
                          Text067,
                          Vend.TABLECAPTION, GenJnlLine."Account No.", ICPartner.TABLECAPTION, GenJnlLine."IC Partner Code"),
                        STRSUBSTNO(
                          Text031,
                          ICPartner.TABLECAPTION, Vend."IC Partner Code")));
            VendPosting := TRUE;
            TestPostingType;

            IF GenJnlLine."Recurring Method" = GenJnlLine."Recurring Method"::" " THEN
                IF GenJnlLine."Document Type" IN
                   [GenJnlLine."Document Type"::Invoice, GenJnlLine."Document Type"::"Credit Memo",
                    GenJnlLine."Document Type"::"Finance Charge Memo", GenJnlLine."Document Type"::Reminder]
                THEN BEGIN
                    OldVendLedgEntry.RESET;
                    OldVendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                    OldVendLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
                    OldVendLedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
                    IF OldVendLedgEntry.FINDFIRST THEN
                        AddError(
                          STRSUBSTNO(
                            Text040,
                            GenJnlLine."Document Type", GenJnlLine."Document No."));

                    IF PurchSetup."Ext. Doc. No. Mandatory" OR
                       (GenJnlLine."External Document No." <> '')
                    THEN BEGIN
                        IF GenJnlLine."External Document No." = '' THEN
                            AddError(
                              STRSUBSTNO(
                                Text041, GenJnlLine.FIELDCAPTION("External Document No.")));

                        OldVendLedgEntry.RESET;
                        OldVendLedgEntry.SETCURRENTKEY("External Document No.", "Document Type", "Vendor No.");
                        OldVendLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
                        OldVendLedgEntry.SETRANGE("Vendor No.", GenJnlLine."Account No.");
                        OldVendLedgEntry.SETRANGE("External Document No.", GenJnlLine."External Document No.");
                        IF OldVendLedgEntry.FINDFIRST THEN
                            AddError(
                              STRSUBSTNO(
                                Text040,
                                GenJnlLine."Document Type", GenJnlLine."External Document No."));
                        CheckAgainstPrevLines("Gen. Journal Line");
                    END;
                END;
        END;
    end;

    local procedure CheckBankAcc(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[50])
    begin
        IF NOT BankAcc.GET(GenJnlLine."Account No.") THEN
            AddError(
              STRSUBSTNO(
                Text031,
                BankAcc.TABLECAPTION, GenJnlLine."Account No."))
        ELSE BEGIN
            AccName := BankAcc.Name;

            IF BankAcc.Blocked THEN
                AddError(
                  STRSUBSTNO(
                    Text032,
                    BankAcc.FIELDCAPTION(Blocked), FALSE, BankAcc.TABLECAPTION, GenJnlLine."Account No."));
            IF (GenJnlLine."Currency Code" <> BankAcc."Currency Code") AND (BankAcc."Currency Code" <> '') THEN
                AddError(
                  STRSUBSTNO(
                    Text037,
                    GenJnlLine.FIELDCAPTION("Currency Code"), BankAcc."Currency Code"));

            IF GenJnlLine."Currency Code" <> '' THEN
                IF NOT Currency.GET(GenJnlLine."Currency Code") THEN
                    AddError(
                      STRSUBSTNO(
                        Text038,
                        GenJnlLine."Currency Code"));

            IF GenJnlLine."Bank Payment Type" <> GenJnlLine."Bank Payment Type"::" " THEN
                IF (GenJnlLine."Bank Payment Type" = GenJnlLine."Bank Payment Type"::"Computer Check") AND (GenJnlLine.Amount < 0) THEN
                    IF BankAcc."Currency Code" <> GenJnlLine."Currency Code" THEN
                        AddError(
                          STRSUBSTNO(
                            Text042,
                            GenJnlLine.FIELDCAPTION("Bank Payment Type"), GenJnlLine.FIELDCAPTION("Currency Code"),
                            GenJnlLine.TABLECAPTION, BankAcc.TABLECAPTION));

            IF BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group") THEN
                IF BankAccPostingGr."G/L Account No." <> '' THEN
                    ReconcileGLAccNo(
                      BankAccPostingGr."G/L Account No.",
                      ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."VAT %" / 100)));
        END;
    end;

    local procedure CheckFixedAsset(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[50])
    begin
        IF NOT FA.GET(GenJnlLine."Account No.") THEN
            AddError(
              STRSUBSTNO(
                Text031,
                FA.TABLECAPTION, GenJnlLine."Account No."))
        ELSE BEGIN
            AccName := FA.Description;
            IF FA.Blocked THEN
                AddError(
                  STRSUBSTNO(
                    Text032,
                    FA.FIELDCAPTION(Blocked), FALSE, FA.TABLECAPTION, GenJnlLine."Account No."));
            IF FA.Inactive THEN
                AddError(
                  STRSUBSTNO(
                    Text032,
                    FA.FIELDCAPTION(Inactive), FALSE, FA.TABLECAPTION, GenJnlLine."Account No."));
            IF FA."Budgeted Asset" THEN
                AddError(
                  STRSUBSTNO(
                    Text043,
                    FA.TABLECAPTION, GenJnlLine."Account No.", FA.FIELDCAPTION("Budgeted Asset"), TRUE));
            IF DeprBook.GET(GenJnlLine."Depreciation Book Code") THEN
                CheckFAIntegration(GenJnlLine)
            ELSE
                AddError(
                  STRSUBSTNO(
                    Text031,
                    DeprBook.TABLECAPTION, GenJnlLine."Depreciation Book Code"));
            IF NOT FADeprBook.GET(FA."No.", GenJnlLine."Depreciation Book Code") THEN
                AddError(
                  STRSUBSTNO(
                    Text036,
                    FADeprBook.TABLECAPTION, FA."No.", GenJnlLine."Depreciation Book Code"));
        END;
    end;

    procedure CheckICPartner(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[50])
    begin
        IF NOT ICPartner.GET(GenJnlLine."Account No.") THEN
            AddError(
              STRSUBSTNO(
                Text031,
                ICPartner.TABLECAPTION, GenJnlLine."Account No."))
        ELSE BEGIN
            AccName := ICPartner.Name;
            IF ICPartner.Blocked THEN
                AddError(
                  STRSUBSTNO(
                    Text032,
                    ICPartner.FIELDCAPTION(Blocked), FALSE, ICPartner.TABLECAPTION, GenJnlLine."Account No."));
        END;
    end;

    local procedure TestFixedAsset(var GenJnlLine: Record "Gen. Journal Line")
    begin
        IF GenJnlLine."Job No." <> '' THEN
            AddError(
              STRSUBSTNO(
                Text044, GenJnlLine.FIELDCAPTION("Job No.")));
        IF GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::" " THEN
            AddError(
              STRSUBSTNO(
                Text045, GenJnlLine.FIELDCAPTION("FA Posting Type")));
        IF GenJnlLine."Depreciation Book Code" = '' THEN
            AddError(
              STRSUBSTNO(
                Text045, GenJnlLine.FIELDCAPTION("Depreciation Book Code")));
        IF GenJnlLine."Depreciation Book Code" = GenJnlLine."Duplicate in Depreciation Book" THEN
            AddError(
              STRSUBSTNO(
                Text046,
                GenJnlLine.FIELDCAPTION("Depreciation Book Code"), GenJnlLine.FIELDCAPTION("Duplicate in Depreciation Book")));
        IF GenJnlLine."Account Type" = GenJnlLine."Bal. Account Type" THEN
            AddError(
              STRSUBSTNO(
                Text047,
                GenJnlLine.FIELDCAPTION("Account Type"), GenJnlLine.FIELDCAPTION("Bal. Account Type"), GenJnlLine."Account Type"));
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" THEN
            IF GenJnlLine."FA Posting Type" IN
               [GenJnlLine."FA Posting Type"::"Acquisition Cost", GenJnlLine."FA Posting Type"::Disposal, GenJnlLine."FA Posting Type"::Maintenance]
            THEN BEGIN
                IF (GenJnlLine."Gen. Bus. Posting Group" <> '') OR (GenJnlLine."Gen. Prod. Posting Group" <> '') THEN
                    IF GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::" " THEN
                        AddError(STRSUBSTNO(Text002, GenJnlLine.FIELDCAPTION("Gen. Posting Type")));
            END ELSE BEGIN
                IF GenJnlLine."Gen. Posting Type" <> GenJnlLine."Gen. Posting Type"::" " THEN
                    AddError(
                      STRSUBSTNO(
                        Text048,
                        GenJnlLine.FIELDCAPTION("Gen. Posting Type"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
                IF GenJnlLine."Gen. Bus. Posting Group" <> '' THEN
                    AddError(
                      STRSUBSTNO(
                        Text049,
                        GenJnlLine.FIELDCAPTION("Gen. Bus. Posting Group"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
                IF GenJnlLine."Gen. Prod. Posting Group" <> '' THEN
                    AddError(
                      STRSUBSTNO(
                        Text049,
                        GenJnlLine.FIELDCAPTION("Gen. Prod. Posting Group"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
            END;
        IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Fixed Asset" THEN
            IF GenJnlLine."FA Posting Type" IN
               [GenJnlLine."FA Posting Type"::"Acquisition Cost", GenJnlLine."FA Posting Type"::Disposal, GenJnlLine."FA Posting Type"::Maintenance]
            THEN BEGIN
                IF (GenJnlLine."Bal. Gen. Bus. Posting Group" <> '') OR (GenJnlLine."Bal. Gen. Prod. Posting Group" <> '') THEN
                    IF GenJnlLine."Bal. Gen. Posting Type" = GenJnlLine."Bal. Gen. Posting Type"::" " THEN
                        AddError(STRSUBSTNO(Text002, GenJnlLine.FIELDCAPTION("Bal. Gen. Posting Type")));
            END ELSE BEGIN
                IF GenJnlLine."Bal. Gen. Posting Type" <> GenJnlLine."Bal. Gen. Posting Type"::" " THEN
                    AddError(
                      STRSUBSTNO(
                        Text049,
                        GenJnlLine.FIELDCAPTION("Bal. Gen. Posting Type"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
                IF GenJnlLine."Bal. Gen. Bus. Posting Group" <> '' THEN
                    AddError(
                      STRSUBSTNO(
                        Text049,
                        GenJnlLine.FIELDCAPTION("Bal. Gen. Bus. Posting Group"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
                IF GenJnlLine."Bal. Gen. Prod. Posting Group" <> '' THEN
                    AddError(
                      STRSUBSTNO(
                        Text049,
                        GenJnlLine.FIELDCAPTION("Bal. Gen. Prod. Posting Group"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
            END;
        TempErrorText :=
          '%1 ' +
          STRSUBSTNO(
            Text050,
            GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type");
        IF GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::"Acquisition Cost" THEN BEGIN
            IF GenJnlLine."Depr. Acquisition Cost" THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Depr. Acquisition Cost")));
            IF GenJnlLine."Salvage Value" <> 0 THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Salvage Value")));
            IF GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::Maintenance THEN
                IF GenJnlLine.Quantity <> 0 THEN
                    AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION(Quantity)));
            IF GenJnlLine."Insurance No." <> '' THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Insurance No.")));
        END;
        IF (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Maintenance) AND GenJnlLine."Depr. until FA Posting Date" THEN
            AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Depr. until FA Posting Date")));
        IF (GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::Maintenance) AND (GenJnlLine."Maintenance Code" <> '') THEN
            AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Maintenance Code")));

        IF (GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::Depreciation) AND
           (GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::"Custom 1") AND
           (GenJnlLine."No. of Depreciation Days" <> 0)
        THEN
            AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("No. of Depreciation Days")));

        IF (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Disposal) AND GenJnlLine."FA Reclassification Entry" THEN
            AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("FA Reclassification Entry")));

        IF (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Disposal) AND (GenJnlLine."Budgeted FA No." <> '') THEN
            AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Budgeted FA No.")));

        IF GenJnlLine."FA Posting Date" = 0D THEN
            GenJnlLine."FA Posting Date" := GenJnlLine."Posting Date";
        IF DeprBook.GET(GenJnlLine."Depreciation Book Code") THEN
            IF DeprBook."Use Same FA+G/L Posting Dates" AND (GenJnlLine."Posting Date" <> GenJnlLine."FA Posting Date") THEN
                AddError(
                  STRSUBSTNO(
                    Text051,
                    GenJnlLine.FIELDCAPTION("Posting Date"), GenJnlLine.FIELDCAPTION("FA Posting Date")));
        IF GenJnlLine."FA Posting Date" <> 0D THEN BEGIN
            //closDate := CLOSINGDATE("FA Posting Date");
            //normDate := NORMALDATE(closDate);
            IF GenJnlLine."FA Posting Date" <> NORMALDATE(GenJnlLine."FA Posting Date") THEN
                AddError(
                  STRSUBSTNO(
                    Text052,
                    GenJnlLine.FIELDCAPTION("FA Posting Date")));
            IF (GenJnlLine."FA Posting Date" IN [00010101D .. 99981231D]) THEN
                AddError(
                  STRSUBSTNO(
                    Text053,
                    GenJnlLine.FIELDCAPTION("FA Posting Date")));
            IF (AllowFAPostingFrom = 0D) AND (AllowFAPostingTo = 0D) THEN BEGIN
                IF USERID <> '' THEN
                    IF UserSetup.GET(USERID) THEN BEGIN
                        AllowFAPostingFrom := UserSetup."Allow FA Posting From";
                        AllowFAPostingTo := UserSetup."Allow FA Posting To";
                    END;
                IF (AllowFAPostingFrom = 0D) AND (AllowFAPostingTo = 0D) THEN BEGIN
                    FASetup.GET;
                    AllowFAPostingFrom := FASetup."Allow FA Posting From";
                    AllowFAPostingTo := FASetup."Allow FA Posting To";
                END;
                IF AllowFAPostingTo = 0D THEN
                    AllowFAPostingTo := 99981231D;
            END;
            IF (GenJnlLine."FA Posting Date" < AllowFAPostingFrom) OR
               (GenJnlLine."FA Posting Date" > AllowFAPostingTo)
            THEN
                AddError(
                  STRSUBSTNO(
                    Text053,
                    GenJnlLine.FIELDCAPTION("FA Posting Date")));
        END;
        FASetup.GET;
        IF (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::"Acquisition Cost") AND
           (GenJnlLine."Insurance No." <> '') AND (GenJnlLine."Depreciation Book Code" <> FASetup."Insurance Depr. Book")
        THEN
            AddError(
              STRSUBSTNO(
                Text054,
                GenJnlLine.FIELDCAPTION("Depreciation Book Code"), GenJnlLine."Depreciation Book Code"));

        IF GenJnlLine."FA Error Entry No." > 0 THEN BEGIN
            TempErrorText :=
              '%1 ' +
              STRSUBSTNO(
                Text055,
                GenJnlLine.FIELDCAPTION("FA Error Entry No."));
            IF GenJnlLine."Depr. until FA Posting Date" THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Depr. until FA Posting Date")));
            IF GenJnlLine."Depr. Acquisition Cost" THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Depr. Acquisition Cost")));
            IF GenJnlLine."Duplicate in Depreciation Book" <> '' THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Duplicate in Depreciation Book")));
            IF GenJnlLine."Use Duplication List" THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Use Duplication List")));
            IF GenJnlLine."Salvage Value" <> 0 THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Salvage Value")));
            IF GenJnlLine."Insurance No." <> '' THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Insurance No.")));
            IF GenJnlLine."Budgeted FA No." <> '' THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Budgeted FA No.")));
            IF GenJnlLine."Recurring Method" <> GenJnlLine."Recurring Method"::" " THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Recurring Method")));
            IF GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Maintenance THEN
                AddError(STRSUBSTNO(TempErrorText, GenJnlLine."FA Posting Type"));
        END;
    end;

    local procedure CheckFAIntegration(var GenJnlLine: Record "Gen. Journal Line")
    var
        GLIntegration: Boolean;
    begin
        IF GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::" " THEN
            EXIT;
        CASE GenJnlLine."FA Posting Type" OF
            GenJnlLine."FA Posting Type"::"Acquisition Cost":
                GLIntegration := DeprBook."G/L Integration - Acq. Cost";
            GenJnlLine."FA Posting Type"::Depreciation:
                GLIntegration := DeprBook."G/L Integration - Depreciation";
            GenJnlLine."FA Posting Type"::"Write-Down":
                GLIntegration := DeprBook."G/L Integration - Write-Down";
            GenJnlLine."FA Posting Type"::Appreciation:
                GLIntegration := DeprBook."G/L Integration - Appreciation";
            GenJnlLine."FA Posting Type"::"Custom 1":
                GLIntegration := DeprBook."G/L Integration - Custom 1";
            GenJnlLine."FA Posting Type"::"Custom 2":
                GLIntegration := DeprBook."G/L Integration - Custom 2";
            GenJnlLine."FA Posting Type"::Disposal:
                GLIntegration := DeprBook."G/L Integration - Disposal";
            GenJnlLine."FA Posting Type"::Maintenance:
                GLIntegration := DeprBook."G/L Integration - Maintenance";
        END;
        IF NOT GLIntegration THEN
            AddError(
              STRSUBSTNO(
                Text056,
                GenJnlLine."FA Posting Type"));

        IF NOT DeprBook."G/L Integration - Depreciation" THEN BEGIN
            IF GenJnlLine."Depr. until FA Posting Date" THEN
                AddError(
                  STRSUBSTNO(
                    Text057,
                    GenJnlLine.FIELDCAPTION("Depr. until FA Posting Date")));
            IF GenJnlLine."Depr. Acquisition Cost" THEN
                AddError(
                  STRSUBSTNO(
                    Text057,
                    GenJnlLine.FIELDCAPTION("Depr. Acquisition Cost")));
        END;
    end;

    local procedure TestFixedAssetFields(var GenJnlLine: Record "Gen. Journal Line")
    begin
        IF GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::" " THEN
            AddError(STRSUBSTNO(Text058, GenJnlLine.FIELDCAPTION("FA Posting Type")));
        IF GenJnlLine."Depreciation Book Code" <> '' THEN
            AddError(STRSUBSTNO(Text058, GenJnlLine.FIELDCAPTION("Depreciation Book Code")));
    end;

    procedure TestPostingType()
    begin
        CASE TRUE OF
            CustPosting AND PurchPostingType:
                AddError(Text059);
            VendPosting AND SalesPostingType:
                AddError(Text060);
        END;
    end;

    local procedure WarningIfNegativeAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        IF (GenJnlLine.Amount < 0) AND NOT AmountError THEN BEGIN
            AmountError := TRUE;
            AddError(STRSUBSTNO(Text007, GenJnlLine.FIELDCAPTION(Amount)));
        END;
    end;

    local procedure WarningIfPositiveAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        IF (GenJnlLine.Amount > 0) AND NOT AmountError THEN BEGIN
            AmountError := TRUE;
            AddError(STRSUBSTNO(Text006, GenJnlLine.FIELDCAPTION(Amount)));
        END;
    end;

    local procedure WarningIfZeroAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        IF (GenJnlLine.Amount = 0) AND NOT AmountError THEN BEGIN
            AmountError := TRUE;
            AddError(STRSUBSTNO(Text002, GenJnlLine.FIELDCAPTION(Amount)));
        END;
    end;

    local procedure WarningIfNonZeroAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        IF (GenJnlLine.Amount <> 0) AND NOT AmountError THEN BEGIN
            AmountError := TRUE;
            AddError(STRSUBSTNO(Text062, GenJnlLine.FIELDCAPTION(Amount)));
        END;
    end;

    local procedure CheckAgainstPrevLines(GenJnlLine: Record "Gen. Journal Line")
    var
        i: Integer;
        AccType: Integer;
        AccNo: Code[20];
        ErrorFound: Boolean;
    begin
        IF (GenJnlLine."External Document No." = '') OR
           NOT (GenJnlLine."Account Type" IN
                [GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor]) AND
           NOT (GenJnlLine."Bal. Account Type" IN
                [GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor])
        THEN
            EXIT;

        IF GenJnlLine."Account Type" IN [GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor] THEN BEGIN
            AccType := GenJnlLine."Account Type".AsInteger();
            AccNo := GenJnlLine."Account No.";
        END ELSE BEGIN
            AccType := GenJnlLine."Bal. Account Type".AsInteger();
            AccNo := GenJnlLine."Bal. Account No.";
        END;

        TempGenJnlLine.RESET;
        TempGenJnlLine.SETRANGE("External Document No.", GenJnlLine."External Document No.");

        WHILE (i < 2) AND NOT ErrorFound DO BEGIN
            i := i + 1;
            IF i = 1 THEN BEGIN
                TempGenJnlLine.SETRANGE("Account Type", AccType);
                TempGenJnlLine.SETRANGE("Account No.", AccNo);
                TempGenJnlLine.SETRANGE("Bal. Account Type");
                TempGenJnlLine.SETRANGE("Bal. Account No.");
            END ELSE BEGIN
                TempGenJnlLine.SETRANGE("Account Type");
                TempGenJnlLine.SETRANGE("Account No.");
                TempGenJnlLine.SETRANGE("Bal. Account Type", AccType);
                TempGenJnlLine.SETRANGE("Bal. Account No.", AccNo);
            END;
            IF TempGenJnlLine.FINDFIRST THEN BEGIN
                ErrorFound := TRUE;
                AddError(
                  STRSUBSTNO(
                    Text064, GenJnlLine.FIELDCAPTION("External Document No."), GenJnlLine."External Document No.",
                    TempGenJnlLine."Line No.", GenJnlLine.FIELDCAPTION("Document No."), TempGenJnlLine."Document No."));
            END;
        END;

        TempGenJnlLine.RESET;
        TempGenJnlLine := GenJnlLine;
        TempGenJnlLine.INSERT;
    end;

    procedure CheckICDocument()
    var
        GenJnlLine4: Record "Gen. Journal Line";
        "IC G/L Account": Record "IC G/L Account";
    begin
        IF GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany THEN BEGIN
            IF ("Gen. Journal Line"."Posting Date" <> LastDate) OR ("Gen. Journal Line"."Document Type" <> LastDocType) OR ("Gen. Journal Line"."Document No." <> LastDocNo) THEN BEGIN
                GenJnlLine4.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                GenJnlLine4.SETRANGE("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                GenJnlLine4.SETRANGE("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                GenJnlLine4.SETRANGE("Posting Date", "Gen. Journal Line"."Posting Date");
                GenJnlLine4.SETRANGE("Document No.", "Gen. Journal Line"."Document No.");
                GenJnlLine4.SETFILTER("IC Partner Code", '<>%1', '');
                IF GenJnlLine4.FINDFIRST THEN
                    CurrentICPartner := GenJnlLine4."IC Partner Code"
                ELSE
                    CurrentICPartner := '';
            END;
            IF (CurrentICPartner <> '') AND ("Gen. Journal Line"."IC Direction" = "Gen. Journal Line"."IC Direction"::Outgoing) THEN BEGIN
                IF ("Gen. Journal Line"."Account Type" IN ["Gen. Journal Line"."Account Type"::"G/L Account", "Gen. Journal Line"."Account Type"::"Bank Account"]) AND
                   ("Gen. Journal Line"."Bal. Account Type" IN ["Gen. Journal Line"."Bal. Account Type"::"G/L Account", "Gen. Journal Line"."Account Type"::"Bank Account"]) AND
                   ("Gen. Journal Line"."Account No." <> '') AND
                   ("Gen. Journal Line"."Bal. Account No." <> '')
                THEN BEGIN
                    AddError(
                      STRSUBSTNO(
                        Text066, "Gen. Journal Line".FIELDCAPTION("Account No."), "Gen. Journal Line".FIELDCAPTION("Bal. Account No.")));
                END ELSE BEGIN
                    IF (("Gen. Journal Line"."Account Type" IN ["Gen. Journal Line"."Account Type"::"G/L Account", "Gen. Journal Line"."Account Type"::"Bank Account"]) AND ("Gen. Journal Line"."Account No." <> '')) XOR
                       (("Gen. Journal Line"."Bal. Account Type" IN ["Gen. Journal Line"."Bal. Account Type"::"G/L Account", "Gen. Journal Line"."Account Type"::"Bank Account"]) AND
                        ("Gen. Journal Line"."Bal. Account No." <> ''))
                    THEN BEGIN
                        IF "Gen. Journal Line"."IC Account No." = '' THEN
                            AddError(
                              STRSUBSTNO(
                                Text002, "Gen. Journal Line".FIELDCAPTION("IC Account No.")))
                        ELSE BEGIN
                            IF "IC G/L Account".GET("Gen. Journal Line"."IC Account No.") THEN
                                IF "IC G/L Account".Blocked THEN
                                    AddError(
                                      STRSUBSTNO(
                                        Text032,
                                        "IC G/L Account".FIELDCAPTION(Blocked), FALSE, "Gen. Journal Line".FIELDCAPTION("IC Account No."),
                                        "Gen. Journal Line"."IC Account No."
                                        ));
                        END;
                    END ELSE
                        IF "Gen. Journal Line"."IC Account No." <> '' THEN
                            AddError(
                              STRSUBSTNO(
                                Text009, "Gen. Journal Line".FIELDCAPTION("IC Account No.")));
                END;
            END ELSE
                IF "Gen. Journal Line"."IC Account No." <> '' THEN BEGIN
                    IF "Gen. Journal Line"."IC Direction" = "Gen. Journal Line"."IC Direction"::Incoming THEN
                        AddError(
                          STRSUBSTNO(
                            Text069, "Gen. Journal Line".FIELDCAPTION("IC Account No."), "Gen. Journal Line".FIELDCAPTION("IC Direction"), FORMAT("Gen. Journal Line"."IC Direction")));
                    IF CurrentICPartner = '' THEN
                        AddError(
                          STRSUBSTNO(
                            Text070, "Gen. Journal Line".FIELDCAPTION("IC Account No.")));
                END;
        END;
    end;

    procedure GetCurrencyRecord(Currency: Record Currency; CurrencyCode: Code[10])
    begin
        //added by wei for Apply Entry--- Reference Report 10402
        IF CurrencyCode = '' THEN BEGIN
            CLEAR(Currency);
            Currency.Description := GLSetup."LCY Code";
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        END ELSE
            IF Currency.Code <> CurrencyCode THEN
                IF NOT Currency.GET(CurrencyCode) THEN
                    AddError(STRSUBSTNO(Text006, CurrencyCode, "Gen. Journal Line".FIELDCAPTION("Currency Code")));
    end;
}

