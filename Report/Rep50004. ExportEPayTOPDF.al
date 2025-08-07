report 50004 "Export E-Pay TO PDF"
{
    // =================================================================================
    // Ver.No.     Date         Sign.  ID              Description
    // ---------------------------------------------------------------------------------
    // CSPH1       2015-11-26   LEON   FDD207          ACH Remittance Advice
    // =================================================================================
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Export E-Pay TO PDF.rdlc';

    Caption = 'Export Electronic Payments';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.")
                                WHERE("Bank Payment Type" = FILTER("Electronic Payment" | "Electronic Payment-IAT"),
                                      "Document Type" = FILTER(Payment | Refund));
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            column(Gen__Journal_Line_Journal_Template_Name; "Journal Template Name")
            {
            }
            column(Gen__Journal_Line_Journal_Batch_Name; "Journal Batch Name")
            {
            }
            column(Gen__Journal_Line_Line_No_; "Line No.")
            {
            }
            column(Gen__Journal_Line_Applies_to_ID; "Applies-to ID")
            {
            }
            column(ActNo; "Account No.")
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CompanyAddress_1_; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress_2_; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress_3_; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress_4_; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress_5_; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress_6_; CompanyAddress[6])
                    {
                    }
                    column(CompanyAddress_7_; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress_8_; CompanyAddress[8])
                    {
                    }
                    column(CompanyLogo; CompanyInformation.Picture)
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(PayeeAddress_1_; PayeeAddress[1])
                    {
                    }
                    column(PayeeAddress_2_; PayeeAddress[2])
                    {
                    }
                    column(PayeeAddress_3_; PayeeAddress[3])
                    {
                    }
                    column(PayeeAddress_4_; PayeeAddress[4])
                    {
                    }
                    column(PayeeAddress_5_; PayeeAddress[5])
                    {
                    }
                    column(PayeeAddress_6_; PayeeAddress[6])
                    {
                    }
                    column(PayeeAddress_7_; PayeeAddress[7])
                    {
                    }
                    column(PayeeAddress_8_; PayeeAddress[8])
                    {
                    }
                    column(Gen__Journal_Line___Document_No__; "Gen. Journal Line"."Document No.")
                    {
                    }
                    column(SettleDate; SettleDate)
                    {
                    }
                    column(CurrReport_PAGENO; 0)
                    {
                    }
                    column(ExportAmount; -ExportAmount)
                    {
                    }
                    column(PayeeBankTransitNo; PayeeBankTransitNo)
                    {
                    }
                    column(PayeeBankAccountNo; PayeeBankAccountNo)
                    {
                    }
                    column(myNumber; CopyLoop.Number)
                    {
                    }
                    column(myBal; "Gen. Journal Line"."Bal. Account No.")
                    {
                    }
                    column(mypostingdate; "Gen. Journal Line"."Posting Date")
                    {
                    }
                    column(Gen__Journal_Line___Applies_to_Doc__No__; "Gen. Journal Line"."Applies-to Doc. No.")
                    {
                    }
                    column(myType; myType)
                    {
                    }
                    column(AmountPaid; AmountPaid)
                    {
                    }
                    column(DiscountTaken; DiscountTaken)
                    {
                    }
                    column(VendLedgEntry__Remaining_Amt___LCY__; -VendLedgEntry."Remaining Amt. (LCY)")
                    {
                    }
                    column(VendLedgEntry__Document_Date_; VendLedgEntry."Document Date")
                    {
                    }
                    column(VendLedgEntry__External_Document_No__; VendLedgEntry."External Document No.")
                    {
                    }
                    column(VendLedgEntry__Document_Type_; VendLedgEntry."Document Type")
                    {
                    }
                    column(AmountPaid_Control57; AmountPaid)
                    {
                    }
                    column(DiscountTaken_Control58; DiscountTaken)
                    {
                    }
                    column(CustLedgEntry__Remaining_Amt___LCY__; -CustLedgEntry."Remaining Amt. (LCY)")
                    {
                    }
                    column(CustLedgEntry__Document_Date_; CustLedgEntry."Document Date")
                    {
                    }
                    column(CustLedgEntry__Document_No__; CustLedgEntry."Document No.")
                    {
                    }
                    column(CustLedgEntry__Document_Type_; CustLedgEntry."Document Type")
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    column(REMITTANCE_ADVICECaption; REMITTANCE_ADVICECaptionLbl)
                    {
                    }
                    column(To_Caption; To_CaptionLbl)
                    {
                    }
                    column(Remittance_Advice_Number_Caption; Remittance_Advice_Number_CaptionLbl)
                    {
                    }
                    column(Settlement_Date_Caption; Settlement_Date_CaptionLbl)
                    {
                    }
                    column(Page_Caption; Page_CaptionLbl)
                    {
                    }
                    column(ExportAmountCaption; ExportAmountCaptionLbl)
                    {
                    }
                    column(PayeeBankTransitNoCaption; PayeeBankTransitNoCaptionLbl)
                    {
                    }
                    column(Deposited_In_Caption; Deposited_In_CaptionLbl)
                    {
                    }
                    column(PayeeBankAccountNoCaption; PayeeBankAccountNoCaptionLbl)
                    {
                    }
                    column(Vendor_Ledger_Entry__Document_Type_Caption; "Vendor Ledger Entry".FIELDCAPTION("Document Type"))
                    {
                    }
                    column(Cust__Ledger_Entry__Document_No__Caption; "Cust. Ledger Entry".FIELDCAPTION("Document No."))
                    {
                    }
                    column(Vendor_Ledger_Entry__Document_Date_Caption; "Vendor Ledger Entry".FIELDCAPTION("Document Date"))
                    {
                    }
                    column(Remaining_Amt___LCY___Control36Caption; Remaining_Amt___LCY___Control36CaptionLbl)
                    {
                    }
                    column(DiscountTaken_Control38Caption; DiscountTaken_Control38CaptionLbl)
                    {
                    }
                    column(AmountPaid_Control43Caption; AmountPaid_Control43CaptionLbl)
                    {
                    }
                    dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Applies-to ID" = FIELD("Applies-to ID");
                        DataItemLinkReference = "Gen. Journal Line";
                        DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date", "Currency Code")
                                            ORDER(Descending)
                                            WHERE(Open = CONST(true));
                        column(Cust__Ledger_Entry__Document_Type_; "Document Type")
                        {
                        }
                        column(Cust__Ledger_Entry__Document_No__; "Document No.")
                        {
                        }
                        column(Cust__Ledger_Entry__Document_Date_; "Document Date")
                        {
                        }
                        column(Remaining_Amt___LCY__; -"Remaining Amt. (LCY)")
                        {
                        }
                        column(DiscountTaken_Control49; DiscountTaken)
                        {
                        }
                        column(AmountPaid_Control50; AmountPaid)
                        {
                        }
                        column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Cust__Ledger_Entry_Applies_to_ID; "Applies-to ID")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CALCFIELDS("Remaining Amt. (LCY)");
                            IF ("Pmt. Discount Date" >= SettleDate) AND
                               ("Remaining Pmt. Disc. Possible" <> 0) AND
                               ((-ExportAmount - TotalAmountPaid) - "Remaining Pmt. Disc. Possible" >= -"Amount to Apply")
                            THEN BEGIN
                                DiscountTaken := -"Remaining Pmt. Disc. Possible";
                                AmountPaid := -("Amount to Apply" - "Remaining Pmt. Disc. Possible");
                            END ELSE BEGIN
                                DiscountTaken := 0;
                                IF (-ExportAmount - TotalAmountPaid) > -"Amount to Apply" THEN
                                    AmountPaid := -"Amount to Apply"
                                ELSE
                                    AmountPaid := -ExportAmount - TotalAmountPaid;
                            END;

                            TotalAmountPaid := TotalAmountPaid + AmountPaid;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF "Gen. Journal Line"."Applies-to ID" = '' THEN
                                CurrReport.BREAK;

                            IF BankAccountIs = BankAccountIs::Acnt THEN BEGIN
                                IF "Gen. Journal Line"."Bal. Account Type" <> "Gen. Journal Line"."Bal. Account Type"::Customer THEN
                                    CurrReport.BREAK;
                                SETRANGE("Customer No.", "Gen. Journal Line"."Bal. Account No.");
                            END ELSE BEGIN
                                IF "Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Customer THEN
                                    CurrReport.BREAK;
                                SETRANGE("Customer No.", "Gen. Journal Line"."Account No.");
                            END;
                        end;
                    }
                    dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                    {
                        DataItemLink = "Applies-to ID" = FIELD("Applies-to ID");
                        DataItemLinkReference = "Gen. Journal Line";
                        DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code")
                                            ORDER(Descending)
                                            WHERE(Open = CONST(true));
                        column(Vendor_Ledger_Entry__Document_Type_; "Document Type")
                        {
                        }
                        column(Vendor_Ledger_Entry__External_Document_No__; "External Document No.")
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_Date_; "Document Date")
                        {
                        }
                        column(Remaining_Amt___LCY___Control36; -"Remaining Amt. (LCY)")
                        {
                        }
                        column(DiscountTaken_Control38; DiscountTaken)
                        {
                        }
                        column(AmountPaid_Control43; AmountPaid)
                        {
                        }
                        column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Vendor_Ledger_Entry_Applies_to_ID; "Applies-to ID")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CALCFIELDS("Remaining Amt. (LCY)");
                            IF ("Pmt. Discount Date" >= SettleDate) AND
                               ("Remaining Pmt. Disc. Possible" <> 0) AND
                               ((-ExportAmount - TotalAmountPaid) - "Remaining Pmt. Disc. Possible" >= -"Amount to Apply")
                            THEN BEGIN
                                DiscountTaken := -"Remaining Pmt. Disc. Possible";
                                AmountPaid := -("Amount to Apply" - "Remaining Pmt. Disc. Possible");
                            END ELSE BEGIN
                                DiscountTaken := 0;
                                IF (-ExportAmount - TotalAmountPaid) > -"Amount to Apply" THEN
                                    AmountPaid := -"Amount to Apply"
                                ELSE
                                    AmountPaid := -ExportAmount - TotalAmountPaid;
                            END;

                            TotalAmountPaid := TotalAmountPaid + AmountPaid;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF "Gen. Journal Line"."Applies-to ID" = '' THEN
                                CurrReport.BREAK;

                            IF BankAccountIs = BankAccountIs::Acnt THEN BEGIN
                                IF "Gen. Journal Line"."Bal. Account Type" <> "Gen. Journal Line"."Bal. Account Type"::Vendor THEN
                                    CurrReport.BREAK;
                                SETRANGE("Vendor No.", "Gen. Journal Line"."Bal. Account No.");
                            END ELSE BEGIN
                                IF "Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Vendor THEN
                                    CurrReport.BREAK;
                                SETRANGE("Vendor No.", "Gen. Journal Line"."Account No.");
                            END;
                        end;
                    }
                    dataitem(Unapplied; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(Text004; Text004Lbl)
                        {
                        }
                        column(AmountPaid_Control65; AmountPaid)
                        {
                        }
                        column(Unapplied_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            AmountPaid := -ExportAmount - TotalAmountPaid;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF TotalAmountPaid >= -ExportAmount THEN
                                CurrReport.BREAK;
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        myType := PayeeType;// an Integer variable refer to  option type
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    //CurrReport.PAGENO := 1;
                    AmountPaid := SaveAmountPaid;

                    IF Number = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text005;

                    IF "Gen. Journal Line"."Applies-to Doc. No." = '' THEN
                        CLEAR(TotalAmountPaid);
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, NoCopies + 1);
                    SaveAmountPaid := AmountPaid;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                    BankAccountIs := BankAccountIs::Acnt;
                    IF "Account No." <> BankAccountNo THEN
                        CurrReport.SKIP;
                END ELSE
                    IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                        BankAccountIs := BankAccountIs::BalAcnt;
                        IF "Bal. Account No." <> BankAccountNo THEN
                            CurrReport.SKIP;
                    END ELSE
                        CurrReport.SKIP;

                IF (NOT CurrReport.PREVIEW) AND (NOT MailSkip) THEN BEGIN //CSPH1
                    IF NOT ACHFileCreated AND ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") THEN BEGIN
                        CASE BankAccount."Export Format" OF
                            BankAccount."Export Format"::US:
                                BEGIN
                                    ExportPaymentsACH.StartExportFile(BankAccountNo, '');
                                    ExportPaymentsACH.StartExportBatch('220', 'CTX', "Source Code", SettleDate);
                                    ACHFileCreated := TRUE;
                                END;
                            BankAccount."Export Format"::CA:
                                BEGIN
                                    ExportPaymentsRB.StartExportFile(BankAccountNo, "Gen. Journal Line");
                                    ACHFileCreated := TRUE;
                                END;
                            BankAccount."Export Format"::MX:
                                BEGIN
                                    ExportPaymentsCecoban.StartExportFile(BankAccountNo, '');
                                    ExportPaymentsCecoban.StartExportBatch(30, "Source Code", SettleDate);
                                    ACHFileCreated := TRUE;
                                END;
                            ELSE
                                ERROR(Text000,
                                  BankAccount."Export Format",
                                  BankAccount.FIELDCAPTION("Export Format"),
                                  BankAccount.TABLECAPTION,
                                  BankAccountNo);
                        END;
                        BankAccount.GET(BankAccountNo);  // re-read, since StartExportFile changed it.
                    END;
                    IF NOT IATFileCreated AND ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT") THEN BEGIN
                        CASE BankAccount."Export Format" OF
                            BankAccount."Export Format"::US:
                                BEGIN
                                    ExportPaymentsIAT.StartExportFile(BankAccountNo, '');
                                    IATFileCreated := TRUE;
                                END;
                            ELSE
                                ERROR(Text000,
                                  BankAccount."Export Format",
                                  BankAccount.FIELDCAPTION("Export Format"),
                                  BankAccount.TABLECAPTION,
                                  BankAccountNo);
                        END;
                        BankAccount.GET(BankAccountNo);  // re-read, since StartExportFile changed it.
                    END;
                    IF IATFileCreated AND ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT") THEN BEGIN
                        IF IATBatchOpen THEN
                            IF (LastProcessedGenJournalLine."Account Type" <> "Gen. Journal Line"."Account Type") OR
                               (LastProcessedGenJournalLine."Account No." <> "Gen. Journal Line"."Account No.") OR
                               (LastProcessedGenJournalLine."Foreign Exchange Indicator" <> "Gen. Journal Line"."Foreign Exchange Indicator") OR
                               (LastProcessedGenJournalLine."Foreign Exchange Ref.Indicator" <> "Gen. Journal Line"."Foreign Exchange Ref.Indicator") OR
                               (LastProcessedGenJournalLine."Foreign Exchange Reference" <> "Gen. Journal Line"."Foreign Exchange Reference") OR
                               (LastProcessedGenJournalLine."Source Code" <> "Gen. Journal Line"."Source Code")
                            THEN BEGIN
                                ExportPaymentsIAT.EndExportBatch('220');
                                IATBatchOpen := FALSE;
                            END;
                        IF NOT IATBatchOpen THEN BEGIN
                            ExportPaymentsIAT.StartExportBatch("Gen. Journal Line", '220', SettleDate);
                            IATBatchOpen := TRUE;
                        END;
                    END;
                END;

                IF BankAccountIs = BankAccountIs::Acnt THEN BEGIN
                    ExportAmount := "Amount (LCY)";
                    IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN BEGIN
                        PayeeType := PayeeType::Vendor;
                        Vendor.GET("Bal. Account No.");
                    END ELSE
                        IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN BEGIN
                            PayeeType := PayeeType::Customer;
                            Customer.GET("Bal. Account No.");
                        END ELSE
                            ERROR(Text001,
                              FIELDCAPTION("Bal. Account Type"), Customer.TABLECAPTION, Vendor.TABLECAPTION);
                END ELSE BEGIN
                    ExportAmount := -"Amount (LCY)";
                    IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                        PayeeType := PayeeType::Vendor;
                        Vendor.GET("Account No.");
                    END ELSE
                        IF "Account Type" = "Account Type"::Customer THEN BEGIN
                            PayeeType := PayeeType::Customer;
                            Customer.GET("Account No.");
                        END ELSE
                            ERROR(Text001,
                              FIELDCAPTION("Account Type"), Customer.TABLECAPTION, Vendor.TABLECAPTION);
                END;

                DiscountTaken := 0;
                AmountPaid := 0;
                TotalAmountPaid := 0;
                IF PayeeType = PayeeType::Vendor THEN BEGIN
                    FormatAddress.Vendor(PayeeAddress, Vendor);
                    VendBankAccount.SETRANGE("Vendor No.", Vendor."No.");
                    VendBankAccount.SETRANGE("Use for Electronic Payments", TRUE);
                    IF VendBankAccount.COUNT <> 1 THEN
                        ERROR(Text002,
                          VendBankAccount.TABLECAPTION, VendBankAccount.FIELDCAPTION("Use for Electronic Payments"),
                          Vendor.TABLECAPTION, Vendor."No.");
                    VendBankAccount.FINDFIRST;
                    PayeeBankTransitNo := VendBankAccount."Transit No.";
                    PayeeBankAccountNo := VendBankAccount."Bank Account No.";
                    IF "Applies-to Doc. No." <> '' THEN BEGIN
                        VendLedgEntry.RESET;
                        VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                        VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                        VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                        VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
                        VendLedgEntry.SETRANGE(Open, TRUE);
                        VendLedgEntry.FINDFIRST;
                        VendLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                        IF (VendLedgEntry."Pmt. Discount Date" >= SettleDate) AND
                           (VendLedgEntry."Remaining Pmt. Disc. Possible" <> 0) AND
                           (-(ExportAmount + VendLedgEntry."Remaining Pmt. Disc. Possible") >= -VendLedgEntry."Amount to Apply")
                        THEN BEGIN
                            DiscountTaken := -VendLedgEntry."Remaining Pmt. Disc. Possible";
                            AmountPaid := -(VendLedgEntry."Amount to Apply" - VendLedgEntry."Remaining Pmt. Disc. Possible");
                        END ELSE
                            IF -ExportAmount > -VendLedgEntry."Amount to Apply" THEN
                                AmountPaid := -VendLedgEntry."Amount to Apply"
                            ELSE
                                AmountPaid := -ExportAmount;
                    END;
                END ELSE BEGIN
                    FormatAddress.Customer(PayeeAddress, Customer);
                    CustBankAccount.SETRANGE("Customer No.", Customer."No.");
                    CustBankAccount.SETRANGE("Use for Electronic Payments", TRUE);
                    IF CustBankAccount.COUNT <> 1 THEN
                        ERROR(Text002,
                          CustBankAccount.TABLECAPTION, CustBankAccount.FIELDCAPTION("Use for Electronic Payments"),
                          Customer.TABLECAPTION, Customer."No.");
                    CustBankAccount.FINDFIRST;
                    PayeeBankTransitNo := CustBankAccount."Transit No.";
                    PayeeBankAccountNo := CustBankAccount."Bank Account No.";
                    IF "Applies-to Doc. No." <> '' THEN BEGIN
                        CustLedgEntry.RESET;
                        CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                        CustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                        CustLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                        CustLedgEntry.SETRANGE("Customer No.", Customer."No.");
                        CustLedgEntry.SETRANGE(Open, TRUE);
                        CustLedgEntry.FINDFIRST;
                        CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                        IF (CustLedgEntry."Pmt. Discount Date" >= SettleDate) AND
                           (CustLedgEntry."Remaining Pmt. Disc. Possible" <> 0) AND
                           (-(ExportAmount - CustLedgEntry."Remaining Pmt. Disc. Possible") >= -CustLedgEntry."Amount to Apply")
                        THEN BEGIN
                            DiscountTaken := -CustLedgEntry."Remaining Pmt. Disc. Possible";
                            AmountPaid := -(CustLedgEntry."Amount to Apply" - CustLedgEntry."Remaining Pmt. Disc. Possible");
                        END ELSE
                            IF -ExportAmount > -CustLedgEntry."Amount to Apply" THEN
                                AmountPaid := -CustLedgEntry."Amount to Apply"
                            ELSE
                                AmountPaid := -ExportAmount;
                    END;
                END;
                TotalAmountPaid := AmountPaid;

                IF (NOT CurrReport.PREVIEW) AND (NOT MailSkip) THEN BEGIN //CSPH1
                    CASE BankAccount."Export Format" OF
                        BankAccount."Export Format"::US:
                            BEGIN
                                IF "Bank Payment Type" = "Bank Payment Type"::"Electronic Payment" THEN
                                    TraceNumber := ExportPaymentsACH.ExportElectronicPayment("Gen. Journal Line", ExportAmount)
                                ELSE
                                    TraceNumber := ExportPaymentsIAT.ExportElectronicPayment("Gen. Journal Line", ExportAmount);
                            END;
                        BankAccount."Export Format"::CA:
                            TraceNumber := ExportPaymentsRB.ExportElectronicPayment("Gen. Journal Line", ExportAmount, SettleDate);
                        BankAccount."Export Format"::MX:
                            TraceNumber := ExportPaymentsCecoban.ExportElectronicPayment("Gen. Journal Line", ExportAmount, SettleDate);
                    END;

                    IF TraceNumber <> '' THEN BEGIN
                        "Posting Date" := SettleDate;
                        "Check Printed" := TRUE;
                        "Check Exported" := TRUE;
                        "Export File Name" := BankAccount."Last E-Pay Export File Name";
                        "Exported to Payment File" := TRUE;
                        BankAccount."Last Remittance Advice No." := INCSTR(BankAccount."Last Remittance Advice No.");
                        "Document No." := BankAccount."Last Remittance Advice No.";
                        MODIFY;
                        InsertIntoCheckLedger(TraceNumber, -ExportAmount);
                    END;
                END;
                LastProcessedGenJournalLine := "Gen. Journal Line";
            end;

            trigger OnPostDataItem()
            begin
                IF NOT MailSkip THEN BEGIN //CSPH1
                    IF ACHFileCreated THEN BEGIN
                        BankAccount.MODIFY;
                        CASE BankAccount."Export Format" OF
                            BankAccount."Export Format"::US:
                                BEGIN
                                    ExportPaymentsACH.EndExportBatch('220');
                                    IF NOT ExportPaymentsACH.EndExportFile THEN
                                        ERROR(USText002);
                                END;
                            BankAccount."Export Format"::CA:
                                ExportPaymentsRB.EndExportFile;
                            BankAccount."Export Format"::MX:
                                BEGIN
                                    ExportPaymentsCecoban.EndExportBatch;
                                    ExportPaymentsCecoban.EndExportFile;
                                END;
                        END;
                    END;
                    IF IATFileCreated THEN BEGIN
                        BankAccount.MODIFY;
                        IF IATBatchOpen THEN BEGIN
                            ExportPaymentsIAT.EndExportBatch('220');
                            IATBatchOpen := FALSE;
                        END;

                        IF NOT ExportPaymentsIAT.EndExportFile THEN
                            ERROR(USText002);
                    END;
                END; //CSPH1
            end;

            trigger OnPreDataItem()
            begin
                ACHFileCreated := FALSE;
                IATFileCreated := FALSE;
                IATBatchOpen := FALSE;
                CLEAR(LastProcessedGenJournalLine);
                IF PostingDateOption = PostingDateOption::"Skip Lines Which Do Not Match" THEN
                    SETRANGE("Posting Date", SettleDate);
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
                    field(BankAccountNo; BankAccountNo)
                    {
                        Caption = 'Bank Account No.';
                        ApplicationArea = all;
                        TableRelation = "Bank Account";
                    }
                    field(SettleDate; SettleDate)
                    {
                        Caption = 'Settle Date';
                        ApplicationArea = all;
                    }
                    field(PostingDateOption; PostingDateOption)
                    {
                        ApplicationArea = all;
                        Caption = 'If Posting Date does not match Settle Date:';
                        OptionCaption = 'Change Posting Date To Match,Skip Lines Which Do Not Match';
                    }
                    field(NumberOfCopies; NoCopies)
                    {
                        ApplicationArea = all;
                        Caption = 'Number of Copies';
                        MaxValue = 9;
                        MinValue = 0;
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        ApplicationArea = all;
                        Caption = 'Print Company Address';
                    }
                    field(NeedEmail; NeedEmail)
                    {
                        ApplicationArea = all;
                        Caption = 'Send Remittance Advice to Vendor';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            //SettleDate := 0D;
            MailSkip := true;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        GenLine: Record "Gen. Journal Line";
        GenLine1: Record "Gen. Journal Line";
        VendorNo: Code[20];
        RPTExportRemit: Report "Export E-Pay TO PDF";
        //LOGSendEmail: Codeunit 50001;
        //Emailfile: Text;
        //attchmentname: Text;
        //isprint: Boolean;
        XmlParameters: Text;
    begin
        //XmlParameters := RPTExportRemit.RunRequestPage();
        //Message(XmlParameters);
        //exit;
        //CSPH1 BEGIN
        IF NOT NeedEmail THEN
            EXIT;

        CLEAR(VendorNo);

        GenLine.RESET;
        //GenLine.COPYFILTERS("Gen. Journal Line");
        GenLine.SETRANGE(GenLine."Journal Template Name", "Gen. Journal Line"."Journal Template Name");
        GenLine.SETRANGE(GenLine."Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
        GenLine.SETRANGE("Posting Date", "Gen. Journal Line"."Posting Date");
        GenLine.SETCURRENTKEY("Account Type", "Account No.");

        IF GenLine.FINDFIRST AND (NOT CurrReport.PREVIEW) THEN
            REPEAT
                IF (VendorNo <> GenLine."Account No.") THEN BEGIN
                    VendorNo := GenLine."Account No.";

                    GenLine1.COPYFILTERS(GenLine);
                    GenLine1.SETCURRENTKEY("Account Type", "Account No.");
                    GenLine1.SETRANGE("Account No.", VendorNo);
                    /*bobby
                                        CLEAR(RPTExportRemit);
                                        RPTExportRemit.SetMailSkip(TRUE, SettleDate, BankAccountNo, PostingDateOption, PrintCompany);
                                        RPTExportRemit.SETTABLEVIEW(GenLine1);

                                        attchmentname := FORMAT(CREATEDATETIME(TODAY, TIME), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');
                                        Emailfile := BankAccount."E-Pay Export File Path" + 'Remittance_' + VendorNo + '_' + attchmentname + '.PDF';
                                        attchmentname := 'Remittance_' + VendorNo + '_' + attchmentname + '.PDF';

                                        RPTExportRemit.SAVEASPDF(Emailfile);
                                        //Send Email with file
                                        Vendor.GET(VendorNo);
                                        IF FILE.EXISTS(Emailfile) THEN
                                            LOGSendEmail.SendEmail('Remittance Advice from ' + CompanyInformation.Name, attchmentname, Emailfile, Vendor."E-Mail");
                                        //send email end
                                        */

                END;
            UNTIL GenLine.NEXT = 0;
        //CSPH1 END
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
        GenJournalTemplate.GET("Gen. Journal Line".GETFILTER("Journal Template Name"));

        IF SettleDate = 0D THEN
            ERROR(Text003);

        IF NOT CurrReport.PREVIEW THEN
            BankAccount.LOCKTABLE;
        BankAccount.GET(BankAccountNo);
        BankAccount.TESTFIELD(Blocked, FALSE);
        BankAccount.TESTFIELD("Currency Code", '');
        // local currency only
        BankAccount.TESTFIELD("Export Format");
        BankAccount.TESTFIELD("Last Remittance Advice No.");

        GenJournalTemplate.GET("Gen. Journal Line".GETFILTER("Journal Template Name"));
        IF NOT GenJournalTemplate."Force Doc. Balance" THEN
            IF NOT CONFIRM(USText001, TRUE) THEN
                ERROR(USText002);

        IF PrintCompany THEN
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        ELSE
            CLEAR(CompanyAddress);
    end;

    var
        CompanyInformation: Record "Company Information";
        GenJournalTemplate: Record "Gen. Journal Template";
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        CustBankAccount: Record "Customer Bank Account";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vendor: Record Vendor;
        VendBankAccount: Record "Vendor Bank Account";
        VendLedgEntry: Record "Vendor Ledger Entry";
        LastProcessedGenJournalLine: Record "Gen. Journal Line";
        ExportPaymentsACH: Codeunit "Export Payments (ACH)";
        ExportPaymentsIAT: Codeunit "Export Payments (IAT)";
        ExportPaymentsRB: Codeunit "Export Payments (RB)";
        ExportPaymentsCecoban: Codeunit "Export Payments (Cecoban)";
        CheckManagement: Codeunit CheckManagement;
        FormatAddress: Codeunit "Format Address";
        ACHFileCreated: Boolean;
        IATFileCreated: Boolean;
        IATBatchOpen: Boolean;
        ExportAmount: Decimal;
        TraceNumber: Code[30];
        BankAccountIs: Option Acnt,BalAcnt;
        SettleDate: Date;
        PostingDateOption: Option "Change Posting Date To Match","Skip Lines Which Do Not Match";
        NoCopies: Integer;
        CopyTxt: Code[10];
        PrintCompany: Boolean;
        CompanyAddress: array[8] of Text[50];
        PayeeAddress: array[8] of Text[50];
        PayeeType: Option Vendor,Customer;
        PayeeBankTransitNo: Text[30];
        PayeeBankAccountNo: Text[30];
        DiscountTaken: Decimal;
        AmountPaid: Decimal;
        TotalAmountPaid: Decimal;
        Text000: Label '%1 is not a valid %2 in %3 %4.';
        Text001: Label 'For Electronic Payments, the %1 must be %2 or %3.';
        Text002: Label 'You must have exactly one %1 with %2 checked for %3 %4.';
        Text003: Label 'You MUST enter a Settle Date.';
        Text005: Label 'COPY';
        USText001: Label 'Warning:  Transactions cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?';
        USText002: Label 'Process canceled at user request.';
        myType: Integer;
        SaveAmountPaid: Decimal;
        REMITTANCE_ADVICECaptionLbl: Label 'REMITTANCE ADVICE';
        To_CaptionLbl: Label 'To:';
        Remittance_Advice_Number_CaptionLbl: Label 'Remittance Advice Number:';
        Settlement_Date_CaptionLbl: Label 'Settlement Date:';
        Page_CaptionLbl: Label 'Page:';
        ExportAmountCaptionLbl: Label 'Deposit Amount:';
        PayeeBankTransitNoCaptionLbl: Label 'Bank Transit No:';
        Deposited_In_CaptionLbl: Label 'Deposited In:';
        PayeeBankAccountNoCaptionLbl: Label 'Bank Account No:';
        Remaining_Amt___LCY___Control36CaptionLbl: Label 'Amount Due';
        DiscountTaken_Control38CaptionLbl: Label 'Discount Taken';
        AmountPaid_Control43CaptionLbl: Label 'Amount Paid';
        Text004Lbl: Label 'Unapplied Amount';
        NeedEmail: Boolean;
        MailSkip: Boolean;
        BankAccountNo: Code[20];

    procedure InsertIntoCheckLedger(Trace: Code[30]; Amt: Decimal)
    var
        CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        CheckLedgerEntry.INIT;
        CheckLedgerEntry."Bank Account No." := BankAccountNo;
        CheckLedgerEntry."Posting Date" := SettleDate;
        CheckLedgerEntry."Document Type" := "Gen. Journal Line"."Document Type";
        CheckLedgerEntry."Document No." := "Gen. Journal Line"."Document No.";
        CheckLedgerEntry.Description := "Gen. Journal Line".Description;
        CheckLedgerEntry."Bank Payment Type" := CheckLedgerEntry."Bank Payment Type"::"Electronic Payment";
        CheckLedgerEntry."Entry Status" := CheckLedgerEntry."Entry Status"::Exported;
        CheckLedgerEntry."Check Date" := SettleDate;
        CheckLedgerEntry."Check No." := "Gen. Journal Line"."Document No.";
        IF BankAccountIs = BankAccountIs::Acnt THEN BEGIN
            CheckLedgerEntry."Bal. Account Type" := "Gen. Journal Line"."Bal. Account Type";
            CheckLedgerEntry."Bal. Account No." := "Gen. Journal Line"."Bal. Account No.";
        END ELSE BEGIN
            CheckLedgerEntry."Bal. Account Type" := "Gen. Journal Line"."Account Type";
            CheckLedgerEntry."Bal. Account No." := "Gen. Journal Line"."Account No.";
        END;
        CheckLedgerEntry."Trace No." := Trace;
        CheckLedgerEntry."Transmission File Name" := "Gen. Journal Line"."Export File Name";
        CheckLedgerEntry.Amount := Amt;
        CheckManagement.InsertCheck(CheckLedgerEntry, "Gen. Journal Line".RecordId);
    end;

    procedure SetMailSkip(Skip: Boolean; SetDate: Date; BankActNo: Code[20]; PstDatOption: Option "Change Posting Date To Match","Skip Lines Which Do Not Match"; PrtCompany: Boolean)
    begin
        MailSkip := Skip;
        SettleDate := SetDate;
        BankAccountNo := BankActNo;
        PostingDateOption := PstDatOption;
        PrintCompany := PrtCompany;
        NeedEmail := FALSE;
        NoCopies := 0;
    end;
}

