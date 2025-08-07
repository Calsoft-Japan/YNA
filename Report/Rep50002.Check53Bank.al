report 50002 "Check 53 Bank"
{
    // =================================================================================
    // Ver.No.     Date         Sign.  ID              Description
    // ---------------------------------------------------------------------------------
    // CSPH1       2015-06-23   Kenya  N/A             Check for Fifth Third Bank
    // CSPH1       2015-11-18   Lewis  FDD209             change the layout and add a report.
    // CSPH1       2015-11-26   Tony   FDD206          Print Payment Detail to a Separate Paper
    // =================================================================================
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Check 53 Bank.rdlc';

    Caption = 'Check';

    dataset
    {
        dataitem(VoidGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;

            trigger OnPreDataItem()
            begin
                //IF CurrReport.PREVIEW THEN
                //  ERROR(Text000);

                IF UseCheckNo = '' THEN
                    ERROR(Text001);

                //IF TestPrint THEN
                //  CurrReport.BREAK;

                //IF NOT ReprintChecks THEN
                //  CurrReport.BREAK;

                IF (GETFILTER("Line No.") <> '') OR (GETFILTER("Document No.") <> '') THEN
                    ERROR(
                      Text002, FIELDCAPTION("Line No."), FIELDCAPTION("Document No."));
                SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SETRANGE("Check Printed", TRUE);
            end;
        }
        dataitem(GenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            column(GenJnlLine_Journal_Template_Name; "Journal Template Name")
            {
            }
            column(GenJnlLine_Journal_Batch_Name; "Journal Batch Name")
            {
            }
            column(GenJnlLine_Line_No_; "Line No.")
            {
            }
            dataitem(CheckPages; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PrintSettledLoop; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 10;

                    trigger OnAfterGetRecord()
                    var
                        VLE: Record "Vendor Ledger Entry";
                    begin

                        IF NOT TestPrint THEN BEGIN
                            IF FoundLast THEN BEGIN
                                IF RemainingAmount <> 0 THEN BEGIN
                                    DocType := Text015;
                                    DocNo := '';
                                    LineAmount := RemainingAmount;
                                    //LineAmount2 := RemainingAmount;       //NA0004
                                    LineDiscount := 0;
                                    RemainingAmount := 0;
                                    //FDD209 begin
                                    singleExternalDocno := '';
                                    SingleVLEDescription := '';
                                    //FDD209 end;

                                END ELSE
                                    CurrReport.BREAK;
                            END ELSE BEGIN
                                //FDD209 begin
                                singleExternalDocno := '';
                                SingleVLEDescription := '';
                                //FDD209 end;
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustLedgEntry.RESET;
                                                        CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                                                        CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                        CustLedgEntry.FIND('-');
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendLedgEntry.RESET;
                                                        VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                                                        VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                        VendLedgEntry.FIND('-');
                                                        // FDD209 ADD hcj
                                                        DocNo := VendLedgEntry."Document No.";// GenJnlLine."Applies-to Doc. No.";
                                                        singleExternalDocno := VendLedgEntry."External Document No.";//GenJnlLine."External Document No.";
                                                        SingleVLEDescription := VendLedgEntry.Description;
                                                        // FDD209 end

                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount;
                                            FoundLast := TRUE;
                                        END;
                                    ApplyMethod::OneLineID:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                        FoundLast := (CustLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            CustLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT CustLedgEntry.FIND('-');
                                                            FoundNegative := TRUE;
                                                        END;
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                        FoundLast := (VendLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            VendLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT VendLedgEntry.FIND('-');
                                                            FoundNegative := TRUE;
                                                        END;
                                                        //FoundLast := true; //hcj  0524
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount;
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        BEGIN
                                            CurrentLineAmount := GenJnlLine2.Amount;
                                            //LineAmount2 := CurrentLineAmount;  //NA0004
                                            IF GenJnlLine2."Applies-to ID" <> '' THEN
                                                ERROR(
                                                  Text016 +
                                                  Text017);
                                            GenJnlLine2.TESTFIELD("Check Printed", FALSE);
                                            GenJnlLine2.TESTFIELD("Bank Payment Type", GenJnlLine2."Bank Payment Type"::"Computer Check");

                                            IF GenJnlLine2."Applies-to Doc. No." = '' THEN BEGIN
                                                DocType := Text015;
                                                DocNo := '';
                                                LineAmount := CurrentLineAmount;
                                                LineDiscount := 0;
                                            END ELSE BEGIN
                                                CASE BalancingType OF
                                                    BalancingType::"G/L Account":
                                                        BEGIN
                                                            DocType := FORMAT(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        END;
                                                    BalancingType::Customer:
                                                        BEGIN
                                                            CustLedgEntry.RESET;
                                                            CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
                                                            CustLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            CustLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                            CustLedgEntry.FIND('-');
                                                            CustUpdateAmounts(CustLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        END;
                                                    BalancingType::Vendor:
                                                        BEGIN
                                                            VendLedgEntry.RESET;
                                                            VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                                                            VendLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            VendLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                            VendLedgEntry.FIND('-');
                                                            VendUpdateAmounts(VendLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                            // FDD209 ADD hcj
                                                            DocNo := VendLedgEntry."Document No.";// GenJnlLine2."Applies-to Doc. No.";
                                                            singleExternalDocno := VendLedgEntry."External Document No.";//GenJnlLine2."External Document No.";
                                                            SingleVLEDescription := VendLedgEntry.Description
                                                            // FDD209 end
                                                        END;
                                                    BalancingType::"Bank Account":
                                                        BEGIN
                                                            DocType := FORMAT(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        END;
                                                END;
                                            END;
                                            FoundLast := GenJnlLine2.NEXT = 0;
                                        END;
                                END;
                            END;
                            TotalLineAmount := TotalLineAmount + LineAmount;
                            TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        END ELSE BEGIN
                            IF FoundLast THEN
                                CurrReport.BREAK;
                            FoundLast := TRUE;
                            DocType := Text018;
                            DocNo := Text010;
                            LineAmount := 0;
                            LineDiscount := 0;
                        END;


                        // FDD206 check the VLE first
                        dhbCopyIndex := dhbCopyIndex + 1;
                        IF dhbCopyIndex <= 10 THEN BEGIN
                            dhbCopyDocumentDate[dhbCopyIndex] := DocDate;
                            dhbCopyLineDiscount[dhbCopyIndex] := LineDiscount;
                            dhbCopyLineAmount[dhbCopyIndex] := LineAmount;
                            IF STRLEN(singleExternalDocno) <= 20 THEN
                                dhbCopyDocumentNo[dhbCopyIndex] := singleExternalDocno
                            ELSE
                                dhbCopyDocumentNo[dhbCopyIndex] := COPYSTR(singleExternalDocno, 1, STRLEN(singleExternalDocno) - 15); //docNo
                            ExternalDocno[dhbCopyIndex] := DocNo;  //singleExternalDocno
                            VLEDescription[dhbCopyIndex] := COPYSTR(SingleVLEDescription, 1, 9)
                        END
                        ELSE BEGIN
                            IF dhbCopyIndex = 11 THEN BEGIN
                                FOR i := 1 TO 10 DO BEGIN
                                    dhbCopyDocumentDate[i] := 0D;
                                    dhbCopyLineDiscount[i] := 0;
                                    dhbCopyLineAmount[i] := 0;
                                    dhbCopyDocumentNo[i] := '';
                                    ExternalDocno[i] := '';
                                    VLEDescription[i] := '';
                                END;
                            END;
                        END;


                        //CSPH1 FDD206 BEGIN
                        GenJnlLine_Detail.INIT;
                        GenJnlLine_Detail."Line No." := myLineNo;
                        GenJnlLine_Detail.Amount := LineAmount;
                        GenJnlLine_Detail."Debit Amount" := LineDiscount;
                        GenJnlLine_Detail."Journal Template Name" := GenJnlLine."Journal Template Name";
                        GenJnlLine_Detail."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                        GenJnlLine_Detail."Account No." := myVendorNo;
                        GenJnlLine_Detail."Document No." := myVCHR;
                        GenJnlLine_Detail.Description := myDesc;
                        IF STRLEN(singleExternalDocno) <= 20 THEN
                            GenJnlLine_Detail."External Document No." := singleExternalDocno// DocNo;
                        ELSE
                            GenJnlLine_Detail."External Document No." := COPYSTR(singleExternalDocno, 1, STRLEN(singleExternalDocno) - 15);
                        GenJnlLine_Detail."Posting Date" := DocDate;
                        GenJnlLine_Detail.INSERT;
                        myLineNo := myLineNo + 1000;
                        //CSPH1 END
                    end;

                    trigger OnPreDataItem()
                    var
                        VLE: Record "Vendor Ledger Entry";
                    begin

                        IF NOT TestPrint THEN
                            IF FirstPage THEN BEGIN
                                FoundLast := TRUE;
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        FoundLast := FALSE;
                                    ApplyMethod::OneLineID:
                                        CASE BalancingType OF
                                            BalancingType::Customer:
                                                BEGIN
                                                    CustLedgEntry.RESET;
                                                    CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive);
                                                    CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                    CustLedgEntry.SETRANGE(Open, TRUE);
                                                    CustLedgEntry.SETRANGE(Positive, TRUE);
                                                    CustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT CustLedgEntry.FIND('-');
                                                    IF FoundLast THEN BEGIN
                                                        CustLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT CustLedgEntry.FIND('-');
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                            BalancingType::Vendor:
                                                BEGIN
                                                    VendLedgEntry.RESET;
                                                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                                                    VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                    VendLedgEntry.SETRANGE(Open, TRUE);
                                                    VendLedgEntry.SETRANGE(Positive, TRUE);
                                                    VendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT VendLedgEntry.FIND('-');
                                                    IF FoundLast THEN BEGIN
                                                        VendLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT VendLedgEntry.FIND('-');
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        FoundLast := FALSE;
                                END;
                            END
                            ELSE
                                FoundLast := FALSE;


                        IF NOT PreprintedStub THEN
                            TotalText := Text019
                        ELSE
                            TotalText := '';

                        isPrintself := TRUE;
                        IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
                            // FDD206 check the VLE first
                            VLE.RESET;
                            VLE.SETRANGE(VLE."Vendor No.", BalancingNo);
                            VLE.SETRANGE(VLE."Applies-to ID", GenJnlLine."Applies-to ID");
                            IF VLE.FIND('-') THEN BEGIN
                                IF VLE.COUNT > 10 THEN BEGIN
                                    isPrintself := FALSE;

                                END;
                            END;
                        END;
                    end;
                }
                dataitem(PrintCheck; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(CheckAmountText; CheckAmountText)
                    {
                    }
                    column(CheckDateText; CheckDateText)
                    {
                    }
                    column(DescriptionLine_2_; DescriptionLine[2])
                    {
                    }
                    column(DescriptionLine_1_; DescriptionLine[1])
                    {
                    }
                    column(CheckToAddr_1_; CheckToAddr[1])
                    {
                    }
                    column(CheckToAddr_2_; CheckToAddr[2])
                    {
                    }
                    column(CheckToAddr_4_; CheckToAddr[4])
                    {
                    }
                    column(CheckToAddr_3_; CheckToAddr[3])
                    {
                    }
                    column(CheckToAddr_5_; CheckToAddr[5])
                    {
                    }
                    column(VoidText; VoidText)
                    {
                    }
                    column(Receiptmessage; Receiptmessage)
                    {
                    }
                    column(CheckNoText; CheckNoText)
                    {
                    }
                    column(CheckDateText_Control1000000058; CheckDateText)
                    {
                    }
                    column(CheckToAddr_1__Control1000000059; CheckToAddr[1])
                    {
                    }
                    column(dhbCopyLineAmount_1_; dhbCopyLineAmount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_1_; dhbCopyLineDiscount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_1____dhbCopyLineDiscount_1_; dhbCopyLineAmount[1] + dhbCopyLineDiscount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_1_; dhbCopyDocumentDate[1])
                    {
                    }
                    column(dhbCopyDocumentNo_1_; dhbCopyDocumentNo[1])
                    {
                    }
                    column(dhbCopyLineAmount_2_; dhbCopyLineAmount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_2_; dhbCopyLineDiscount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_2____dhbCopyLineDiscount_2_; dhbCopyLineAmount[2] + dhbCopyLineDiscount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_2_; dhbCopyDocumentDate[2])
                    {
                    }
                    column(dhbCopyDocumentNo_2_; dhbCopyDocumentNo[2])
                    {
                    }
                    column(dhbCopyLineAmount_3_; dhbCopyLineAmount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_3_; dhbCopyLineDiscount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_3____dhbCopyLineDiscount_3_; dhbCopyLineAmount[3] + dhbCopyLineDiscount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_3_; dhbCopyDocumentDate[3])
                    {
                    }
                    column(dhbCopyDocumentNo_3_; dhbCopyDocumentNo[3])
                    {
                    }
                    column(dhbCopyLineAmount_4_; dhbCopyLineAmount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_4_; dhbCopyLineDiscount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_4____dhbCopyLineDiscount_4_; dhbCopyLineAmount[4] + dhbCopyLineDiscount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_4_; dhbCopyDocumentDate[4])
                    {
                    }
                    column(dhbCopyDocumentNo_4_; dhbCopyDocumentNo[4])
                    {
                    }
                    column(dhbCopyLineAmount_5_; dhbCopyLineAmount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_5_; dhbCopyLineDiscount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_5____dhbCopyLineDiscount_5_; dhbCopyLineAmount[5] + dhbCopyLineDiscount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_5_; dhbCopyDocumentDate[5])
                    {
                    }
                    column(dhbCopyDocumentNo_5_; dhbCopyDocumentNo[5])
                    {
                    }
                    column(dhbCopyLineAmount_6_; dhbCopyLineAmount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_6_; dhbCopyLineDiscount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_6____dhbCopyLineDiscount_6_; dhbCopyLineAmount[6] + dhbCopyLineDiscount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_6_; dhbCopyDocumentDate[6])
                    {
                    }
                    column(dhbCopyDocumentNo_6_; dhbCopyDocumentNo[6])
                    {
                    }
                    column(dhbCopyLineAmount_7____dhbCopyLineDiscount_7_; dhbCopyLineAmount[7] + dhbCopyLineDiscount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_7_; dhbCopyLineDiscount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_7_; dhbCopyLineAmount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_7_; dhbCopyDocumentDate[7])
                    {
                    }
                    column(dhbCopyDocumentNo_7_; dhbCopyDocumentNo[7])
                    {
                    }
                    column(dhbCopyLineAmount_8____dhbCopyLineDiscount_8_; dhbCopyLineAmount[8] + dhbCopyLineDiscount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_8_; dhbCopyLineDiscount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_8_; dhbCopyLineAmount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_8_; dhbCopyDocumentDate[8])
                    {
                    }
                    column(dhbCopyDocumentNo_8_; dhbCopyDocumentNo[8])
                    {
                    }
                    column(dhbCopyLineAmount_9____dhbCopyLineDiscount_9_; dhbCopyLineAmount[9] + dhbCopyLineDiscount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_9_; dhbCopyLineDiscount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_9_; dhbCopyLineAmount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_9_; dhbCopyDocumentDate[9])
                    {
                    }
                    column(dhbCopyDocumentNo_9_; dhbCopyDocumentNo[9])
                    {
                    }
                    column(dhbCopyDocumentDate_10_; dhbCopyDocumentDate[10])
                    {
                    }
                    column(dhbCopyLineAmount_10____dhbCopyLineDiscount_10_; dhbCopyLineAmount[10] + dhbCopyLineDiscount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_10_; dhbCopyLineDiscount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_10_; dhbCopyLineAmount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentNo_10_; dhbCopyDocumentNo[10])
                    {
                    }
                    column(TotalLineAmount; TotalLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(TotalLineAmount_Control1000000112; TotalLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText_Control1000000113; TotalText)
                    {
                    }
                    column(dhbCopyDocumentDate_10__Control1000000114; dhbCopyDocumentDate[10])
                    {
                    }
                    column(dhbCopyLineAmount_10____dhbCopyLineDiscount_10__Control1000000115; dhbCopyLineAmount[10] + dhbCopyLineDiscount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_10__Control1000000116; dhbCopyLineDiscount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_10__Control1000000117; dhbCopyLineAmount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_9____dhbCopyLineDiscount_9__Control1000000118; dhbCopyLineAmount[9] + dhbCopyLineDiscount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_9__Control1000000119; dhbCopyLineDiscount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_9__Control1000000120; dhbCopyLineAmount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_9__Control1000000121; dhbCopyDocumentDate[9])
                    {
                    }
                    column(dhbCopyLineAmount_8____dhbCopyLineDiscount_8__Control1000000122; dhbCopyLineAmount[8] + dhbCopyLineDiscount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_8__Control1000000123; dhbCopyLineDiscount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_8__Control1000000124; dhbCopyLineAmount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_8__Control1000000125; dhbCopyDocumentDate[8])
                    {
                    }
                    column(dhbCopyDocumentNo_8__Control1000000126; dhbCopyDocumentNo[8])
                    {
                    }
                    column(dhbCopyDocumentNo_9__Control1000000127; dhbCopyDocumentNo[9])
                    {
                    }
                    column(dhbCopyDocumentNo_10__Control1000000128; dhbCopyDocumentNo[10])
                    {
                    }
                    column(dhbCopyLineAmount_7____dhbCopyLineDiscount_7__Control1000000129; dhbCopyLineAmount[7] + dhbCopyLineDiscount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_7__Control1000000130; dhbCopyLineDiscount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_7__Control1000000131; dhbCopyLineAmount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_7__Control1000000132; dhbCopyDocumentDate[7])
                    {
                    }
                    column(dhbCopyDocumentNo_7__Control1000000133; dhbCopyDocumentNo[7])
                    {
                    }
                    column(dhbCopyLineAmount_6__Control1000000134; dhbCopyLineAmount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_6__Control1000000135; dhbCopyLineDiscount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_6____dhbCopyLineDiscount_6__Control1000000136; dhbCopyLineAmount[6] + dhbCopyLineDiscount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_6__Control1000000137; dhbCopyDocumentDate[6])
                    {
                    }
                    column(dhbCopyDocumentNo_6__Control1000000138; dhbCopyDocumentNo[6])
                    {
                    }
                    column(dhbCopyLineAmount_5__Control1000000139; dhbCopyLineAmount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_5__Control1000000140; dhbCopyLineDiscount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_5____dhbCopyLineDiscount_5__Control1000000141; dhbCopyLineAmount[5] + dhbCopyLineDiscount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_5__Control1000000142; dhbCopyDocumentDate[5])
                    {
                    }
                    column(dhbCopyDocumentNo_5__Control1000000143; dhbCopyDocumentNo[5])
                    {
                    }
                    column(dhbCopyLineAmount_4__Control1000000144; dhbCopyLineAmount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_4__Control1000000145; dhbCopyLineDiscount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_4____dhbCopyLineDiscount_4__Control1000000146; dhbCopyLineAmount[4] + dhbCopyLineDiscount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_4__Control1000000147; dhbCopyDocumentDate[4])
                    {
                    }
                    column(dhbCopyDocumentNo_4__Control1000000148; dhbCopyDocumentNo[4])
                    {
                    }
                    column(dhbCopyLineAmount_3__Control1000000149; dhbCopyLineAmount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_3__Control1000000150; dhbCopyLineDiscount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_3____dhbCopyLineDiscount_3__Control1000000151; dhbCopyLineAmount[3] + dhbCopyLineDiscount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_3__Control1000000152; dhbCopyDocumentDate[3])
                    {
                    }
                    column(dhbCopyDocumentNo_3__Control1000000153; dhbCopyDocumentNo[3])
                    {
                    }
                    column(dhbCopyLineAmount_2__Control1000000154; dhbCopyLineAmount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_2__Control1000000155; dhbCopyLineDiscount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_2____dhbCopyLineDiscount_2__Control1000000156; dhbCopyLineAmount[2] + dhbCopyLineDiscount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_2__Control1000000157; dhbCopyDocumentDate[2])
                    {
                    }
                    column(dhbCopyDocumentNo_2__Control1000000158; dhbCopyDocumentNo[2])
                    {
                    }
                    column(dhbCopyLineAmount_1__Control1000000159; dhbCopyLineAmount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineDiscount_1__Control1000000160; dhbCopyLineDiscount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyLineAmount_1____dhbCopyLineDiscount_1__Control1000000161; dhbCopyLineAmount[1] + dhbCopyLineDiscount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(dhbCopyDocumentDate_1__Control1000000162; dhbCopyDocumentDate[1])
                    {
                    }
                    column(dhbCopyDocumentNo_1__Control1000000163; dhbCopyDocumentNo[1])
                    {
                    }
                    column(CheckNoText_Control1000000169; CheckNoText)
                    {
                    }
                    column(CheckDateText_Control1000000171; CheckDateText)
                    {
                    }
                    column(CheckToAddr_1__Control1000000172; CheckToAddr[1])
                    {
                    }
                    column(CheckToAddr_1__Control1000000000; CheckToAddr[1])
                    {
                    }
                    column(CheckNoTextCaption; CheckNoTextCaptionLbl)
                    {
                    }
                    column(dhbCopyLineAmount_10_Caption; dhbCopyLineAmount_10_CaptionLbl)
                    {
                    }
                    column(dhbCopyLineDiscount_10_Caption; dhbCopyLineDiscount_10_CaptionLbl)
                    {
                    }
                    column(AmountCaption; AmountCaptionLbl)
                    {
                    }
                    column(dhbCopyDocumentNo_10_Caption; dhbCopyDocumentNo_10_CaptionLbl)
                    {
                    }
                    column(dhbCopyDocumentDate_10_Caption; dhbCopyDocumentDate_10_CaptionLbl)
                    {
                    }
                    column(dhbCopyLineAmount_10__Control1000000117Caption; dhbCopyLineAmount_10__Control1000000117CaptionLbl)
                    {
                    }
                    column(dhbCopyLineDiscount_10__Control1000000116Caption; dhbCopyLineDiscount_10__Control1000000116CaptionLbl)
                    {
                    }
                    column(AmountCaption_Control1000000166; AmountCaption_Control1000000166Lbl)
                    {
                    }
                    column(dhbCopyDocumentNo_10__Control1000000128Caption; dhbCopyDocumentNo_10__Control1000000128CaptionLbl)
                    {
                    }
                    column(dhbCopyDocumentDate_10__Control1000000114Caption; dhbCopyDocumentDate_10__Control1000000114CaptionLbl)
                    {
                    }
                    column(CheckNoText_Control1000000169Caption; CheckNoText_Control1000000169CaptionLbl)
                    {
                    }
                    column(PrintCheck_Number; Number)
                    {
                    }
                    column(ChecktoVendorName; VendorName)
                    {
                    }
                    column(ChecktoVendorNo; BalancingNo)
                    {
                    }
                    column(ExternalDocNo_1_; ExternalDocno[1])
                    {
                    }
                    column(VLEDescription_1_; VLEDescription[1])
                    {
                    }
                    column(ExternalDocNo_2_; ExternalDocno[2])
                    {
                    }
                    column(VLEDescription_2_; VLEDescription[2])
                    {
                    }
                    column(ExternalDocNo_3_; ExternalDocno[3])
                    {
                    }
                    column(VLEDescription_3_; VLEDescription[3])
                    {
                    }
                    column(ExternalDocNo_4_; ExternalDocno[4])
                    {
                    }
                    column(VLEDescription_4_; VLEDescription[4])
                    {
                    }
                    column(ExternalDocNo_5_; ExternalDocno[5])
                    {
                    }
                    column(VLEDescription_5_; VLEDescription[5])
                    {
                    }
                    column(ExternalDocNo_6_; ExternalDocno[6])
                    {
                    }
                    column(VLEDescription_6_; VLEDescription[6])
                    {
                    }
                    column(ExternalDocNo_7_; ExternalDocno[7])
                    {
                    }
                    column(VLEDescription_7_; VLEDescription[7])
                    {
                    }
                    column(ExternalDocNo_8_; ExternalDocno[8])
                    {
                    }
                    column(VLEDescription_8_; VLEDescription[8])
                    {
                    }
                    column(ExternalDocNo_9_; ExternalDocno[9])
                    {
                    }
                    column(VLEDescription_9_; VLEDescription[9])
                    {
                    }
                    column(ExternalDocNo_10_; ExternalDocno[10])
                    {
                    }
                    column(VLEDescription_10_; VLEDescription[10])
                    {
                    }
                    column(PrintMyself; isPrintself)
                    {
                    }
                    column(FoundLast; FoundLast)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF NOT TestPrint THEN BEGIN
                            CheckLedgEntry.INIT;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Document Type" := GenJnlLine."Document Type";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := CheckToAddr[1];
                            CheckLedgEntry."Bank Payment Type" := GenJnlLine."Bank Payment Type";
                            CheckLedgEntry."Bal. Account Type" := BalancingType;
                            CheckLedgEntry."Bal. Account No." := BalancingNo;
                            IF FoundLast THEN BEGIN
                                IF TotalLineAmount < 0 THEN
                                    ERROR(
                                      Text020,
                                      UseCheckNo, TotalLineAmount);
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Printed;
                                CheckLedgEntry.Amount := TotalLineAmount;
                            END ELSE BEGIN
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Voided;
                                CheckLedgEntry.Amount := 0;
                            END;
                            CheckLedgEntry."Check Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, GenJnlLine.RecordId);

                            IF FoundLast THEN BEGIN
                                CheckAmountText := FORMAT(CheckLedgEntry.Amount, 0);
                                //CSPH1 add hcj 0820
                                Receiptmessage := GenJnlLine."Message to Recipient";
                                //CSPH1 add end
                                i := STRPOS(CheckAmountText, '.');
                                CASE TRUE OF
                                    i = 0:
                                        CheckAmountText := CheckAmountText + '.00';
                                    i = STRLEN(CheckAmountText) - 1:
                                        CheckAmountText := CheckAmountText + '0';
                                    i > STRLEN(CheckAmountText) - 2:
                                        CheckAmountText := COPYSTR(CheckAmountText, 1, i + 2);
                                END;
                                // FDD209 add * to CheckAmountText hcj
                                WHILE STRLEN(CheckAmountText) < 16 DO BEGIN
                                    CheckAmountText := '*' + CheckAmountText;
                                END;
                                // FDD209 add end
                                FormatNoText(DescriptionLine, CheckLedgEntry.Amount, BankAcc2."Currency Code");
                                VoidText := '';
                            END ELSE BEGIN
                                //FDD209 COMMENT THEM OUT
                                //      CLEAR(CheckAmountText);
                                //      CLEAR(DescriptionLine);
                                //      CLEAR(Receiptmessage);
                                //      DescriptionLine[1] := Text021;
                                //      DescriptionLine[2] := DescriptionLine[1];
                                //      VoidText := Text022;
                                //FDD209 END
                            END;
                        END ELSE BEGIN
                            CheckLedgEntry.INIT;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := Text023;
                            CheckLedgEntry."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check";
                            CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::"Test Print";
                            CheckLedgEntry."Check Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, GenJnlLine.RecordId);

                            CheckAmountText := Text024;
                            Receiptmessage := '';
                            DescriptionLine[1] := Text025;
                            DescriptionLine[2] := DescriptionLine[1];
                            VoidText := Text022;
                        END;

                        ChecksPrinted := ChecksPrinted + 1;
                        FirstPage := FALSE;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    IF FoundLast THEN
                        CurrReport.BREAK;

                    //dhb Start - Clear all array variables for the 2nd Stub - Victor 12/03/04
                    dhbCopyIndex := 0;
                    CLEAR(dhbCopyDocumentNo);
                    CLEAR(dhbCopyLineAmount);
                    CLEAR(dhbCopyLineDiscount);
                    CLEAR(dhbCopyDocumentDate);
                    //FDD209
                    CLEAR(ExternalDocno);
                    CLEAR(VLEDescription);
                    //FDD209 end
                    //dhb End - Clear all array variables for the 2nd Stub - Victor 12/03/04


                    dhbCheckNumberWithPad := '';
                    //dhbNumOfPadChar := BankAcc2."Check Number Width" - STRLEN(CheckNoText);
                    FOR i := 1 TO dhbNumOfPadChar DO
                        dhbCheckNumberWithPad := dhbCheckNumberWithPad + dhbPadChar;
                    dhbCheckNumberWithPad := dhbCheckNumberWithPad + CheckNoText;
                end;

                trigger OnPostDataItem()
                var
                    VendorNo: Code[20];
                begin

                    IF NOT TestPrint THEN BEGIN
                        IF UseCheckNo <> GenJnlLine."Document No." THEN BEGIN
                            GenJnlLine3.RESET;
                            GenJnlLine3.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3.SETRANGE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3.SETRANGE("Document No.", UseCheckNo);
                            IF GenJnlLine3.FIND('-') THEN
                                GenJnlLine3.FIELDERROR("Document No.", STRSUBSTNO(Text013, UseCheckNo));
                        END;

                        IF ApplyMethod <> ApplyMethod::MoreLinesOneEntry THEN BEGIN
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.TESTFIELD("Posting No. Series", '');
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Check Printed" := TRUE;
                            GenJnlLine3.MODIFY;
                        END ELSE BEGIN
                            "TotalLineAmount$" := 0;
                            IF GenJnlLine2.FIND('-') THEN BEGIN
                                HighestLineNo := GenJnlLine2."Line No.";
                                REPEAT
                                    IF GenJnlLine2."Line No." > HighestLineNo THEN
                                        HighestLineNo := GenJnlLine2."Line No.";
                                    GenJnlLine3 := GenJnlLine2;
                                    GenJnlLine3.TESTFIELD("Posting No. Series", '');
                                    GenJnlLine3."Bal. Account No." := '';
                                    GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::" ";
                                    GenJnlLine3."Document No." := UseCheckNo;
                                    GenJnlLine3."Check Printed" := TRUE;
                                    GenJnlLine3.VALIDATE(Amount);
                                    "TotalLineAmount$" := "TotalLineAmount$" + GenJnlLine3."Amount (LCY)";
                                    GenJnlLine3.MODIFY;
                                UNTIL GenJnlLine2.NEXT = 0;
                            END;

                            GenJnlLine3.RESET;
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3."Line No." := HighestLineNo;
                            IF GenJnlLine3.NEXT = 0 THEN
                                GenJnlLine3."Line No." := HighestLineNo + 10000
                            ELSE BEGIN
                                WHILE GenJnlLine3."Line No." = HighestLineNo + 1 DO BEGIN
                                    HighestLineNo := GenJnlLine3."Line No.";
                                    IF GenJnlLine3.NEXT = 0 THEN
                                        GenJnlLine3."Line No." := HighestLineNo + 20000;
                                END;
                                GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) DIV 2;
                            END;
                            GenJnlLine3.INIT;
                            GenJnlLine3.VALIDATE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::"Bank Account";
                            GenJnlLine3.VALIDATE("Account No.", BankAcc2."No.");
                            IF BalancingType <> BalancingType::"G/L Account" THEN
                                GenJnlLine3.Description := STRSUBSTNO(Text014, BalancingType, BalancingNo);
                            GenJnlLine3.VALIDATE(Amount, -TotalLineAmount);
                            IF TotalLineAmount <> "TotalLineAmount$" THEN
                                GenJnlLine3.VALIDATE("Amount (LCY)", -"TotalLineAmount$");
                            GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::"Computer Check";
                            GenJnlLine3."Check Printed" := TRUE;
                            GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                            GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                            GenJnlLine3."Allow Zero-Amount Posting" := TRUE;
                            GenJnlLine3.INSERT;
                        END;
                    END;

                    BankAcc2."Last Check No." := UseCheckNo;
                    BankAcc2.MODIFY;
                    IF CommitEachCheck THEN BEGIN
                        COMMIT;
                        CLEAR(CheckManagement);
                    END;



                    //CSPH1 FDD206 BEGIN
                    IF (GenJnlLine_Detail.COUNT > 10) AND FoundLast THEN BEGIN
                        COMMIT;

                        NoDataReportIIndex := NoDataReportIIndex + 1;
                        GenJnlLine_Detail.RESET;
                        IF GenJnlLine_Detail.FIND('-') THEN BEGIN
                            REPEAT
                                TempGenJnlLine.INIT;
                                TempGenJnlLine := GenJnlLine_Detail;
                                TempGenJnlLine.INSERT;
                            UNTIL GenJnlLine_Detail.NEXT = 0;

                        END;

                        NoDataReport[NoDataReportIIndex].SetReportData(CheckNoText,
                                                      CheckAmountText,
                                                      DescriptionLine,
                                                      CheckToAddr,
                                                      Receiptmessage,
                                                      VoidText,
                                                      TotalLineAmount,
                                                      VendorName,
                                                     BalancingNo);
                        //NoDataReport.RUN;


                    END;
                    GenJnlLine_Detail.DELETEALL;
                    //CSPH1 END
                end;

                trigger OnPreDataItem()
                begin
                    FirstPage := TRUE;
                    FoundLast := FALSE;
                    TotalLineAmount := 0;
                    TotalLineDiscount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF OneCheckPrVendor AND (GenJnlLine."Currency Code" <> '') AND
                   (GenJnlLine."Currency Code" <> Currency.Code)
                THEN BEGIN
                    Currency.GET(GenJnlLine."Currency Code");
                    Currency.TESTFIELD("Conv. LCY Rndg. Debit Acc.");
                    Currency.TESTFIELD("Conv. LCY Rndg. Credit Acc.");
                END;

                IF NOT TestPrint THEN BEGIN
                    IF Amount = 0 THEN
                        CurrReport.SKIP;


                    TESTFIELD("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                    IF "Bal. Account No." <> BankAcc2."No." THEN
                        CurrReport.SKIP;

                    //FDD206 move to here from Checkprint
                    UseCheckNo := INCSTR(UseCheckNo);
                    IF NOT TestPrint THEN
                        CheckNoText := UseCheckNo
                    ELSE
                        CheckNoText := Text011;
                    //


                    IF ("Account No." <> '') AND ("Bal. Account No." <> '') THEN BEGIN
                        BalancingType := "Account Type";
                        BalancingNo := "Account No.";
                        RemainingAmount := Amount;
                        IF OneCheckPrVendor THEN BEGIN
                            ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                            GenJnlLine2.RESET;
                            GenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine2.SETRANGE("Journal Template Name", "Journal Template Name");
                            GenJnlLine2.SETRANGE("Journal Batch Name", "Journal Batch Name");
                            GenJnlLine2.SETRANGE("Posting Date", "Posting Date");
                            GenJnlLine2.SETRANGE("Document No.", "Document No.");
                            GenJnlLine2.SETRANGE("Account Type", "Account Type");
                            GenJnlLine2.SETRANGE("Account No.", "Account No.");
                            GenJnlLine2.SETRANGE("Bal. Account Type", "Bal. Account Type");
                            GenJnlLine2.SETRANGE("Bal. Account No.", "Bal. Account No.");
                            GenJnlLine2.SETRANGE("Bank Payment Type", "Bank Payment Type");
                            GenJnlLine2.FIND('-');
                            RemainingAmount := 0;
                        END ELSE
                            IF "Applies-to Doc. No." <> '' THEN
                                ApplyMethod := ApplyMethod::OneLineOneEntry
                            ELSE
                                IF "Applies-to ID" <> '' THEN
                                    ApplyMethod := ApplyMethod::OneLineID
                                ELSE
                                    ApplyMethod := ApplyMethod::Payment;
                    END ELSE
                        IF "Account No." = '' THEN
                            FIELDERROR("Account No.", Text004)
                        ELSE
                            FIELDERROR("Bal. Account No.", Text004);

                    CLEAR(CheckToAddr);
                    ContactText := '';
                    CLEAR(SalesPurchPerson);
                    CASE BalancingType OF
                        BalancingType::"G/L Account":
                            BEGIN
                                CheckToAddr[1] := GenJnlLine.Description;
                            END;
                        BalancingType::Customer:
                            BEGIN
                                Cust.GET(BalancingNo);
                                IF Cust.Blocked = Cust.Blocked::All THEN
                                    ERROR(USText003, Cust.FIELDCAPTION(Blocked), Cust.Blocked, Cust.TABLECAPTION, Cust."No.");
                                Cust.Contact := '';
                                FormatAddr.Customer(CheckToAddr, Cust);
                                IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                    ERROR(Text005);
                                IF Cust."Salesperson Code" <> '' THEN BEGIN
                                    ContactText := Text006;
                                    SalesPurchPerson.GET(Cust."Salesperson Code");
                                END;
                            END;
                        BalancingType::Vendor:
                            BEGIN
                                Vend.GET(BalancingNo);
                                // FDD209 add Vendor name begin
                                VendorName := Vend.Name;
                                // add vendor name end

                                IF Vend.Blocked IN [Vend.Blocked::All, Vend.Blocked::Payment] THEN
                                    ERROR(USText003, Vend.FIELDCAPTION(Blocked), Vend.Blocked, Vend.TABLECAPTION, Vend."No.");
                                Vend.Contact := '';

                                CheckToAddr[1] := GenJnlLine.Description;

                                // dhb-THF 12/18/2007 use one vendor for many checks
                                //        IF Vend."Use Invoice Address" THEN BEGIN
                                //          dhbPurchInvHeader.GET(GenJnlLine."Applies-to Doc. No.");
                                //          FormatAddr.dhbCheckToInvoiceAddress(CheckToAddr,dhbPurchInvHeader);
                                //        END ELSE
                                FormatAddr.Vendor(CheckToAddr, Vend);
                                // dhb-THF 12/18/2007 use one vendor for many checks

                                IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                    ERROR(Text005);
                                IF Vend."Purchaser Code" <> '' THEN BEGIN
                                    ContactText := Text007;
                                    SalesPurchPerson.GET(Vend."Purchaser Code");
                                END;
                            END;
                        BalancingType::"Bank Account":
                            BEGIN
                                BankAcc.GET(BalancingNo);
                                BankAcc.TESTFIELD(Blocked, FALSE);
                                BankAcc.Contact := '';
                                FormatAddr.BankAcc(CheckToAddr, BankAcc);
                                IF BankAcc2."Currency Code" <> BankAcc."Currency Code" THEN
                                    ERROR(Text008);
                                IF BankAcc."Our Contact Code" <> '' THEN BEGIN
                                    ContactText := Text009;
                                    SalesPurchPerson.GET(BankAcc."Our Contact Code");
                                END;
                            END;
                    END;
                    //Original code 1116. comment it out for FDD209
                    // CheckDateText := FORMAT("Posting Date",0,4);
                    // comment it out end.

                    CheckDateText := FORMAT(TODAY, 0, '<Closing><Month,2>/<Day,2>/<Year4>');

                END ELSE BEGIN
                    IF ChecksPrinted > 0 THEN
                        CurrReport.BREAK;
                    BalancingType := BalancingType::Vendor;
                    BalancingNo := Text010;
                    CLEAR(CheckToAddr);
                    FOR i := 1 TO 5 DO
                        CheckToAddr[i] := Text003;
                    ContactText := '';
                    CLEAR(SalesPurchPerson);
                    CheckNoText := Text011;
                    CheckDateText := Text012;
                END;
            end;

            trigger OnPreDataItem()
            begin
                GenJnlLine.COPY(VoidGenJnlLine);
                CompanyInfo.GET;
                IF NOT TestPrint THEN BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                    BankAcc2.GET(BankAcc2."No.");
                    BankAcc2.TESTFIELD(Blocked, FALSE);
                    COPY(VoidGenJnlLine);
                    SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                    SETRANGE("Check Printed", FALSE);
                END ELSE BEGIN
                    CLEAR(CompanyAddr);
                    FOR i := 1 TO 5 DO
                        CompanyAddr[i] := Text003;
                END;
                ChecksPrinted := 0;

                SETRANGE("Account Type", GenJnlLine."Account Type"::"Fixed Asset");
                IF FIND('-') THEN
                    GenJnlLine.FIELDERROR("Account Type");
                SETRANGE("Account Type");
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
                    field(BankAcc2No; BankAcc2."No.")
                    {
                        Caption = 'Bank Account';
                        TableRelation = "Bank Account";
                        ApplicationArea = Basic, Suite;
                        trigger OnValidate()
                        begin
                            IF BankAcc2."No." <> '' THEN BEGIN
                                BankAcc2.GET(BankAcc2."No.");
                                BankAcc2.TESTFIELD("Last Check No.");
                                UseCheckNo := BankAcc2."Last Check No.";
                            END;
                        end;
                    }
                    field(UseCheckNo; UseCheckNo)
                    {
                        Caption = 'Last Check No.';
                        ApplicationArea = Basic, Suite;
                    }
                    field(OneCheckPrVendor; OneCheckPrVendor)
                    {
                        Caption = 'One Check per Vendor';
                        ApplicationArea = Basic, Suite;
                    }
                    field(ReprintChecks; ReprintChecks)
                    {
                        Caption = 'Void and Reprint Checks';
                        ApplicationArea = Basic, Suite;
                    }
                    field(TestPrint; TestPrint)
                    {
                        Caption = 'Test Print';
                        Visible = false;
                        ApplicationArea = Basic, Suite;
                    }
                    field(PreprintedStub; PreprintedStub)
                    {
                        Caption = 'Preprinted Stub';
                        Visible = false;
                        ApplicationArea = Basic, Suite;
                    }
                    field(CommitEachCheck; CommitEachCheck)
                    {
                        Caption = 'Commit Each Check';
                        Visible = false;
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF BankAcc2."No." <> '' THEN BEGIN
                IF BankAcc2.GET(BankAcc2."No.") THEN
                    UseCheckNo := BankAcc2."Last Check No."
                ELSE BEGIN
                    BankAcc2."No." := '';
                    UseCheckNo := '';
                END;
            END;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        //CSPH1 FDD206 BEGIN
        myLineNo := 1000;
        GenJnlLine_Detail.DELETEALL;
        TempGenJnlLine.DELETEALL;
        NoDataReportIIndex := 0;
        //CSPH1 END
    end;

    trigger OnPostReport()
    var
        i: Integer;
    begin


        COMMIT;

        //FOR i:= 1 TO NoDataReportIIndex  DO
        //BEGIN
        //  NoDataReport[i].RUN;
        //END;

        TempGenJnlLine.RESET;
        IF TempGenJnlLine.FIND('-') THEN BEGIN
            RemittanceAdvice.SetGenJournalLine(TempGenJnlLine);
            RemittanceAdvice.RUN;
        END;
    end;

    trigger OnPreReport()
    begin
        InitTextVariable;
        IF UseCheckNo = '' THEN
            ERROR('Last Check No. must not be blank');
        IF INCSTR(UseCheckNo) = '' THEN
            ERROR('Last Check No. must include at least one digit, so that it can be incremented.');

        GenJnlTemplate.GET(VoidGenJnlLine.GETFILTER("Journal Template Name"));
        IF NOT GenJnlTemplate."Force Doc. Balance" THEN
            IF NOT CONFIRM(USText001, TRUE) THEN
                ERROR(USText002);
    end;

    var
        Text000: Label 'Preview is not allowed.';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: Label 'Salesperson';
        Text007: Label 'Purchaser';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text009: Label 'Our Contact';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text015: Label 'Payment';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: Label 'XXX';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        GenJnlTemplate: Record "Gen. Journal Template";
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        CompanyAddr: array[8] of Text[50];
        CheckToAddr: array[8] of Text[50];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        //BalancingType: Option "G/L Account",Customer,Vendor,"Bank Account";
        BalancingType: Enum "Gen. Journal Account Type";
        BalancingNo: Code[20];
        ContactText: Text[30];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[132];
        DocType: Text[30];
        DocNo: Text[35];
        VoidText: Text[30];
        Receiptmessage: Text[140];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        "TotalLineAmount$": Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        CommitEachCheck: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        PreprintedStub: Boolean;
        TotalText: Text[10];
        DocDate: Date;
        i: Integer;
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        USText001: Label 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?';
        USText002: Label 'Process cancelled at user request.';
        USText003: Label '%1 must not be %2 on %3 %4.';
        dhbMicr: Text[100];
        dhbCheckNumberWithPad: Text[30];
        dhbNumOfPadChar: Integer;
        dhbPadChar: Text[1];
        dhbCopyIndex: Integer;
        dhbCopyDocumentDate: array[50] of Date;
        dhbCopyLineDiscount: array[50] of Decimal;
        dhbCopyLineAmount: array[50] of Decimal;
        dhbCopyDocumentNo: array[50] of Text[35];
        dhbPurchInvHeader: Record "Purch. Inv. Header";
        CheckNoTextCaptionLbl: Label 'Check No.';
        dhbCopyLineAmount_10_CaptionLbl: Label 'Net Amount';
        dhbCopyLineDiscount_10_CaptionLbl: Label 'Discount';
        AmountCaptionLbl: Label 'Amount';
        dhbCopyDocumentNo_10_CaptionLbl: Label 'Invoice No.';
        dhbCopyDocumentDate_10_CaptionLbl: Label 'Inv. Date';
        dhbCopyLineAmount_10__Control1000000117CaptionLbl: Label 'Net Amount';
        dhbCopyLineDiscount_10__Control1000000116CaptionLbl: Label 'Discount';
        AmountCaption_Control1000000166Lbl: Label 'Amount';
        dhbCopyDocumentNo_10__Control1000000128CaptionLbl: Label 'Invoice No.';
        dhbCopyDocumentDate_10__Control1000000114CaptionLbl: Label 'Document Date';
        CheckNoText_Control1000000169CaptionLbl: Label 'Check No.';
        VendorName: Text[50];
        ExternalDocno: array[50] of Code[35];
        VLEDescription: array[50] of Text[100];
        singleExternalDocno: Code[35];
        SingleVLEDescription: Text[100];
        GenJnlLine_Detail: Record "Gen. Journal Line" temporary;
        myLineNo: Integer;
        RemittanceAdvice: Report "Remittance Advice";
        myVCHR: Code[20];
        myDesc: Text[62];
        myVendorNo: Code[20];
        NoDataReport: array[20] of Report "Check 53 NoData";
        NoDataReportIIndex: Integer;
        isPrintself: Boolean;
        TempGenJnlLine: Record "Gen. Journal Line" temporary;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        // add hcj FDD209
        WHILE STRLEN(NoText[NoTextIndex]) <= 54 DO BEGIN
            NoText[NoTextIndex] := NoText[NoTextIndex] + '*';
        END;
        // add end.

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    local procedure CustUpdateAmounts(var CustLedgEntry2: Record "Cust. Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
            GenJnlLine3.RESET;
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Customer);
            GenJnlLine3.SETRANGE("Account No.", CustLedgEntry2."Customer No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", CustLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", CustLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FIND('-') THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        Text030,
                        CustLedgEntry2."Document Type", CustLedgEntry2."Document No.",
                        CustLedgEntry2."Customer No."));
        END;

        DocType := FORMAT(CustLedgEntry2."Document Type");
        // T20141001.0030 Begin
        DocNo := CustLedgEntry2."Document No.";// CustLedgEntry2."External Document No.";
        // T20141001.0030 End
        DocDate := CustLedgEntry2."Document Date";

        CustLedgEntry2.CALCFIELDS("Remaining Amount");

        IF (CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) AND
           (GenJnlLine."Posting Date" <= CustLedgEntry."Pmt. Discount Date") AND
           (CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible" <= RemainingAmount2)
        THEN BEGIN
            LineAmount := CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible";
            LineDiscount := CustLedgEntry2."Remaining Pmt. Disc. Possible";
        END ELSE BEGIN
            IF CustLedgEntry2."Remaining Amount" <= RemainingAmount2 THEN
                LineAmount := CustLedgEntry2."Remaining Amount"
            ELSE
                LineAmount := RemainingAmount2;
            LineDiscount := 0;
        END;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
            GenJnlLine3.RESET;
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Vendor);
            GenJnlLine3.SETRANGE("Account No.", VendLedgEntry2."Vendor No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FIND('-') THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        Text031,
                        VendLedgEntry2."Document Type", VendLedgEntry2."Document No.",
                        VendLedgEntry2."Vendor No."));
        END;

        DocType := FORMAT(VendLedgEntry2."Document Type");
        DocNo := VendLedgEntry2."Document No."; //VendLedgEntry2."External Document No.";
        singleExternalDocno := VendLedgEntry2."External Document No.";
        SingleVLEDescription := VendLedgEntry2.Description;     // add hcj 07182016
        DocDate := VendLedgEntry2."Document Date";
        VendLedgEntry2.CALCFIELDS("Remaining Amount");

        //CSPH1 FDD206 BEGIN
        myVCHR := VendLedgEntry2."Document No.";
        myDesc := VendLedgEntry2.Description;
        myVendorNo := VendLedgEntry2."Vendor No.";
        //CSPH1 END


        IF (VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::Invoice) AND
           (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date") AND
           (-(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible") <= RemainingAmount2)
        THEN BEGIN
            LineAmount := -(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible");
            LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
        END ELSE BEGIN
            IF -VendLedgEntry2."Remaining Amount" <= RemainingAmount2 THEN
                LineAmount := -VendLedgEntry2."Remaining Amount"
            ELSE
                LineAmount := RemainingAmount2;
            LineDiscount := 0;
        END;
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure InitializeRequest(BankAcc: Code[20]; LastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean)
    begin
        IF BankAcc <> '' THEN
            IF BankAcc2.GET(BankAcc) THEN BEGIN
                UseCheckNo := LastCheckNo;
                OneCheckPrVendor := NewOneCheckPrVend;
                ReprintChecks := NewReprintChecks;
                TestPrint := NewTestPrint;
                PreprintedStub := NewPreprintedStub;
            END;
    end;
}

