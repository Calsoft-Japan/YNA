xmlport 50004 ImportGenJournalImport
{
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    PreserveWhiteSpace = true;

    schema
    {
        textelement(DocumentElement)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'JNtable';
                UseTemporary = true;
                textelement(JournalTemplateName)
                {
                    MinOccurs = Zero;

                    trigger OnAfterAssignVariable()
                    begin
                        JournalTemplateName := DELCHR(JournalTemplateName, '>', ' ');
                    end;
                }
                textelement(JournalBatchName)
                {
                    MinOccurs = Zero;

                    trigger OnAfterAssignVariable()
                    begin
                        JournalBatchName := DELCHR(JournalBatchName, '>', ' ');
                    end;
                }
                textelement(accounttype)
                {
                    MinOccurs = Zero;
                    XmlName = 'AccountType';
                }
                fieldelement(AccountNo; "Gen. Journal Line"."Account No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(AccountSubCode; "Gen. Journal Line"."Account Sub-code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(PostingDate; "Gen. Journal Line"."Posting Date")
                {
                    MinOccurs = Zero;
                }
                textelement(documenttype)
                {
                    MinOccurs = Zero;
                    XmlName = 'DocumentType';
                }
                fieldelement(documentNo; "Gen. Journal Line"."Document No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(documentDate; "Gen. Journal Line"."Document Date")
                {
                    MinOccurs = Zero;
                }
                textelement(bal_account_type)
                {
                    XmlName = 'BalAccountType';
                }
                fieldelement(BalAccountNo; "Gen. Journal Line"."Bal. Account No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(CurrencyCode; "Gen. Journal Line"."Currency Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Amount; "Gen. Journal Line".Amount)
                {
                    MinOccurs = Zero;
                }
                fieldelement(PaymentTermsCode; "Gen. Journal Line"."Payment Terms Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ExternalDocNo; "Gen. Journal Line"."External Document No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(AmountLCY; "Gen. Journal Line"."Amount (LCY)")
                {
                    MinOccurs = Zero;
                }
                fieldelement(APARAccountNo; "Gen. Journal Line"."AP/AR Account No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ItemNo; "Gen. Journal Line"."Item No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(itemdescription; "Gen. Journal Line"."Item Description")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Type; "Gen. Journal Line".Type)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Size; "Gen. Journal Line".Size)
                {
                    MinOccurs = Zero;
                }
                fieldelement(CustomerNo; "Gen. Journal Line"."Customer No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Unitprice; "Gen. Journal Line"."Unit Price")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Quantity; "Gen. Journal Line".Quantity)
                {
                    MinOccurs = Zero;
                }
                fieldelement(SystemCode; "Gen. Journal Line"."System Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(VoucherGroupcode; "Gen. Journal Line"."Voucher Group Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(description; "Gen. Journal Line".Description)
                {
                    MinOccurs = Zero;
                }
                fieldelement(description2; "Gen. Journal Line"."Description 2")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Duedate; "Gen. Journal Line"."Due Date")
                {
                    MinOccurs = Zero;
                }
                fieldelement(departmentCode; "Gen. Journal Line"."Department Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ReceiptDate; "Gen. Journal Line"."Receipt Date")
                {
                    MinOccurs = Zero;
                }
                fieldelement(OriginalReceiptNo; "Gen. Journal Line"."Original Receipt No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(originalDocumentno; "Gen. Journal Line"."Original Document No.")
                {
                    MinOccurs = Zero;
                }
                textelement(strdecrmemo)
                {
                    MinOccurs = Zero;
                    XmlName = 'printDebitCreditMemo';
                }

                trigger OnBeforeInsertRecord()
                begin
                    "Gen. Journal Line"."Line No." := LineNo;
                    "Gen. Journal Line"."Account No." := DELCHR("Gen. Journal Line"."Account No.", '>', ' ');
                    "Gen. Journal Line"."Account Sub-code" := DELCHR("Gen. Journal Line"."Account Sub-code", '>', ' ');
                    "Gen. Journal Line"."Document No." := DELCHR("Gen. Journal Line"."Document No.", '>', ' ');
                    "Gen. Journal Line"."Bal. Account No." := DELCHR("Gen. Journal Line"."Bal. Account No.", '>', ' ');
                    "Gen. Journal Line"."Currency Code" := DELCHR("Gen. Journal Line"."Currency Code", '>', ' ');
                    "Gen. Journal Line"."Payment Terms Code" := DELCHR("Gen. Journal Line"."Payment Terms Code", '>', ' ');
                    // "Gen. Journal Line"."External Document No." := DELCHR("Gen. Journal Line"."External Document No.",'>',' ');
                    "Gen. Journal Line"."AP/AR Account No." := DELCHR("Gen. Journal Line"."AP/AR Account No.", '>', ' ');
                    "Gen. Journal Line"."Item No." := DELCHR("Gen. Journal Line"."Item No.", '>', ' ');
                    "Gen. Journal Line".Type := DELCHR("Gen. Journal Line".Type, '>', ' ');
                    "Gen. Journal Line".Size := DELCHR("Gen. Journal Line".Size, '>', ' ');
                    "Gen. Journal Line"."Customer No." := DELCHR("Gen. Journal Line"."Customer No.", '>', ' ');
                    "Gen. Journal Line"."System Code" := DELCHR("Gen. Journal Line"."System Code", '>', ' ');
                    "Gen. Journal Line"."Voucher Group Code" := DELCHR("Gen. Journal Line"."Voucher Group Code", '>', ' ');
                    "Gen. Journal Line"."Department Code" := DELCHR("Gen. Journal Line"."Department Code", '>', ' ');
                    "Gen. Journal Line"."Original Document No." := DELCHR("Gen. Journal Line"."Original Document No.", '>', ' ');
                    // "Gen. Journal Line"."Print Debit/Credit Memo" := DELCHR("Gen. Journal Line"."Print Debit/Credit Memo",'>',' ');



                    tempGLE.INIT;
                    tempGLE := "Gen. Journal Line";

                    tempGLE."Line No." := LineNo;

                    tempGLE."Journal Template Name" := JournalTemplateName;
                    tempGLE."Journal Batch Name" := JournalBatchName;

                    CASE UPPERCASE(AccountType) OF
                        '0':
                            BEGIN
                                tempGLE."Account Type" := tempGLE."Account Type"::"G/L Account";
                            END;
                        '1':
                            BEGIN
                                tempGLE."Account Type" := tempGLE."Account Type"::Customer;
                            END;
                        '2':
                            BEGIN
                                tempGLE."Account Type" := tempGLE."Account Type"::Vendor;
                            END;
                    END;

                    CASE UPPERCASE(Bal_Account_Type) OF
                        '0':
                            BEGIN
                                tempGLE."Bal. Account Type" := tempGLE."Bal. Account Type"::"G/L Account";
                            END;
                        '1':
                            BEGIN
                                tempGLE."Bal. Account Type" := tempGLE."Bal. Account Type"::Customer;
                            END;
                        '2':
                            BEGIN
                                tempGLE."Bal. Account Type" := tempGLE."Bal. Account Type"::Vendor;
                            END;
                    END;



                    //Document_type ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund

                    CASE UPPERCASE(DocumentType) OF
                        '':
                            BEGIN
                                tempGLE."Document Type" := tempGLE."Document Type"::" ";
                            END;
                        '1':
                            BEGIN
                                tempGLE."Document Type" := tempGLE."Document Type"::Invoice;
                            END;
                        '3':
                            BEGIN
                                tempGLE."Document Type" := tempGLE."Document Type"::"Credit Memo";
                            END;
                    END;

                    IF strDeCrmemo = '1' THEN BEGIN
                        tempGLE."Print Debit/Credit Memo" := TRUE;
                    END
                    ELSE BEGIN
                        tempGLE."Print Debit/Credit Memo" := FALSE;
                    END;


                    tempGLE.VALIDATE("Account No.");
                    tempGLE."Currency Code" := "Gen. Journal Line"."Currency Code";
                    tempGLE."Amount (LCY)" := "Gen. Journal Line"."Amount (LCY)";

                    tempGLE."Dimension Set ID" := GetLineDimension(tempGLE."Account No.",
                                                              tempGLE."Account Sub-code",
                                                              tempGLE."Department Code",
                                                              FORMAT(tempGLE."Account Type"),
                                                              '', '', '', '', tempGLE."Dimension Set ID");
                    tempGLE."Shortcut Dimension 1 Code" := tempGLE."Department Code";
                    //   tempGLE."Shortcut Dimension 2 Code" := tempGLE."Department Code";
                    IF tempGLE."Document Date" = 0D THEN
                        tempGLE."Document Date" := tempGLE."Posting Date";

                    //for original doc no.
                    //   tempGLE."Applies-to ID" :=tempGLE."Original Document No.";

                    //Source Code
                    GenJnlTemplate.RESET;
                    GenJnlTemplate.SETRANGE(Name, tempGLE."Journal Template Name");
                    IF GenJnlTemplate.FIND('-') THEN
                        tempGLE."Source Code" := GenJnlTemplate."Source Code";

                    tempGLE."Payment Terms Code" := "Gen. Journal Line"."Payment Terms Code";
                    tempGLE."Due Date" := "Gen. Journal Line"."Due Date";

                    tempGLE.INSERT;
                    LineNo := LineNo + 100;
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
    var
        companyinfo: Record "Company Information";
        InterfaceMessage: Codeunit "Interface Message";
    begin
        LineNo := 100;

        companyinfo.RESET;
        companyinfo.FINDFIRST;
        LogFileName := companyinfo."File Path" + '\Log\GL';
    end;

    trigger OnPostXmlPort()
    var
        Currency: Record Currency;
        PaymentTerms: Record "Payment Terms";
        Importtype: Integer;
        DimControl: Codeunit GLobalsDimContrel;
        DimTable: Record "Dimension Set Entry" temporary;
        InterfaceMessage: Codeunit "Interface Message";
    begin
        InterfaceMessage.UpdateInterfaceMessage(0, 1, '-----Starting Import GL/AP/AR (' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
        Commit();
        //FileOperator.SaveLogFile(LogFileName, 'Starting import Gen. Journal ',FALSE);
        //FileOperator.SaveLogFile(LogFileName, '-------StartTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME))+' ---------',FALSE);
        //FileOperator.SaveLogFile(LogFileName, '',FALSE);
        ValidateOK := TRUE;
        FailRecCount := 0;

        Importtype := 0; // 0:Gen. journal,  1: Sales Journal  2: Purchase Journal
        IF tempGLE.FINDFIRST THEN BEGIN
            REPEAT
                IF tempGLE."Journal Template Name" = 'SALES' THEN
                    Importtype := 1;
                IF tempGLE."Journal Template Name" = 'PURCHASES' THEN
                    Importtype := 2;
            UNTIL tempGLE.NEXT <= 0;
            tempGLE.FINDFIRST;

            SplitTempGLE(tempGLE, Importtype);
        END;



        AddVendorCodeintoGL(tempGLE);

        EOMinfor := 'OK,';

        AllRecCount := 0;

        creditamount := 0;
        Amount := 0;


        //CreateJBatchName(JBatchName);


        // Validate
        tempGLE.RESET;
        IF tempGLE.FIND('-') THEN BEGIN
            LineNo := GetLastLineNo(tempGLE."Journal Batch Name", tempGLE."Journal Template Name");

            REPEAT
                /* =====
                  IF tempGLE."Journal Template Name" <> journalType THEN
                  BEGIN
                       FileOperator.SaveLogFile(LogFileName, 'Line No.['+FORMAT(tempGLE."Line No.")+'] Journal Template Name Error, '+tempGLE."Journal Template Name"+' is not '+
                       journalType +' this jouranl can''t be imported.',FALSE);
                       ValidateOK := FALSE;
                       FailRecCount+= 1;
                  END;
              ==== */

                IF CheckJBatchName(tempGLE."Journal Batch Name", tempGLE."Journal Template Name") = FALSE THEN BEGIN
                    //FileOperator.SaveLogFile(LogFileName, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Journal Batch Name Error, ' + tempGLE."Journal Batch Name" + ' doesn''t ' +
                    //'existed. ', FALSE);
                    InterfaceMessage.UpdateInterfaceMessage(0, 1, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Journal Batch Name Error, ' + tempGLE."Journal Batch Name" + ' doesn''t existed. ');
                    Commit();
                    ValidateOK := FALSE;
                    FailRecCount += 1;

                END;

                IF CheckAccount(FORMAT(tempGLE."Account Type"), tempGLE."Account No.") = FALSE THEN BEGIN
                    //FileOperator.SaveLogFile(LogFileName, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Account Error, Account No.' + tempGLE."Account No." +
                    //' doesn''t exist. ', FALSE);
                    InterfaceMessage.UpdateInterfaceMessage(0, 1, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Account Error, Account No.' + tempGLE."Account No." + ' doesn''t exist.');
                    Commit();
                    ValidateOK := FALSE;
                    FailRecCount += 1;

                END;

                SureGLE.RESET;
                SureGLE.SETRANGE("Document No.", tempGLE."Document No.");
                IF SureGLE.FIND('-') THEN BEGIN
                    //FileOperator.SaveLogFile(LogFileName, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Account Error, Document No.' + tempGLE."Document No." +
                    //' already exists in the General Journal. ', FALSE);
                    InterfaceMessage.UpdateInterfaceMessage(0, 1, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Account Error, Document No.' + tempGLE."Document No." + ' already exists in the General Journal.');
                    Commit();
                    ValidateOK := FALSE;
                    FailRecCount += 1;

                END;

                IF tempGLE."Payment Terms Code" <> '' THEN BEGIN
                    PaymentTerms.RESET;
                    PaymentTerms.SETRANGE(Code, tempGLE."Payment Terms Code");
                    IF NOT PaymentTerms.FIND('-') THEN BEGIN
                        //FileOperator.SaveLogFile(LogFileName, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Payment Terms Error, Payment Terms ' +
                        //FORMAT(tempGLE."Payment Terms Code") + ' doesn''t existed in the Payment Terms Table. ', FALSE);
                        InterfaceMessage.UpdateInterfaceMessage(0, 1, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Payment Terms Error, Payment Terms ' + FORMAT(tempGLE."Payment Terms Code") + ' doesn''t existed in the Payment Terms Table.');
                        Commit();
                        ValidateOK := FALSE;
                        FailRecCount += 1;

                    END;
                END;

                IF tempGLE."Currency Code" <> '' THEN BEGIN
                    Currency.RESET;
                    Currency.SETRANGE(Code, tempGLE."Currency Code");
                    IF NOT Currency.FIND('-') THEN BEGIN
                        //FileOperator.SaveLogFile(LogFileName, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Currency Code Error, Currency Code ' +
                        //FORMAT(tempGLE."Currency Code") + ' doesn''t exist in the currency Table. ', FALSE);
                        InterfaceMessage.UpdateInterfaceMessage(0, 1, 'Line No.[' + FORMAT(tempGLE."Line No.") + '] Currency Code Error, Currency Code ' + FORMAT(tempGLE."Currency Code") + ' doesn''t exist in the currency Table.');
                        Commit();
                        ValidateOK := FALSE;
                        FailRecCount += 1;

                    END;
                END;

            //tempGLE.MODIFY;

            UNTIL tempGLE.NEXT <= 0;
        END;
        // Validate end.

        //ValidateGenRecord();


        tempGLE.RESET;
        IF (tempGLE.FIND('-')) AND (ValidateOK) THEN BEGIN
            // GenJnlBatch.GET( JTemplatename,JBatchName);
            //tempDocNo := tempGLE."Document No.";
            //  DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series",  tempGLE."Posting Date", TRUE );

            REPEAT
                LineNo := LineNo + 10000;
                GLE.INIT;
                GLE := tempGLE;
                GLE."Line No." := LineNo;


                TempDimension1 := tempGLE."Shortcut Dimension 1 Code";
                TempDimension2 := tempGLE."Shortcut Dimension 2 Code";
                DimID := tempGLE."Dimension Set ID";

                GLE.VALIDATE("Journal Template Name", tempGLE."Journal Template Name");
                GLE.VALIDATE("Journal Batch Name", tempGLE."Journal Batch Name");

                GLE.VALIDATE(GLE."Account No.", tempGLE."Account No.");
                GLE."Bal. Account No." := tempGLE."Bal. Account No.";
                //GLE.VALIDATE(GLE."Bal. Account No.",tempGLE."Bal. Account No.");

                IF tempGLE."Payment Terms Code" <> '' THEN BEGIN
                    GLE."Payment Terms Code" := tempGLE."Payment Terms Code";
                    GLE.VALIDATE("Payment Terms Code", tempGLE."Payment Terms Code");
                END;


                // For new requirement 08042016 hcj
                IF GLE."Account Type" = GLE."Account Type"::"G/L Account" THEN
                    GLE."Applies-to ID" := '';
                // for new requirement end

                // New requirement 08/16/2016, when import sales/purchase if the customer No is not emtpy
                //                               add the value into dimension customerCode/vendorCode
                IF (GLE."Journal Template Name" = 'GENERAL') AND (Importtype > 0) AND (GLE."Customer No." <> '') THEN BEGIN
                    DimTable.DELETEALL;
                    DimTable.INIT;
                    IF Importtype = 1 THEN
                        DimTable."Dimension Code" := 'CUSTOMERCODE'
                    ELSE
                        DimTable."Dimension Code" := 'VENDORCODE';

                    DimTable."Dimension Value Code" := GLE."Customer No.";
                    DimTable.INSERT(TRUE);
                    DimID := DimControl.AddDimensions(DimID, DimTable);

                END;

                // for new requirement end 08/16/2016

                GLE."Dimension Set ID" := DimID;
                GLE.VALIDATE("Dimension Set ID");
                GLE."Shortcut Dimension 1 Code" := TempDimension1;

                //  GLE."Shortcut Dimension 2 Code" :=   TempDimension2;

                //GLE.Description := tempGLE.Description;
                GLE."Currency Code" := tempGLE."Currency Code";
                GLE.VALIDATE("Currency Code", tempGLE."Currency Code");
                GLE.Amount := tempGLE.Amount;
                GLE."Amount (LCY)" := tempGLE."Amount (LCY)";
                GLE."Balance (LCY)" := tempGLE."Amount (LCY)";
                GLE."VAT Base Amount (LCY)" := tempGLE."Amount (LCY)";
                GLE."Bal. VAT Base Amount (LCY)" := tempGLE."Amount (LCY)" * -1;
                IF GLE."Currency Code" <> '' THEN BEGIN
                    IF tempGLE."Amount (LCY)" <> 0 THEN
                        GLE."Currency Factor" := tempGLE.Amount / tempGLE."Amount (LCY)";

                END;
                IF tempGLE."Due Date" <> 0D THEN
                    GLE.VALIDATE("Due Date", tempGLE."Due Date");




                // handle original doc. no.
                IF (GLE."Journal Template Name" = 'PURCHASES') AND (tempGLE."Original Document No." <> '') THEN BEGIN
                    OldVendLedgEntry.RESET;
                    OldVendLedgEntry.SETRANGE(Open, TRUE);
                    OldVendLedgEntry.SETRANGE("Document No.", tempGLE."Original Document No.");
                    OldVendLedgEntry.SETFILTER("Document Type", '<>' + FORMAT(GLE."Document Type"));
                    OldVendLedgEntry.SETFILTER("Posting Date", '<=' + FORMAT(GLE."Posting Date"));
                    IF OldVendLedgEntry.FIND('-') THEN BEGIN
                        ApplyVendorLedgerEntry(OldVendLedgEntry, GLE."Document No.");
                        GLE."Applies-to ID" := GLE."Document No.";
                    END
                    ELSE
                        GLE."Applies-to ID" := '';
                END;
                //  ELSE
                //  GLE."Applies-to ID" := '';


                //handel original doc. no (sales)
                IF (GLE."Journal Template Name" = 'SALES') AND (GLE."Original Document No." <> '')
                    AND (GLE."Document Type" = GLE."Document Type"::"Credit Memo")                      // added hcj by 12052017
                 THEN BEGIN
                    OldCustLedgEntry.RESET;
                    OldCustLedgEntry.SETRANGE(Open, TRUE);
                    OldCustLedgEntry.SETRANGE("Document No.", tempGLE."Original Document No.");
                    OldCustLedgEntry.SETFILTER("Document Type", '<>' + FORMAT(GLE."Document Type"));
                    OldCustLedgEntry.SETFILTER("Posting Date", '<=' + FORMAT(GLE."Posting Date"));
                    IF OldCustLedgEntry.FIND('-') THEN BEGIN
                        ApplyCustLedgerEntry(OldCustLedgEntry, GLE."Document No.");
                        GLE."Applies-to ID" := GLE."Document No.";
                    END
                    ELSE
                        GLE."Applies-to ID" := '';
                END
                ELSE
                    GLE."Applies-to ID" := '';


                // sales end

                GLE.Amount := tempGLE.Amount;
                GLE."Amount (LCY)" := tempGLE."Amount (LCY)";
                GLE."Balance (LCY)" := tempGLE."Amount (LCY)";
                GLE."VAT Base Amount (LCY)" := tempGLE."Amount (LCY)";
                GLE."Bal. VAT Base Amount (LCY)" := tempGLE."Amount (LCY)" * -1;


                // end handle original doc. no.


                IF GLE."Posting Date" <> 0D THEN
                    GLE.INSERT(TRUE);

                AllRecCount := AllRecCount + 1;

            UNTIL tempGLE.NEXT = 0;
            COMMIT;

        END;

        /*
          //posting begin      comment out by CJ.H
          GLE.RESET;
          GLE.SETRANGE("Journal Template Name",JTempLateName);
          GLE.SETRANGE("Journal Batch Name",JBatchName);
          IF GLE.FIND('-')THEN
          BEGIN
            IF ValidateOK THEN
            BEGIN
        
               CLEARLASTERROR;
               //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GLE);
               Code(GLE);
        
               IF STRLEN(GETLASTERRORTEXT)>0 THEN
               BEGIN
                 FileOperator.SaveLogFile(LogFileName, 'General journal Post Error: ' + GETLASTERRORTEXT,FALSE);
                 ValidateOK := FALSE;
                 FailRecCount+= 1;
                 IF GLE.FIND('-') THEN
                 BEGIN
                   REPEAT
                     GLE.DELETE(TRUE);
                   UNTIL GLE.NEXT <=0 ;
                 END;
               END
               ELSE
               BEGIN
               //  EOMinfor := EOMinfor +tempGLE."Account No."+',';
        
               END;
            END
            ELSE
            BEGIN
              REPEAT
                GLE.DELETE(TRUE);
              UNTIL GLE.NEXT <= 0;
            END;
        
         //  UNTIL tempGLE.NEXT = 0;
          END
          ELSE
          BEGIN
        
          END;
        */

        /*
                FileOperator.SaveLogFile(LogFileName, 'Insert Total Count: ' +
                                         FORMAT(AllRecCount, 0) + ',Error Count: ' + FORMAT(FailRecCount, 0), FALSE);
                // FileOperator.SaveLogFile(LogFileName, 'Debit Amount: ' + FORMAT(Amount,0) +' Credit Amount:'+ FORMAT(creditamount,0),FALSE);
                // FileOperator.SaveLogFile(LogFileName, '-------EndTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)),FALSE);
                // FileOperator.SaveLogFile(LogFileName, '',FALSE);


                logFilenameTime := FileOperator.GetLogfile(LogFileName, TRUE);

                FileOperator.SaveLogFile(LogFileName, 'Log file saved in ' + logFilenameTime, FALSE);
                FileOperator.SaveLogFile(LogFileName, '-------EndTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + '----', FALSE);
                FileOperator.SaveLogFile(LogFileName, '', FALSE);


                FileOperator.MoveFile(FileOperator.GetLogfile(LogFileName, FALSE), logFilenameTime, TRUE);
                */
        //InterfaceMessage.UpdateInterfaceMessage(0, 1, '-----End Import GL/AP/AR  (' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
        HYPERLINK(logFilenameTime);

        IF ValidateOK = TRUE THEN BEGIN
            ERROR('OK');
        END
        ELSE BEGIN
            ERROR('ErrorMessage');
        END;

    end;

    var

        tempGLE: Record "Gen. Journal Line" temporary;
        GLE: Record "Gen. Journal Line";
        SureGLE: Record "Gen. Journal Line";
        //FileOperator: Codeunit "50001";
        FailRecCount: Integer;
        Amount: Decimal;
        creditamount: Decimal;
        AllRecCount: Integer;
        ValidateOK: Boolean;
        EOMinfor: Text[1024];
        GLAccount: Record "G/L Account";
        SourceID: Code[20];
        PL: Code[10];
        Customer: Record Customer;
        Vendor: Record Vendor;
        "Bank account": Record "Bank Account";
        "Fixed asset": Record "Fixed Asset";
        "IC partner": Record "IC Partner";
        LogFileName: Text;
        logFilenameTime: Text;
        JBatchName: Code[20];
        JTempLateName: Code[20];
        LineNo: Integer;
        TempDimension1: Code[20];
        TempDimension2: Code[20];
        DimID: Integer;
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
        DimSetEntry: Record "Dimension Set Entry";
        CompanyInformation: Record "Company Information";
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
        BalanceLCY: Decimal;
        AmountLCY: Decimal;
        DocBalance: Decimal;
        DocBalanceReverse: Decimal;
        DateBalance: Decimal;
        DateBalanceReverse: Decimal;
        TotalBalance: Decimal;
        TotalBalanceReverse: Decimal;
        AccName: Text[50];
        LastLineNo: Integer;
        GLDocNo: Code[20];
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        AmountError: Boolean;
        ErrorCounter: Integer;
        ErrorText: array[1024] of Text[250];
        TempErrorText: Text[250];
        BalAccName: Text[50];
        CurrentCustomerVendors: Integer;
        VATEntryCreated: Boolean;
        CustPosting: Boolean;
        VendPosting: Boolean;
        SalesPostingType: Boolean;
        PurchPostingType: Boolean;
        DimText: Text[75];
        AllocationDimText: Text[75];
        ShowDim: Boolean;
        Continue: Boolean;
        CurrentICPartner: Code[20];
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
        Text010: Label '%1 must be Yes.';
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
        Text063: Label 'Document,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
        Text064: Label '%1 %2 is already used in line %3 (%4 %5, %6 %7).';
        Text065: Label '%1 must not be blocked with type %2 when %3 is %4';
        Text066: Label 'You cannot enter G/L Account or Bank Account in both %1 and %2.';
        Text067: Label '%1 %2 is linked to %3 %4.';
        Text069: Label '%1 must not be specified when %2 is %3.';
        Text070: Label '%1 must not be specified when the document is not an intercompany transaction.';
        Text071: Label '%1 %2 does not exist.';
        Text072: Label '%1 must not be %2 for %3 %4.';
        Text073: Label '%1 %2 already exists.';
        Text100: Label 'cannot be filtered when posting recurring journals';
        Text101: Label 'Do you want to post the journal lines?';
        Text102: Label 'There is nothing to post.';
        Text103: Label 'The journal lines were successfully posted.';
        Text104: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
        Text105: Label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?';
        Text106: Label '%1 in %2 must not be equal to %3 in %4.', Comment = 'Source Code in Genenral Journal Template must not be equal to Job G/L WIP in Source Code Setup.';
        USText001: Label 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.';
        GeneralJnlTestCap: Label 'General Journal - Test';
        PageNoCap: Label 'Page';
        JnlBatchNameCap: Label 'Journal Batch';
        PostingDateCap: Label 'Posting Date';
        DocumentTypeCap: Label 'Document Type';
        AccountTypeCap: Label 'Account Type';
        AccNameCap: Label 'Name';
        GenPostingTypeCap: Label 'Gen. Posting Type';
        GenBusPostingGroupCap: Label 'Gen. Bus. Posting Group';
        GenProdPostingGroupCap: Label 'Gen. Prod. Posting Group';
        DimensionsCap: Label 'Dimensions';
        WarningCap: Label 'Warning!';
        ReconciliationCap: Label 'Reconciliation';
        NoCap: Label 'No.';
        NameCap: Label 'Name';
        NetChangeinJnlCap: Label 'Net Change in Jnl.';
        BalafterPostingCap: Label 'Balance after Posting';
        DimensionAllocationsCap: Label 'Allocation Dimensions';
        journalType: Code[10];

    procedure GetLineDimension(dimension1: Code[20]; dimension2: Code[20]; dimension3: Code[20]; dimension4: Code[20]; dimension5: Code[20]; dimension6: Code[20]; dimension7: Code[20]; dimension8: Code[20]; DimensionsetID: Integer) IntValue: Integer
    var
        DimMgt: Codeunit DimensionManagement;
        DimTable: Record "Dimension Set Entry" temporary;
        DimValue: Record "Dimension Value";
        DimensionControl: Codeunit GLobalsDimContrel;
    begin

        DimValue.RESET;
        DimValue.SETRANGE("Dimension Code", dimension1);
        DimValue.SETRANGE(Code, dimension2);
        IF (NOT DimValue.FIND('-')) AND (dimension1 <> '') AND (dimension2 <> '') THEN BEGIN
            DimValue.INIT;
            DimValue."Dimension Code" := dimension1;
            DimValue.Code := dimension2;
            DimValue.INSERT(TRUE);
        END;

        DimValue.RESET;
        DimValue.SETRANGE("Dimension Code", 'Department');
        DimValue.SETRANGE(Code, dimension3);
        IF (NOT DimValue.FIND('-')) AND (dimension3 <> '') THEN BEGIN
            DimValue.INIT;
            DimValue."Dimension Code" := 'Department';
            DimValue.Code := dimension3;
            DimValue.INSERT(TRUE);
        END;

        //-----------------------------------------


        IF (dimension1 <> '') AND (dimension2 <> '') THEN BEGIN
            DimTable.INIT;
            DimTable."Dimension Code" := dimension1;
            DimTable."Dimension Value Code" := dimension2;
            DimTable.INSERT(TRUE);
        END;

        IF dimension3 <> '' THEN BEGIN
            DimTable.INIT;
            DimTable."Dimension Code" := 'Department';
            DimTable."Dimension Value Code" := dimension3;
            DimTable.INSERT(TRUE);
        END;

        IF dimension4 = 'CUSTOMER' THEN BEGIN
            DimTable.INIT;
            DimTable."Dimension Code" := 'CustomerCode';
            DimTable."Dimension Value Code" := dimension1;
            DimTable.INSERT(TRUE);

        END;

        IF dimension4 = 'VENDOR' THEN BEGIN
            DimTable.INIT;
            DimTable."Dimension Code" := 'VendorCode';
            DimTable."Dimension Value Code" := dimension1;
            DimTable.INSERT(TRUE);

        END;




        IntValue := DimensionControl.AddDimensions(DimensionsetID, DimTable);
    end;

    procedure GetLastLineNo(BatchName: Code[10]; TemplateName: Code[10]) LineNo: Integer
    var
        GenLE: Record "Gen. Journal Line";
    begin
        LineNo := 0;
        GenLE.RESET;
        GenLE.SETRANGE("Journal Template Name", TemplateName);
        GenLE.SETRANGE("Journal Batch Name", BatchName);
        GenLE.SETVIEW('SORTING(Line No.) ORDER(Descending)');
        IF GenLE.FIND('-') THEN BEGIN
            LineNo := GenLE."Line No.";
        END;
    end;

    procedure CheckJBatchName(JBatchName: Code[10]; TempLateName: Code[10]) isexist: Boolean
    var
        GJBtable: Record "Gen. Journal Batch";
        GJBtable2: Record "Gen. Journal Batch";
    begin
        GJBtable.RESET;
        GJBtable.SETRANGE("Journal Template Name", TempLateName);
        GJBtable.SETRANGE(Name, JBatchName);
        IF NOT GJBtable.FIND('-') THEN BEGIN
            EXIT(FALSE);
        END
        ELSE
            EXIT(TRUE);
    end;

    procedure CheckAccount(AccountType: Code[20]; AccountNo: Code[20]) isexist: Boolean
    begin
        isexist := FALSE;
        CASE AccountType OF
            'G/L ACCOUNT':
                BEGIN
                    GLAccount.RESET;
                    GLAccount.SETRANGE("No.", AccountNo);
                    IF GLAccount.FIND('-') THEN BEGIN
                        isexist := TRUE;
                    END;
                END;
            'CUSTOMER':
                BEGIN
                    Customer.RESET;
                    Customer.SETRANGE("No.", AccountNo);
                    IF Customer.FIND('-') THEN BEGIN
                        isexist := TRUE;
                    END;

                END;
            'VENDOR':
                BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE("No.", AccountNo);
                    IF Vendor.FIND('-') THEN BEGIN
                        isexist := TRUE;
                    END;

                END;
            'BANK ACCOUNT':
                BEGIN
                    "Bank account".RESET;
                    "Bank account".SETRANGE("No.", AccountNo);
                    IF "Bank account".FIND('-') THEN BEGIN
                        isexist := TRUE;
                    END;

                END;
            'FIXED ASSET':
                BEGIN
                    "Fixed asset".RESET;
                    "Fixed asset".SETRANGE("No.", AccountNo);
                    IF "Fixed asset".FIND('-') THEN BEGIN
                        isexist := TRUE;
                    END;

                END;
            'IC PARTNER':
                BEGIN
                    "IC partner".RESET;
                    "IC partner".SETRANGE(Code, AccountNo);
                    IF "IC partner".FIND('-') THEN BEGIN
                        isexist := TRUE;
                    END;

                END;
        END;
    end;

    procedure ValidateGenRecord()
    var
        PaymentTerms: Record "Payment Terms";
        DimMgt: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin


        tempGLE.RESET;
        IF (tempGLE.FIND('-')) AND (ValidateOK) THEN BEGIN
            REPEAT
                IF tempGLE."Currency Code" = '' THEN
                    tempGLE."Amount (LCY)" := tempGLE.Amount;

                tempGLE.UpdateLineBalance;

                AccName := '';
                BalAccName := '';

                IF NOT tempGLE.EmptyLine THEN BEGIN
                    MakeRecurringTexts(tempGLE);

                    AmountError := FALSE;

                    IF (tempGLE."Account No." = '') AND (tempGLE."Bal. Account No." = '') THEN
                        AddError(STRSUBSTNO(Text001, tempGLE.FIELDCAPTION("Account No."), tempGLE.FIELDCAPTION("Bal. Account No.")))
                    ELSE
                        IF (tempGLE."Account Type" <> tempGLE."Account Type"::"Fixed Asset") AND
                           (tempGLE."Bal. Account Type" <> tempGLE."Bal. Account Type"::"Fixed Asset")
                        THEN
                            TestFixedAssetFields(tempGLE);
                    CheckICDocument;
                    IF tempGLE."Account No." <> '' THEN
                        CASE tempGLE."Account Type" OF
                            tempGLE."Account Type"::"G/L Account":
                                BEGIN
                                    IF (tempGLE."Gen. Bus. Posting Group" <> '') OR (tempGLE."Gen. Prod. Posting Group" <> '') OR
                                       (tempGLE."VAT Bus. Posting Group" <> '') OR (tempGLE."VAT Prod. Posting Group" <> '')
                                    THEN BEGIN
                                        IF tempGLE."Gen. Posting Type" = tempGLE."Gen. Posting Type"::" " THEN
                                            AddError(STRSUBSTNO(Text002, tempGLE.FIELDCAPTION("Gen. Posting Type")));
                                    END;
                                    IF (tempGLE."Gen. Posting Type" <> tempGLE."Gen. Posting Type"::" ") AND
                                       (tempGLE."VAT Posting" = tempGLE."VAT Posting"::"Automatic VAT Entry")
                                    THEN BEGIN
                                        IF tempGLE."VAT Amount" + tempGLE."VAT Base Amount" <> tempGLE.Amount THEN
                                            AddError(
                                              STRSUBSTNO(
                                                Text003, tempGLE.FIELDCAPTION("VAT Amount"), tempGLE.FIELDCAPTION("VAT Base Amount"),
                                                tempGLE.FIELDCAPTION(Amount)));
                                        IF tempGLE."Currency Code" <> '' THEN
                                            IF tempGLE."VAT Amount (LCY)" + tempGLE."VAT Base Amount (LCY)" <> tempGLE."Amount (LCY)" THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text003, tempGLE.FIELDCAPTION("VAT Amount (LCY)"),
                                                    tempGLE.FIELDCAPTION("VAT Base Amount (LCY)"), tempGLE.FIELDCAPTION("Amount (LCY)")));
                                    END;
                                    TestJobFields(tempGLE);
                                END;
                            tempGLE."Account Type"::Customer, tempGLE."Account Type"::Vendor:
                                BEGIN
                                    IF tempGLE."Gen. Posting Type" <> tempGLE."Gen. Posting Type"::" " THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text004,
                                            tempGLE.FIELDCAPTION("Gen. Posting Type"), tempGLE.FIELDCAPTION("Account Type"), tempGLE."Account Type"));
                                    IF (tempGLE."Gen. Bus. Posting Group" <> '') OR (tempGLE."Gen. Prod. Posting Group" <> '') OR
                                       (tempGLE."VAT Bus. Posting Group" <> '') OR (tempGLE."VAT Prod. Posting Group" <> '')
                                    THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text005,
                                            tempGLE.FIELDCAPTION("Gen. Bus. Posting Group"), tempGLE.FIELDCAPTION("Gen. Prod. Posting Group"),
                                            tempGLE.FIELDCAPTION("VAT Bus. Posting Group"), tempGLE.FIELDCAPTION("VAT Prod. Posting Group"),
                                            tempGLE.FIELDCAPTION("Account Type"), tempGLE."Account Type"));

                                    IF tempGLE."Document Type" <> tempGLE."Document Type"::" " THEN BEGIN
                                        IF tempGLE."Account Type" = tempGLE."Account Type"::Customer THEN
                                            CASE tempGLE."Document Type" OF
                                                tempGLE."Document Type"::"Credit Memo":
                                                    WarningIfPositiveAmt(tempGLE);
                                                tempGLE."Document Type"::Payment:
                                                    IF (tempGLE."Applies-to Doc. Type" = tempGLE."Applies-to Doc. Type"::"Credit Memo") AND
                                                       (tempGLE."Applies-to Doc. No." <> '')
                                                    THEN
                                                        WarningIfNegativeAmt(tempGLE)
                                                    ELSE
                                                        WarningIfPositiveAmt(tempGLE);
                                                tempGLE."Document Type"::Refund:
                                                    WarningIfNegativeAmt(tempGLE);
                                                ELSE
                                                    WarningIfNegativeAmt(tempGLE);
                                            END
                                        ELSE
                                            CASE tempGLE."Document Type" OF
                                                tempGLE."Document Type"::"Credit Memo":
                                                    WarningIfNegativeAmt(tempGLE);
                                                tempGLE."Document Type"::Payment:
                                                    IF (tempGLE."Applies-to Doc. Type" = tempGLE."Applies-to Doc. Type"::"Credit Memo") AND
                                                       (tempGLE."Applies-to Doc. No." <> '')
                                                    THEN
                                                        WarningIfPositiveAmt(tempGLE)
                                                    ELSE
                                                        WarningIfNegativeAmt(tempGLE);
                                                tempGLE."Document Type"::Refund:
                                                    WarningIfPositiveAmt(tempGLE);
                                                ELSE
                                                    WarningIfPositiveAmt(tempGLE);
                                            END
                                    END;

                                    IF tempGLE.Amount * tempGLE."Sales/Purch. (LCY)" < 0 THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text008,
                                            tempGLE.FIELDCAPTION("Sales/Purch. (LCY)"), tempGLE.FIELDCAPTION(Amount)));
                                    IF tempGLE."Job No." <> '' THEN
                                        AddError(STRSUBSTNO(Text009, tempGLE.FIELDCAPTION("Job No.")));
                                END;
                            tempGLE."Account Type"::"Bank Account":
                                BEGIN
                                    IF tempGLE."Gen. Posting Type" <> tempGLE."Gen. Posting Type"::" " THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text004,
                                            tempGLE.FIELDCAPTION("Gen. Posting Type"), tempGLE.FIELDCAPTION("Account Type"), tempGLE."Account Type"));
                                    IF (tempGLE."Gen. Bus. Posting Group" <> '') OR (tempGLE."Gen. Prod. Posting Group" <> '') OR
                                       (tempGLE."VAT Bus. Posting Group" <> '') OR (tempGLE."VAT Prod. Posting Group" <> '')
                                    THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text005,
                                            tempGLE.FIELDCAPTION("Gen. Bus. Posting Group"), tempGLE.FIELDCAPTION("Gen. Prod. Posting Group"),
                                            tempGLE.FIELDCAPTION("VAT Bus. Posting Group"), tempGLE.FIELDCAPTION("VAT Prod. Posting Group"),
                                            tempGLE.FIELDCAPTION("Account Type"), tempGLE."Account Type"));

                                    IF tempGLE."Job No." <> '' THEN
                                        AddError(STRSUBSTNO(Text009, tempGLE.FIELDCAPTION("Job No.")));
                                    IF (tempGLE.Amount < 0) AND (tempGLE."Bank Payment Type" = tempGLE."Bank Payment Type"::"Computer Check") THEN
                                        IF NOT tempGLE."Check Printed" THEN
                                            AddError(STRSUBSTNO(Text010, tempGLE.FIELDCAPTION("Check Printed")));
                                END;
                            tempGLE."Account Type"::"Fixed Asset":
                                TestFixedAsset(tempGLE);
                        END;

                    IF tempGLE."Bal. Account No." <> '' THEN
                        CASE tempGLE."Bal. Account Type" OF
                            tempGLE."Bal. Account Type"::"G/L Account":
                                BEGIN
                                    IF (tempGLE."Bal. Gen. Bus. Posting Group" <> '') OR (tempGLE."Bal. Gen. Prod. Posting Group" <> '') OR
                                       (tempGLE."Bal. VAT Bus. Posting Group" <> '') OR (tempGLE."Bal. VAT Prod. Posting Group" <> '')
                                    THEN BEGIN
                                        IF tempGLE."Bal. Gen. Posting Type" = tempGLE."Bal. Gen. Posting Type"::" " THEN
                                            AddError(STRSUBSTNO(Text002, tempGLE.FIELDCAPTION("Bal. Gen. Posting Type")));
                                    END;
                                    IF (tempGLE."Bal. Gen. Posting Type" <> tempGLE."Bal. Gen. Posting Type"::" ") AND
                                       (tempGLE."VAT Posting" = tempGLE."VAT Posting"::"Automatic VAT Entry")
                                    THEN BEGIN
                                        IF tempGLE."Bal. VAT Amount" + tempGLE."Bal. VAT Base Amount" <> -tempGLE.Amount THEN
                                            AddError(
                                              STRSUBSTNO(
                                                Text011, tempGLE.FIELDCAPTION("Bal. VAT Amount"), tempGLE.FIELDCAPTION("Bal. VAT Base Amount"),
                                                tempGLE.FIELDCAPTION(Amount)));
                                        IF tempGLE."Currency Code" <> '' THEN
                                            IF tempGLE."Bal. VAT Amount (LCY)" + tempGLE."Bal. VAT Base Amount (LCY)" <> -tempGLE."Amount (LCY)" THEN
                                                AddError(
                                                  STRSUBSTNO(
                                                    Text011, tempGLE.FIELDCAPTION("Bal. VAT Amount (LCY)"),
                                                    tempGLE.FIELDCAPTION("Bal. VAT Base Amount (LCY)"), tempGLE.FIELDCAPTION("Amount (LCY)")));
                                    END;
                                END;
                            tempGLE."Bal. Account Type"::Customer, tempGLE."Bal. Account Type"::Vendor:
                                BEGIN
                                    IF tempGLE."Bal. Gen. Posting Type" <> tempGLE."Bal. Gen. Posting Type"::" " THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text004,
                                            tempGLE.FIELDCAPTION("Bal. Gen. Posting Type"), tempGLE.FIELDCAPTION("Bal. Account Type"), tempGLE."Bal. Account Type"));
                                    IF (tempGLE."Bal. Gen. Bus. Posting Group" <> '') OR (tempGLE."Bal. Gen. Prod. Posting Group" <> '') OR
                                       (tempGLE."Bal. VAT Bus. Posting Group" <> '') OR (tempGLE."Bal. VAT Prod. Posting Group" <> '')
                                    THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text005,
                                            tempGLE.FIELDCAPTION("Bal. Gen. Bus. Posting Group"), tempGLE.FIELDCAPTION("Bal. Gen. Prod. Posting Group"),
                                            tempGLE.FIELDCAPTION("Bal. VAT Bus. Posting Group"), tempGLE.FIELDCAPTION("Bal. VAT Prod. Posting Group"),
                                            tempGLE.FIELDCAPTION("Bal. Account Type"), tempGLE."Bal. Account Type"));

                                    IF tempGLE."Document Type" <> tempGLE."Document Type"::" " THEN BEGIN
                                        IF (tempGLE."Bal. Account Type" = tempGLE."Bal. Account Type"::Customer) =
                                           (tempGLE."Document Type" IN [tempGLE."Document Type"::Payment, tempGLE."Document Type"::"Credit Memo"])
                                        THEN
                                            WarningIfNegativeAmt(tempGLE)
                                        ELSE
                                            WarningIfPositiveAmt(tempGLE)
                                    END;
                                    IF tempGLE.Amount * tempGLE."Sales/Purch. (LCY)" > 0 THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text012,
                                            tempGLE.FIELDCAPTION("Sales/Purch. (LCY)"), tempGLE.FIELDCAPTION(Amount)));
                                    IF tempGLE."Job No." <> '' THEN
                                        AddError(STRSUBSTNO(Text009, tempGLE.FIELDCAPTION("Job No.")));
                                END;
                            tempGLE."Bal. Account Type"::"Bank Account":
                                BEGIN
                                    IF tempGLE."Bal. Gen. Posting Type" <> tempGLE."Bal. Gen. Posting Type"::" " THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text004,
                                            tempGLE.FIELDCAPTION("Bal. Gen. Posting Type"), tempGLE.FIELDCAPTION("Bal. Account Type"), tempGLE."Bal. Account Type"));
                                    IF (tempGLE."Bal. Gen. Bus. Posting Group" <> '') OR (tempGLE."Bal. Gen. Prod. Posting Group" <> '') OR
                                       (tempGLE."Bal. VAT Bus. Posting Group" <> '') OR (tempGLE."Bal. VAT Prod. Posting Group" <> '')
                                    THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text005,
                                            tempGLE.FIELDCAPTION("Bal. Gen. Bus. Posting Group"), tempGLE.FIELDCAPTION("Bal. Gen. Prod. Posting Group"),
                                            tempGLE.FIELDCAPTION("Bal. VAT Bus. Posting Group"), tempGLE.FIELDCAPTION("Bal. VAT Prod. Posting Group"),
                                            tempGLE.FIELDCAPTION("Bal. Account Type"), tempGLE."Bal. Account Type"));

                                    IF tempGLE."Job No." <> '' THEN
                                        AddError(STRSUBSTNO(Text009, tempGLE.FIELDCAPTION("Job No.")));
                                    IF (tempGLE.Amount > 0) AND (tempGLE."Bank Payment Type" = tempGLE."Bank Payment Type"::"Computer Check") THEN
                                        IF NOT tempGLE."Check Printed" THEN
                                            AddError(STRSUBSTNO(Text010, tempGLE.FIELDCAPTION("Check Printed")));
                                END;
                            tempGLE."Bal. Account Type"::"Fixed Asset":
                                TestFixedAsset(tempGLE);
                        END;

                    IF (tempGLE."Account No." <> '') AND
                       NOT tempGLE."System-Created Entry" AND
                       (tempGLE."Gen. Posting Type" = tempGLE."Gen. Posting Type"::" ") AND
                       (tempGLE.Amount = 0) AND
                       NOT GenJnlTemplate.Recurring AND
                       NOT tempGLE."Allow Zero-Amount Posting" AND
                       (tempGLE."Account Type" <> tempGLE."Account Type"::"Fixed Asset")
                    THEN
                        WarningIfZeroAmt(tempGLE);

                    CheckRecurringLine(tempGLE);
                    CheckAllocations(tempGLE);

                    IF tempGLE."Posting Date" = 0D THEN
                        AddError(STRSUBSTNO(Text002, tempGLE.FIELDCAPTION("Posting Date")))
                    ELSE BEGIN
                        IF tempGLE."Posting Date" <> NORMALDATE(tempGLE."Posting Date") THEN
                            IF (tempGLE."Account Type" <> tempGLE."Account Type"::"G/L Account") OR
                               (tempGLE."Bal. Account Type" <> tempGLE."Bal. Account Type"::"G/L Account")
                            THEN
                                AddError(
                                  STRSUBSTNO(
                                    Text013, tempGLE.FIELDCAPTION("Posting Date")));

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
                        IF (tempGLE."Posting Date" < AllowPostingFrom) OR (tempGLE."Posting Date" > AllowPostingTo) THEN
                            AddError(
                              STRSUBSTNO(
                                Text014, FORMAT(tempGLE."Posting Date")));


                    END;

                    IF tempGLE."Document Date" <> 0D THEN
                        IF (tempGLE."Document Date" <> NORMALDATE(tempGLE."Document Date")) AND
                           ((tempGLE."Account Type" <> tempGLE."Account Type"::"G/L Account") OR
                            (tempGLE."Bal. Account Type" <> tempGLE."Bal. Account Type"::"G/L Account"))
                        THEN
                            AddError(
                              STRSUBSTNO(
                                Text013, tempGLE.FIELDCAPTION("Document Date")));

                    IF tempGLE."Document No." = '' THEN
                        AddError(STRSUBSTNO(Text002, tempGLE.FIELDCAPTION("Document No.")))
                    ELSE


                        IF (tempGLE."Account Type" IN [tempGLE."Account Type"::Customer, tempGLE."Account Type"::Vendor, tempGLE."Account Type"::"Fixed Asset"]) AND
                           (tempGLE."Bal. Account Type" IN [tempGLE."Bal. Account Type"::Customer, tempGLE."Bal. Account Type"::Vendor, tempGLE."Bal. Account Type"::"Fixed Asset"])
                        THEN
                            AddError(
                              STRSUBSTNO(
                                Text017,
                                tempGLE.FIELDCAPTION("Account Type"), tempGLE.FIELDCAPTION("Bal. Account Type")));

                    IF tempGLE.Amount * tempGLE."Amount (LCY)" < 0 THEN
                        AddError(
                          STRSUBSTNO(
                            Text008, tempGLE.FIELDCAPTION("Amount (LCY)"), tempGLE.FIELDCAPTION(Amount)));

                    IF (tempGLE."Account Type" = tempGLE."Account Type"::"G/L Account") AND
                       (tempGLE."Bal. Account Type" = tempGLE."Bal. Account Type"::"G/L Account")
                    THEN
                        IF tempGLE."Applies-to Doc. No." <> '' THEN
                            AddError(STRSUBSTNO(Text009, tempGLE.FIELDCAPTION("Applies-to Doc. No.")));

                    IF ((tempGLE."Account Type" = tempGLE."Account Type"::"G/L Account") AND
                        (tempGLE."Bal. Account Type" = tempGLE."Bal. Account Type"::"G/L Account")) OR
                       (tempGLE."Document Type" <> tempGLE."Document Type"::Invoice)
                    THEN
                        IF PaymentTerms.GET(tempGLE."Payment Terms Code") THEN BEGIN
                            IF (tempGLE."Document Type" = tempGLE."Document Type"::"Credit Memo") AND
                               (NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                            THEN BEGIN
                                IF tempGLE."Pmt. Discount Date" <> 0D THEN
                                    AddError(STRSUBSTNO(Text009, tempGLE.FIELDCAPTION("Pmt. Discount Date")));
                                IF tempGLE."Payment Discount %" <> 0 THEN
                                    AddError(STRSUBSTNO(Text018, tempGLE.FIELDCAPTION("Payment Discount %")));
                            END;
                        END ELSE BEGIN
                            IF tempGLE."Pmt. Discount Date" <> 0D THEN
                                AddError(STRSUBSTNO(Text009, tempGLE.FIELDCAPTION("Pmt. Discount Date")));
                            IF tempGLE."Payment Discount %" <> 0 THEN
                                AddError(STRSUBSTNO(Text018, tempGLE.FIELDCAPTION("Payment Discount %")));
                        END;

                    IF ((tempGLE."Account Type" = tempGLE."Account Type"::"G/L Account") AND
                        (tempGLE."Bal. Account Type" = tempGLE."Bal. Account Type"::"G/L Account")) OR
                       (tempGLE."Applies-to Doc. No." <> '')
                    THEN
                        IF tempGLE."Applies-to ID" <> '' THEN
                            AddError(STRSUBSTNO(Text009, tempGLE.FIELDCAPTION("Applies-to ID")));

                    IF (tempGLE."Account Type" <> tempGLE."Account Type"::"Bank Account") AND
                       (tempGLE."Bal. Account Type" <> tempGLE."Bal. Account Type"::"Bank Account")
                    THEN
                        IF GenJnlLine2."Bank Payment Type" <> GenJnlLine2."Bank Payment Type"::" " THEN
                            AddError(STRSUBSTNO(Text009, tempGLE.FIELDCAPTION("Bank Payment Type")));

                    IF (tempGLE."Account No." <> '') AND (tempGLE."Bal. Account No." <> '') THEN BEGIN
                        PurchPostingType := FALSE;
                        SalesPostingType := FALSE;
                    END;
                    IF tempGLE."Account No." <> '' THEN
                        CASE tempGLE."Account Type" OF
                            tempGLE."Account Type"::"G/L Account":
                                CheckGLAcc(tempGLE, AccName);
                            tempGLE."Account Type"::Customer:
                                CheckCust(tempGLE, AccName);
                            tempGLE."Account Type"::Vendor:
                                CheckVend(tempGLE, AccName);
                            tempGLE."Account Type"::"Bank Account":
                                CheckBankAcc(tempGLE, AccName);
                            tempGLE."Account Type"::"Fixed Asset":
                                CheckFixedAsset(tempGLE, AccName);
                            tempGLE."Account Type"::"IC Partner":
                                CheckICPartner(tempGLE, AccName);
                        END;
                    IF tempGLE."Bal. Account No." <> '' THEN BEGIN
                        ExchAccGLJnlLine.RUN(tempGLE);
                        CASE tempGLE."Account Type" OF
                            tempGLE."Account Type"::"G/L Account":
                                CheckGLAcc(tempGLE, BalAccName);
                            tempGLE."Account Type"::Customer:
                                CheckCust(tempGLE, BalAccName);
                            tempGLE."Account Type"::Vendor:
                                CheckVend(tempGLE, BalAccName);
                            tempGLE."Account Type"::"Bank Account":
                                CheckBankAcc(tempGLE, BalAccName);
                            tempGLE."Account Type"::"Fixed Asset":
                                CheckFixedAsset(tempGLE, BalAccName);
                            tempGLE."Account Type"::"IC Partner":
                                CheckICPartner(tempGLE, AccName);
                        END;
                        ExchAccGLJnlLine.RUN(tempGLE);
                    END;

                    IF NOT DimMgt.CheckDimIDComb(tempGLE."Dimension Set ID") THEN
                        AddError(DimMgt.GetDimCombErr);

                    TableID[1] := DimMgt.TypeToTableID1(tempGLE."Account Type".AsInteger());
                    No[1] := tempGLE."Account No.";
                    TableID[2] := DimMgt.TypeToTableID1(tempGLE."Bal. Account Type".AsInteger());
                    No[2] := tempGLE."Bal. Account No.";
                    TableID[3] := DATABASE::Job;
                    No[3] := tempGLE."Job No.";
                    TableID[4] := DATABASE::"Salesperson/Purchaser";
                    No[4] := tempGLE."Salespers./Purch. Code";
                    TableID[5] := DATABASE::Campaign;
                    No[5] := tempGLE."Campaign No.";
                    IF NOT DimMgt.CheckDimValuePosting(TableID, No, tempGLE."Dimension Set ID") THEN
                        AddError(DimMgt.GetDimValuePostingErr);
                END;

                CheckBalance;
                AmountLCY := AmountLCY + tempGLE."Amount (LCY)";
                BalanceLCY := BalanceLCY + tempGLE."Balance (LCY)";
            UNTIL tempGLE.NEXT <= 0;
        END;
    end;

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
                    WarningIfZeroAmt(tempGLE);
                GenJnlLine2."Recurring Method"::"B  Balance", GenJnlLine2."Recurring Method"::"RB Reversing Balance":
                    WarningIfNonZeroAmt(tempGLE);
            END;
            IF GenJnlLine2."Recurring Method" <> GenJnlLine2."Recurring Method"::"V  Variable" THEN BEGIN
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
        GLDocNo := GenJnlLine2."Document No.";
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
        GenJnlLine := tempGLE;
        LastLineNo := tempGLE."Line No.";
        NextGenJnlLine := tempGLE;
        IF NextGenJnlLine.NEXT = 0 THEN;
        MakeRecurringTexts(NextGenJnlLine);
        IF NOT GenJnlLine.EmptyLine THEN BEGIN
            DocBalance := DocBalance + GenJnlLine."Balance (LCY)";
            DateBalance := DateBalance + GenJnlLine."Balance (LCY)";
            TotalBalance := TotalBalance + GenJnlLine."Balance (LCY)";
            //IF GenJnlLine."Recurring Method" >= GenJnlLine."Recurring Method"::"RF Reversing Fixed" THEN BEGIN
            IF (GenJnlLine."Recurring Method" = GenJnlLine."Recurring Method"::"RF Reversing Fixed") or (GenJnlLine."Recurring Method" = GenJnlLine."Recurring Method"::"V  Variable") THEN BEGIN
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
                        ;
                    /*AddError(
                      STRSUBSTNO(
                        Text025,
                        SELECTSTR(LastDocType + 1,Text063),LastDocNo,DocBalance));
                        */
                    DocBalanceReverse <> 0:
                        AddError(
                          STRSUBSTNO(
                            Text026,
                            //SELECTSTR(LastDocType + 1, Text063), LastDocNo, DocBalanceReverse));
                            LastDocType, LastDocNo, DocBalanceReverse));
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
                    ;
                /*
                  AddError(
                    STRSUBSTNO(
                      Text027,
                      LastDate,DateBalance));
                      */
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
                    ;
                /*
                 AddError(
                   STRSUBSTNO(
                     Text029,
                     TotalBalance));
                     */
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

        //FileOperator.SaveLogFile(LogFileName, Text, FALSE);
        ValidateOK := FALSE;
        FailRecCount += 1;
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
            IF NOT GenJnlLine."System-Created Entry" THEN
                IF GenJnlLine."Posting Date" = NORMALDATE(GenJnlLine."Posting Date") THEN
                    IF NOT GLAcc."Direct Posting" THEN
                        AddError(
                          STRSUBSTNO(
                            Text032,
                            GLAcc.FIELDCAPTION("Direct Posting"), TRUE, GLAcc.TABLECAPTION, GenJnlLine."Account No."));

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
                    OldCustLedgEntry.SETCURRENTKEY("Document No.");
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
                        OldCustLedgEntry.SETCURRENTKEY("External Document No.");
                        OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
                        OldCustLedgEntry.SETRANGE("Customer No.", GenJnlLine."Account No.");
                        OldCustLedgEntry.SETRANGE("External Document No.", GenJnlLine."External Document No.");
                        IF OldCustLedgEntry.FINDFIRST THEN
                            AddError(
                              STRSUBSTNO(
                                Text039,
                                GenJnlLine."Document Type", GenJnlLine."External Document No."));
                        CheckAgainstPrevLines(tempGLE);
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
                IF ICPartner.GET(Vend."IC Partner Code") THEN BEGIN
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
                    OldVendLedgEntry.SETCURRENTKEY("Document No.");
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
                        OldVendLedgEntry.SETCURRENTKEY("External Document No.");
                        OldVendLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
                        OldVendLedgEntry.SETRANGE("Vendor No.", GenJnlLine."Account No.");
                        OldVendLedgEntry.SETRANGE("External Document No.", GenJnlLine."External Document No.");
                        IF OldVendLedgEntry.FINDFIRST THEN
                            AddError(
                              STRSUBSTNO(
                                Text040,
                                GenJnlLine."Document Type", GenJnlLine."External Document No."));
                        CheckAgainstPrevLines(tempGLE);
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
        CheckFADocNo(GenJnlLine);
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
                        Text049,
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
            IF GenJnlLine."FA Posting Date" <> NORMALDATE(GenJnlLine."FA Posting Date") THEN
                AddError(
                  STRSUBSTNO(
                    Text052,
                    GenJnlLine.FIELDCAPTION("FA Posting Date")));
            IF NOT (GenJnlLine."FA Posting Date" IN [DMY2DATE(1, 1, 2) .. DMY2DATE(31, 12, 9998)]) THEN
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
                    AllowFAPostingTo := DMY2DATE(31, 12, 9998);
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
        AccType: Enum "Gen. Journal Account Type";
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
            AccType := GenJnlLine."Account Type";
            AccNo := GenJnlLine."Account No.";
        END ELSE BEGIN
            AccType := GenJnlLine."Bal. Account Type";
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
                    Text064, GenJnlLine.FIELDCAPTION("External Document No."),
                    GenJnlLine."External Document No.",
                    TempGenJnlLine."Line No.",
                    GenJnlLine.FIELDCAPTION("Document No."),
                    TempGenJnlLine."Document No.", GenJnlLine.FIELDCAPTION("Account Type"), GenJnlLine."Account Type"));
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
            IF (tempGLE."Posting Date" <> LastDate) OR (tempGLE."Document Type" <> LastDocType) OR (tempGLE."Document No." <> LastDocNo) THEN BEGIN
                GenJnlLine4.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                GenJnlLine4.SETRANGE("Journal Template Name", tempGLE."Journal Template Name");
                GenJnlLine4.SETRANGE("Journal Batch Name", tempGLE."Journal Batch Name");
                GenJnlLine4.SETRANGE("Posting Date", tempGLE."Posting Date");
                GenJnlLine4.SETRANGE("Document No.", tempGLE."Document No.");
                GenJnlLine4.SETFILTER("IC Partner Code", '<>%1', '');
                IF GenJnlLine4.FINDFIRST THEN
                    CurrentICPartner := GenJnlLine4."IC Partner Code"
                ELSE
                    CurrentICPartner := '';
            END;
            IF (CurrentICPartner <> '') AND (tempGLE."IC Direction" = tempGLE."IC Direction"::Outgoing) THEN BEGIN
                IF (tempGLE."Account Type" IN [tempGLE."Account Type"::"G/L Account", tempGLE."Account Type"::"Bank Account"]) AND
                   (tempGLE."Bal. Account Type" IN [tempGLE."Bal. Account Type"::"G/L Account", tempGLE."Account Type"::"Bank Account"]) AND
                   (tempGLE."Account No." <> '') AND
                   (tempGLE."Bal. Account No." <> '')
                THEN BEGIN
                    AddError(
                      STRSUBSTNO(
                        Text066, tempGLE.FIELDCAPTION("Account No."), tempGLE.FIELDCAPTION("Bal. Account No.")));
                END ELSE BEGIN
                    IF ((tempGLE."Account Type" IN [tempGLE."Account Type"::"G/L Account", tempGLE."Account Type"::"Bank Account"]) AND (tempGLE."Account No." <> '')) XOR
                       ((tempGLE."Bal. Account Type" IN [tempGLE."Bal. Account Type"::"G/L Account", tempGLE."Account Type"::"Bank Account"]) AND
                        (tempGLE."Bal. Account No." <> ''))
                    THEN BEGIN
                        IF tempGLE."IC Account No." = '' THEN
                            AddError(
                              STRSUBSTNO(
                                Text002, tempGLE.FIELDCAPTION("IC Account No.")))
                        ELSE BEGIN
                            IF "IC G/L Account".GET(tempGLE."IC Account No.") THEN
                                IF "IC G/L Account".Blocked THEN
                                    AddError(
                                      STRSUBSTNO(
                                        Text032,
                                        "IC G/L Account".FIELDCAPTION(Blocked), FALSE, tempGLE.FIELDCAPTION("IC Account No."),
                                        tempGLE."IC Account No."
                                        ));
                        END;
                    END ELSE
                        IF tempGLE."IC Account No." <> '' THEN
                            AddError(
                              STRSUBSTNO(
                                Text009, tempGLE.FIELDCAPTION("IC Account No.")));
                END;
            END ELSE
                IF tempGLE."IC Account No." <> '' THEN BEGIN
                    IF tempGLE."IC Direction" = tempGLE."IC Direction"::Incoming THEN
                        AddError(
                          STRSUBSTNO(
                            Text069, tempGLE.FIELDCAPTION("IC Account No."), tempGLE.FIELDCAPTION("IC Direction"), FORMAT(tempGLE."IC Direction")));
                    IF CurrentICPartner = '' THEN
                        AddError(
                          STRSUBSTNO(
                            Text070, tempGLE.FIELDCAPTION("IC Account No.")));
                END;
        END;
    end;

    procedure TestJobFields(var GenJnlLine: Record "Gen. Journal Line")
    var
        Job: Record Job;
        JT: Record "Job Task";
    begin
        IF (GenJnlLine."Job No." = '') OR (GenJnlLine."Account Type" <> GenJnlLine."Account Type"::"G/L Account") THEN
            EXIT;
        IF NOT Job.GET(GenJnlLine."Job No.") THEN
            AddError(STRSUBSTNO(Text071, Job.TABLECAPTION, GenJnlLine."Job No."))
        ELSE
            IF Job.Blocked <> Job.Blocked::" " THEN
                AddError(
                  STRSUBSTNO(
                    Text072, Job.FIELDCAPTION(Blocked), Job.Blocked, Job.TABLECAPTION, GenJnlLine."Job No."));

        IF GenJnlLine."Job Task No." = '' THEN
            AddError(STRSUBSTNO(Text002, GenJnlLine.FIELDCAPTION("Job Task No.")))
        ELSE
            IF NOT JT.GET(GenJnlLine."Job No.", GenJnlLine."Job Task No.") THEN
                AddError(STRSUBSTNO(Text071, JT.TABLECAPTION, GenJnlLine."Job Task No."))
    end;

    local procedure CheckFADocNo(GenJnlLine: Record "Gen. Journal Line")
    var
        DeprBook: Record "Depreciation Book";
        FAJnlLine: Record "FA Journal Line";
        OldFALedgEntry: Record "FA Ledger Entry";
        OldMaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        FANo: Code[20];
    begin
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" THEN
            FANo := GenJnlLine."Account No.";
        IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Fixed Asset" THEN
            FANo := GenJnlLine."Bal. Account No.";
        IF (FANo = '') OR
           (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::" ") OR
           (GenJnlLine."Depreciation Book Code" = '') OR
           (GenJnlLine."Document No." = '')
        THEN
            EXIT;
        IF NOT DeprBook.GET(GenJnlLine."Depreciation Book Code") THEN
            EXIT;
        IF DeprBook."Allow Identical Document No." THEN
            EXIT;

        FAJnlLine."FA Posting Type" := Enum::"FA Journal Line FA Posting Type".FromInteger(GenJnlLine."FA Posting Type".AsInteger() - 1);
        IF GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::Maintenance THEN BEGIN
            OldFALedgEntry.SETCURRENTKEY(
              "FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "Document No.");
            OldFALedgEntry.SETRANGE("FA No.", FANo);
            OldFALedgEntry.SETRANGE("Depreciation Book Code", GenJnlLine."Depreciation Book Code");
            OldFALedgEntry.SETRANGE("FA Posting Category", OldFALedgEntry."FA Posting Category"::" ");
            OldFALedgEntry.SETRANGE("FA Posting Type", FAJnlLine.ConvertToLedgEntry(FAJnlLine));
            OldFALedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
            IF OldFALedgEntry.FINDFIRST THEN
                AddError(
                  STRSUBSTNO(
                    Text073,
                    GenJnlLine.FIELDCAPTION("Document No."), GenJnlLine."Document No."));
        END ELSE BEGIN
            OldMaintenanceLedgEntry.SETCURRENTKEY(
              "FA No.", "Depreciation Book Code", "Document No.");
            OldMaintenanceLedgEntry.SETRANGE("FA No.", FANo);
            OldMaintenanceLedgEntry.SETRANGE("Depreciation Book Code", GenJnlLine."Depreciation Book Code");
            OldMaintenanceLedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
            IF OldMaintenanceLedgEntry.FINDFIRST THEN
                AddError(
                  STRSUBSTNO(
                    Text073,
                    GenJnlLine.FIELDCAPTION("Document No."), GenJnlLine."Document No."));
        END;
    end;

    procedure InitializeRequest(NewShowDim: Boolean)
    begin
        ShowDim := NewShowDim;
    end;

    local procedure GetDimensionText(var DimensionSetEntry: Record "Dimension Set Entry"): Text[75]
    var
        DimensionText: Text[75];
        Separator: Code[10];
        DimValue: Text[45];
    begin
        Separator := '';
        DimValue := '';
        Continue := FALSE;

        REPEAT
            DimValue := STRSUBSTNO('%1 - %2', DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code");
            IF MAXSTRLEN(DimensionText) < STRLEN(DimensionText + Separator + DimValue) THEN BEGIN
                Continue := TRUE;
                EXIT(DimensionText);
            END;
            DimensionText := DimensionText + Separator + DimValue;
            Separator := '; ';
        UNTIL DimSetEntry.NEXT = 0;
        EXIT(DimensionText);
    end;

    local procedure "Code"(GLERec: Record "Gen. Journal Line")
    var
        FALedgEntry: Record "FA Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
    begin
        GenJnlLine.COPY(GLERec);
        GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
        IF GenJnlTemplate.Type = GenJnlTemplate.Type::Jobs THEN BEGIN
            SourceCodeSetup.GET;
            //IF GenJnlTemplate."Source Code" = SourceCodeSetup."Job G/L WIP" THEN
            //FileOperator.SaveLogFile(LogFileName, STRSUBSTNO(Text106, GenJnlTemplate.FIELDCAPTION("Source Code"), GenJnlTemplate.TABLECAPTION,
            //SourceCodeSetup.FIELDCAPTION("Job G/L WIP"), SourceCodeSetup.TABLECAPTION), FALSE);
        END;
        GenJnlTemplate.TESTFIELD("Force Posting Report", FALSE);
        IF GenJnlTemplate.Recurring AND (GenJnlLine.GETFILTER("Posting Date") <> '') THEN
            GenJnlLine.FIELDERROR("Posting Date", Text100);

        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" THEN BEGIN
            FALedgEntry.SETRANGE("FA No.", GenJnlLine."Account No.");
            FALedgEntry.SETRANGE("FA Posting Type", GenJnlLine."FA Posting Type"::"Acquisition Cost");
            // IF FALedgEntry.FINDFIRST AND "Depr. Acquisition Cost" THEN
            //   IF NOT CONFIRM(Text105,FALSE,FIELDCAPTION("Depr. Acquisition Cost")) THEN
            //     EXIT;
        END;

        TempJnlBatchName := GenJnlLine."Journal Batch Name";

        /*IF GenJnlPostBatch.RUN(GenJnlLine) THEN BEGIN

            IF GenJnlLine."Line No." = 0 THEN
                FileOperator.SaveLogFile(LogFileName, Text102, FALSE)
            ELSE
                IF TempJnlBatchName = GenJnlLine."Journal Batch Name" THEN
                    FileOperator.SaveLogFile(LogFileName, Text103, FALSE)
                ELSE
                    FileOperator.SaveLogFile(LogFileName, Text103, FALSE);
        END;*/

        IF NOT GenJnlLine.FIND('=><') OR (TempJnlBatchName <> GenJnlLine."Journal Batch Name") THEN BEGIN
            GenJnlLine.RESET;
            GenJnlLine.FILTERGROUP(2);
            GenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
            GenJnlLine.FILTERGROUP(0);
            GenJnlLine."Line No." := 1;
        END;
    end;

    procedure setJournaltype(varjournalType: Code[10])
    begin
        journalType := varjournalType;
    end;

    local procedure ApplyVendorLedgerEntry(Rec: Record "Vendor Ledger Entry"; ApplyID: Text)
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        ApplyingVendLedgEntry: Record "Vendor Ledger Entry";
        SetApplytoID: Codeunit "Vend. Entry-SetAppl.ID";
        ActionPerformed: Boolean;
        recVendledgrEntry: Record "Vendor Ledger Entry";
    begin

        ApplyingVendLedgEntry.RESET;
        ApplyingVendLedgEntry.SETRANGE("Entry No.", Rec."Entry No.");
        IF ApplyingVendLedgEntry.FIND('-') THEN BEGIN
            /*
             IF ApplyingVendLedgEntry."Remaining Amount" = 0 THEN
               ApplyingVendLedgEntry.CALCFIELDS("Remaining Amount");

             ApplyingVendLedgEntry."Applying Entry" := TRUE;
             IF ApplyingVendLedgEntry."Applies-to ID" = '' THEN
               ApplyingVendLedgEntry."Applies-to ID" := ApplyID;
             ApplyingVendLedgEntry."Amount to Apply" := ApplyingVendLedgEntry."Remaining Amount";
             CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",ApplyingVendLedgEntry);
             COMMIT;
             */

            //VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);

            //VendLedgEntry.SETRANGE(Open,TRUE);
            //VendLedgEntry.SETRANGE("Document No.", ApplyingVendLedgEntry."Document No.");
            //  VendLedgEntry.SETRANGE("Document Type",VendLedgEntry."Document Type"::"Credit Memo");
            //IF VendLedgEntry.FINDFIRST THEN BEGIN
            // set apply to id
            SetApplytoID.SetApplId(ApplyingVendLedgEntry, ApplyingVendLedgEntry, ApplyID);
            //     COMMIT;

            //END;
        END;

    end;

    local procedure SplitTempGLE(var currTempGlE: Record "Gen. Journal Line" temporary; inputType: Integer) boolresult: Boolean
    var
        exDocNo: Text[30];
        VendorNo: Code[20];
        tempGLE2: Record "Gen. Journal Line" temporary;
        tempGLE3: Record "Gen. Journal Line" temporary;
        tempGLE4: Record "Gen. Journal Line" temporary;
        splitCount: Integer;
        isfirst: Boolean;
        totalAmount: Decimal;
        "totalAmount$": Decimal;
        cando: Boolean;
        tempGLE1: Record "Gen. Journal Line" temporary;
        isfirst2: Boolean;
        doctype: Enum "Gen. Journal Document Type";
        AddLineNo: Integer;
        AddLineNo2: Integer;
        VendorPostingGroup: Record "Vendor Posting Group";
        Vendors: Record Vendor;
        DocNo: Code[30];
        APAccountNo: Code[20];
        Customers: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
        InterfaceMessage: Codeunit "Interface Message";
    begin



        REPEAT
            IF currTempGlE."Account Type" <> currTempGlE."Account Type"::"G/L Account" THEN BEGIN
                tempGLE1.INIT;
                tempGLE1 := currTempGlE;
                tempGLE1.INSERT;
            END;
        UNTIL currTempGlE.NEXT <= 0;

        currTempGlE.FINDFIRST;
        REPEAT
            tempGLE2.INIT;
            tempGLE2 := currTempGlE;
            tempGLE2.INSERT;
        UNTIL currTempGlE.NEXT <= 0;

        currTempGlE.FINDFIRST;
        REPEAT
            IF currTempGlE."Account Type" = currTempGlE."Account Type"::"G/L Account" THEN BEGIN
                tempGLE3.INIT;
                tempGLE3 := currTempGlE;
                tempGLE3.INSERT;
            END;
        UNTIL currTempGlE.NEXT <= 0;


        // inputType  = 1  sales ,  =2 is purchase
        IF inputType = 1 THEN
            splitCount := 12;
        IF inputType = 2 THEN
            splitCount := 15;


        //tempGLE2.Copy(currTempGLE);
        tempGLE2.RESET;
        IF inputType = 2 THEN BEGIN
            tempGLE2.SETRANGE("Journal Template Name", 'PURCHASES');
            tempGLE2.SETRANGE("Account Type", tempGLE2."Account Type"::Vendor);
        END
        ELSE BEGIN
            tempGLE2.SETRANGE(tempGLE2."Journal Template Name", 'SALES');
            tempGLE2.SETRANGE("Account Type", tempGLE2."Account Type"::Customer);

        END;

        IF tempGLE2.FIND('-') THEN BEGIN
            exDocNo := '';
            doctype := doctype::" ";
            DocNo := '';
            APAccountNo := '';
            REPEAT
                IF (STRLEN(tempGLE2."External Document No.") > splitCount) THEN
                    IF ((exDocNo <> COPYSTR(tempGLE2."External Document No.", 1, STRLEN(tempGLE2."External Document No.") - splitCount))
                    OR (doctype <> tempGLE2."Document Type")) OR (STRLEN(tempGLE2."Document No.") <> STRLEN(DocNo))
                    OR (APAccountNo <> tempGLE2."AP/AR Account No.") THEN BEGIN
                        exDocNo := COPYSTR(tempGLE2."External Document No.", 1, STRLEN(tempGLE2."External Document No.") - splitCount);
                        doctype := tempGLE2."Document Type";
                        DocNo := tempGLE2."Document No.";
                        APAccountNo := tempGLE2."AP/AR Account No.";
                        tempGLE1.RESET;
                        IF inputType = 2 THEN BEGIN
                            tempGLE1.SETRANGE(tempGLE1."Journal Template Name", 'PURCHASES');
                            tempGLE1.SETRANGE("Account Type", tempGLE1."Account Type"::Vendor);
                        END
                        ELSE BEGIN
                            tempGLE1.SETRANGE(tempGLE1."Journal Template Name", 'SALES');
                            tempGLE1.SETRANGE("Account Type", tempGLE1."Account Type"::Customer);
                        END;
                        tempGLE1.SETRANGE("Document Type", tempGLE2."Document Type");
                        tempGLE1.SETRANGE("Account No.", tempGLE2."Account No.");
                        tempGLE1.SETRANGE("AP/AR Account No.", tempGLE2."AP/AR Account No.");

                        IF tempGLE1.FIND('-') THEN BEGIN
                            isfirst := TRUE;
                            isfirst2 := TRUE;
                            totalAmount := 0;

                            "totalAmount$" := 0;

                            AddLineNo := 0;

                            REPEAT

                                IF (STRLEN(tempGLE1."External Document No.") > splitCount) THEN
                                    IF (exDocNo = COPYSTR(tempGLE1."External Document No.", 1, STRLEN(tempGLE1."External Document No.") - splitCount))
                                    THEN //   OR (APAccountNo = tempGLE1."AP/AR Account No.") THEN
                                    BEGIN
                                        totalAmount := totalAmount + tempGLE1.Amount;
                                        "totalAmount$" := "totalAmount$" + tempGLE1."Amount (LCY)";
                                        IF NOT isfirst THEN BEGIN
                                            //change document no. of Gl account
                                            tempGLE3.RESET;
                                            IF inputType = 2 THEN BEGIN
                                                tempGLE3.SETRANGE(tempGLE3."Journal Template Name", 'PURCHASES');
                                            END
                                            ELSE BEGIN
                                                tempGLE3.SETRANGE(tempGLE3."Journal Template Name", 'SALES');
                                            END;
                                            tempGLE3.SETRANGE("Document No.", tempGLE1."Document No.");
                                            IF tempGLE3.FIND('-') THEN BEGIN
                                                IF (inputType = 2) OR (inputType = 1) THEN
                                                    REPEAT
                                                        tempGLE3."Document No." := tempGLE2."Document No.";
                                                        tempGLE3.MODIFY;
                                                        AddLineNo := tempGLE3."Line No.";
                                                    UNTIL tempGLE3.NEXT <= 0;
                                            END;

                                            //en change document no. of Gl account
                                            IF (inputType = 2) THEN BEGIN
                                                AddLineNo := tempGLE1."Line No.";
                                                Vendors.RESET;
                                                Vendors.SETRANGE("No.", tempGLE1."Account No.");
                                                IF Vendors.FIND('-') THEN BEGIN
                                                    VendorPostingGroup.RESET;
                                                    VendorPostingGroup.SETRANGE(Code, Vendors."Vendor Posting Group");
                                                    IF VendorPostingGroup.FIND('-') THEN BEGIN
                                                        tempGLE1."Document No." := tempGLE2."Document No.";
                                                        tempGLE1."Account Type" := tempGLE1."Account Type"::"G/L Account";
                                                        tempGLE1."Account No." := VendorPostingGroup."Payables Account";
                                                        tempGLE1.MODIFY;
                                                    END
                                                    ELSE BEGIN
                                                        //FileOperator.SaveLogFile(LogFileName, 'Line No.[' + FORMAT(tempGLE1."Line No.") + '] Vendor Posting Group Error, [' + Vendors."Vendor Posting Group" + '] doesn''t ' +
                                                        //'existed in the Vendor Posting Group  ', FALSE);
                                                        InterfaceMessage.UpdateInterfaceMessage(0, 1, 'Line No.[' + FORMAT(tempGLE1."Line No.") + '] Vendor Posting Group Error, [' + Vendors."Vendor Posting Group" + '] doesn''t existed in the Vendor Posting Group');
                                                        Commit();
                                                        ValidateOK := FALSE;
                                                        FailRecCount += 1;
                                                        //error
                                                    END;
                                                END;

                                            END;

                                            IF inputType = 1 THEN BEGIN
                                                AddLineNo := tempGLE1."Line No.";
                                                Customers.RESET;
                                                Customers.SETRANGE("No.", tempGLE1."Account No.");
                                                IF Customers.FIND('-') THEN BEGIN
                                                    CustPostingGroup.RESET;
                                                    CustPostingGroup.SETRANGE(Code, Customers."Customer Posting Group");
                                                    IF CustPostingGroup.FIND('-') THEN BEGIN
                                                        tempGLE1."Document No." := tempGLE2."Document No.";
                                                        tempGLE1."Account Type" := tempGLE1."Account Type"::"G/L Account";
                                                        tempGLE1."Account No." := CustPostingGroup."Receivables Account";
                                                        tempGLE1."Pmt. Discount Date" := 0D;
                                                        tempGLE1.MODIFY;
                                                    END
                                                    ELSE BEGIN
                                                        //FileOperator.SaveLogFile(LogFileName, 'Line No.[' + FORMAT(tempGLE1."Line No.") + '] customer Posting Group Error, [' + Customers."Customer Posting Group" + '] doesn''t ' +
                                                        //'existed in the customer Posting Group  ', FALSE);
                                                        InterfaceMessage.UpdateInterfaceMessage(0, 1, 'Line No.[' + FORMAT(tempGLE1."Line No.") + '] customer Posting Group Error, [' + Customers."Customer Posting Group" + '] doesn''t existed in the customer Posting Group');
                                                        Commit();
                                                        ValidateOK := FALSE;
                                                        FailRecCount += 1;
                                                        //error
                                                    END;
                                                END;


                                            END;

                                            // isfirst := false;
                                        END
                                        ELSE
                                            isfirst := FALSE;



                                    END;
                            UNTIL tempGLE1.NEXT <= 0;


                            IF tempGLE1.FIND('-') THEN BEGIN
                                REPEAT
                                    IF AddLineNo > 0 THEN BEGIN
                                        IF (STRLEN(tempGLE1."External Document No.") >= splitCount) THEN
                                            IF exDocNo = COPYSTR(tempGLE1."External Document No.", 1, STRLEN(tempGLE1."External Document No.") - splitCount) THEN BEGIN
                                                tempGLE4.INIT;
                                                tempGLE4 := tempGLE1;

                                                tempGLE4.Amount := totalAmount;
                                                tempGLE4."Amount (LCY)" := "totalAmount$";
                                                tempGLE4."Line No." := AddLineNo + 10;
                                                //Vendor Posting Group
                                                IF AddLineNo > 0 THEN BEGIN
                                                    IF inputType = 2 THEN BEGIN
                                                        //Vendor Posting Group
                                                        Vendors.RESET;
                                                        Vendors.SETRANGE("No.", tempGLE1."Account No.");
                                                        IF Vendors.FIND('-') THEN BEGIN
                                                            VendorPostingGroup.RESET;
                                                            VendorPostingGroup.SETRANGE(Code, Vendors."Vendor Posting Group");
                                                            IF VendorPostingGroup.FIND('-') THEN BEGIN
                                                                tempGLE4."Bal. Account Type" := tempGLE4."Bal. Account Type"::"G/L Account";
                                                                tempGLE4."Bal. Account No." := VendorPostingGroup."Payables Account";
                                                                // tempGLE4."AP/AR Account No."  := VendorPostingGroup."Payables Account";
                                                            END
                                                            ELSE BEGIN
                                                                //FileOperator.SaveLogFile(LogFileName, 'Line No.[' + FORMAT(tempGLE1."Line No.") + '] Vendor Posting Group Error, [' + Vendors."Vendor Posting Group" + '] doesn''t ' +
                                                                //'existed in the Vendor Posting Group  ', FALSE);
                                                                InterfaceMessage.UpdateInterfaceMessage(0, 1, 'Line No.[' + FORMAT(tempGLE1."Line No.") + '] Vendor Posting Group Error, [' + Vendors."Vendor Posting Group" + '] doesn''t existed in the Vendor Posting Group');
                                                                Commit();
                                                                ValidateOK := FALSE;
                                                                FailRecCount += 1;
                                                                //error
                                                            END;
                                                        END;

                                                        tempGLE4.INSERT;

                                                        Vendors.RESET;
                                                        Vendors.SETRANGE("No.", tempGLE1."Account No.");
                                                        IF Vendors.FIND('-') THEN BEGIN
                                                            VendorPostingGroup.RESET;
                                                            VendorPostingGroup.SETRANGE(Code, Vendors."Vendor Posting Group");
                                                            IF VendorPostingGroup.FIND('-') THEN BEGIN

                                                                tempGLE1."Account Type" := tempGLE1."Account Type"::"G/L Account";
                                                                tempGLE1."Account No." := VendorPostingGroup."Payables Account";
                                                                tempGLE1.MODIFY;
                                                            END;
                                                        END;
                                                    END
                                                    ELSE BEGIN

                                                        Customers.RESET;
                                                        Customers.SETRANGE("No.", tempGLE1."Account No.");
                                                        IF Customers.FIND('-') THEN BEGIN
                                                            CustPostingGroup.RESET;
                                                            CustPostingGroup.SETRANGE(Code, Customers."Customer Posting Group");
                                                            IF CustPostingGroup.FIND('-') THEN BEGIN
                                                                tempGLE4."Bal. Account Type" := tempGLE4."Bal. Account Type"::"G/L Account";
                                                                tempGLE4."Bal. Account No." := CustPostingGroup."Receivables Account";
                                                                tempGLE4."Pmt. Discount Date" := 0D;
                                                                // tempGLE4."AP/AR Account No."  := VendorPostingGroup."Payables Account";
                                                            END
                                                            ELSE BEGIN
                                                                //FileOperator.SaveLogFile(LogFileName, 'Line No.[' + FORMAT(tempGLE1."Line No.") + '] Customer Posting Group Error, [' + Customers."Customer Posting Group" + '] doesn''t ' +
                                                                //'existed in the Customer Posting Group  ', FALSE);
                                                                InterfaceMessage.UpdateInterfaceMessage(0, 1, 'Line No.[' + FORMAT(tempGLE1."Line No.") + '] Customer Posting Group Error, [' + Customers."Customer Posting Group" + '] doesn''t existed in the Customer Posting Group');
                                                                Commit();
                                                                ValidateOK := FALSE;
                                                                FailRecCount += 1;

                                                            END;
                                                        END;

                                                        tempGLE4.INSERT;
                                                        Customers.RESET;
                                                        Customers.SETRANGE("No.", tempGLE1."Account No.");
                                                        IF Customers.FIND('-') THEN BEGIN
                                                            CustPostingGroup.RESET;
                                                            CustPostingGroup.SETRANGE(Code, Customers."Customer Posting Group");
                                                            IF CustPostingGroup.FIND('-') THEN BEGIN

                                                                tempGLE1."Account Type" := tempGLE1."Account Type"::"G/L Account";
                                                                tempGLE1."Account No." := CustPostingGroup."Receivables Account";
                                                                tempGLE1."Pmt. Discount Date" := 0D;
                                                                tempGLE1.MODIFY;
                                                            END;
                                                        END;

                                                    END;
                                                END;
                                                //tempGLE1.MODIFY;




                                            END;
                                    END;
                                UNTIL tempGLE1.NEXT <= 0;
                            END;
                        END;
                    END // if exdocno = copystr
            UNTIL tempGLE2.NEXT <= 0;


        END;



        currTempGlE.DELETEALL;
        tempGLE1.RESET;
        IF tempGLE1.FINDFIRST THEN
            REPEAT
                //IF tempGLE1."Account Type" <> tempGLE1."Account Type"::"G/L Account" THEN
                //BEGIN
                currTempGlE.INIT;
                currTempGlE := tempGLE1;
                currTempGlE.INSERT;
            //END;

            UNTIL tempGLE1.NEXT <= 0;

        tempGLE3.RESET;
        IF tempGLE3.FINDFIRST THEN
            REPEAT
                currTempGlE.INIT;
                currTempGlE := tempGLE3;
                currTempGlE.INSERT;

            UNTIL tempGLE3.NEXT <= 0;

        tempGLE4.RESET;
        IF tempGLE4.FINDFIRST THEN
            REPEAT
                currTempGlE.INIT;
                currTempGlE := tempGLE4;
                currTempGlE.INSERT;

            UNTIL tempGLE4.NEXT <= 0;


        //currtempgle := tempgle1;
    end;

    local procedure ApplyCustLedgerEntry(Rec: Record "Cust. Ledger Entry"; ApplyID: Text)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry";
        SetApplytoID: Codeunit "Cust. Entry-SetAppl.ID";
        ActionPerformed: Boolean;
        recCustledgrEntry: Record "Cust. Ledger Entry";
    begin

        ApplyingCustLedgEntry.RESET;
        ApplyingCustLedgEntry.SETRANGE("Entry No.", Rec."Entry No.");
        IF ApplyingCustLedgEntry.FIND('-') THEN BEGIN

            // set apply to id
            SetApplytoID.SetApplId(ApplyingCustLedgEntry, ApplyingCustLedgEntry, ApplyID);
        END;
    end;

    local procedure AddVendorCodeintoGL(var currTempGlE: Record "Gen. Journal Line" temporary)
    var
        tempGLE1: Record "Gen. Journal Line" temporary;
        DimControl: Codeunit GLobalsDimContrel;
        DimTable: Record "Dimension Set Entry" temporary;
    begin

        currTempGlE.FINDFIRST;
        REPEAT
            IF currTempGlE."Account Type" <> currTempGlE."Account Type"::"G/L Account" THEN BEGIN
                tempGLE1.INIT;
                tempGLE1 := currTempGlE;
                tempGLE1.INSERT;
            END;
        UNTIL currTempGlE.NEXT <= 0;

        currTempGlE.FINDFIRST;
        REPEAT
            IF currTempGlE."Account Type" = currTempGlE."Account Type"::"G/L Account" THEN BEGIN
                tempGLE1.RESET;
                tempGLE1.SETRANGE("Document No.", currTempGlE."Document No.");
                IF tempGLE1.FIND('+') THEN BEGIN
                    IF tempGLE1."Journal Template Name" <> 'GENERAL' THEN BEGIN
                        DimTable.DELETEALL;
                        DimTable.INIT;
                        IF tempGLE1."Journal Template Name" = 'SALES' THEN
                            DimTable."Dimension Code" := 'CUSTOMERCODE'
                        ELSE IF tempGLE1."Journal Template Name" = 'PURCHASES' THEN
                            DimTable."Dimension Code" := 'VENDORCODE';

                        DimTable."Dimension Value Code" := tempGLE1."Account No.";
                        DimTable.INSERT(TRUE);

                        currTempGlE."Dimension Set ID" := DimControl.AddDimensions(currTempGlE."Dimension Set ID", DimTable);
                        currTempGlE.MODIFY(TRUE);

                    END;
                END;
            END;
        UNTIL currTempGlE.NEXT <= 0;
    end;
}

