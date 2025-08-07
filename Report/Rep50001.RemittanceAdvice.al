report 50001 "Remittance Advice"
{
    // =================================================================================
    // Ver.No.     Date         Sign.  ID              Description
    // ---------------------------------------------------------------------------------
    // CSPH1       2015-11-16   Tony   FDD206        Remittance Advice
    // =================================================================================
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Remittance Advice.rdlc';

    UseRequestPage = true;
    UseSystemPrinter = false;

    dataset
    {
        dataitem(Header; Integer)
        {
            DataItemTableView = SORTING(Number);
            column(REPOST_TITLE; REPOST_TITLE)
            {
            }
            column(Date_Caption; Date_Caption)
            {
            }
            column(Page_Caption; Page_Caption)
            {
            }
            column(Vendor_No_Caption; Vendor_No_Caption)
            {
            }
            column(Name_Caption; Name_Caption)
            {
            }
            column(TB_Invoice_No_Caption; TB_Invoice_No_Caption)
            {
            }
            column(TB_Date_Caption; TB_Date_Caption)
            {
            }
            column(TB_VCHR_Caption; TB_VCHR_Caption)
            {
            }
            column(TB_Description_Caption; TB_Description_Caption)
            {
            }
            column(TB_Gross_Amount_Caption; TB_Gross_Amount_Caption)
            {
            }
            column(TB_Discount_Caption; TB_Discount_Caption)
            {
            }
            column(TB_Net_Amount_Caption; TB_Net_Amount_Caption)
            {
            }
            column(Total_Caption; Total_Caption)
            {
            }
            column(Vendor_No; GenJnlLine."Account No.")
            {
            }
            column(Vendor_Name; VendorName)
            {
            }
            column(Invoice_No; GenJnlLine."External Document No.")
            {
            }
            column(Invoice_Date; FORMAT(GenJnlLine."Posting Date", 0, 0))
            {
            }
            column(VCHR; GenJnlLine."Document No.")
            {
            }
            column(Description; GenJnlLine.Description)
            {
            }
            column(Gross_Amount; GenJnlLine.Amount)
            {
            }
            column(Discount; GenJnlLine."Debit Amount")
            {
            }
            column(Net_Amount; GenJnlLine.Amount - GenJnlLine."Debit Amount")
            {
            }
            column(CO_NAME; CompanyInfo.Name)
            {
            }
            column(CO_LOGO; CompanyInfo.Picture)
            {
            }
            column(CO_Address; CompanyInfo.Address)
            {
            }
            column(CO_Address2; CompanyInfo."Address 2")
            {
            }
            column(CO_Phone; COPhone)
            {
            }
            column(CO_CITY; COCity)
            {
            }
            column(FORMAT_TODAY; FORMAT(TODAY, 0, 0))
            {
            }
            column(PageNo; PageNo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN
                    GenJnlLine.FINDFIRST
                ELSE
                    GenJnlLine.NEXT;
                VendorName := '';
                IF VendorRecord.GET(GenJnlLine."Account No.") THEN
                    VendorName := VendorRecord.Name;

                IF GenJnlLine."Account No." <> VendorNo THEN BEGIN
                    PageNo := 1;

                END
                ELSE BEGIN
                    PageNo := PageNo + 1;
                    //  PageMaxNo := PageMaxNo + 1;

                END;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE(Number, 1, GenJnlLine.COUNT);
                VendorNo := GenJnlLine."Account No.";
            end;
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

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        COPhone := '';
        COCity := '';
        IF CompanyInfo."Phone No." <> '' THEN
            COPhone := 'Phone: ' + CompanyInfo."Phone No." + ' ';
        IF CompanyInfo."Fax No." <> '' THEN
            COPhone := COPhone + 'Fax: ' + CompanyInfo."Fax No.";
        IF CompanyInfo.City <> '' THEN
            COCity := CompanyInfo.City + ', ';
        IF CompanyInfo.County <> '' THEN
            COCity := COCity + CompanyInfo.County + ' ';
        IF CompanyInfo."Post Code" <> '' THEN
            COCity := COCity + CompanyInfo."Post Code";
    end;

    var
        REPOST_TITLE: Label 'Remittance Advice';
        Date_Caption: Label 'Date';
        Page_Caption: Label 'Page';
        Vendor_No_Caption: Label 'Vendor No.:';
        Name_Caption: Label 'Name:';
        TB_Invoice_No_Caption: Label 'Invoice No.';
        TB_Date_Caption: Label 'Date';
        TB_VCHR_Caption: Label 'VCHR#';
        TB_Description_Caption: Label 'Description';
        TB_Gross_Amount_Caption: Label 'Gross Amount';
        TB_Discount_Caption: Label 'Discount';
        TB_Net_Amount_Caption: Label 'Net Amount';
        Total_Caption: Label 'Total:';
        VendLedgEntry: Record "Vendor Ledger Entry";
        LineAmount: Decimal;
        LineDiscount: Decimal;
        LineNetAmount: Decimal;
        CompanyInfo: Record "Company Information";
        VendorRecord: Record Vendor;
        VendorName: Text[50];
        COPhone: Text[75];
        COCity: Text[83];
        GenJnlLine: Record "Gen. Journal Line" temporary;
        PageNo: Integer;
        PageMaxNo: Integer;
        VendorNo: Code[20];

    procedure SetGenJournalLine(var GenJournalLine: Record "Gen. Journal Line" temporary)
    begin
        GenJnlLine.DELETEALL;
        IF GenJournalLine.FIND('-') THEN
            REPEAT
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := GenJournalLine."Journal Template Name";
                GenJnlLine."Journal Batch Name" := GenJournalLine."Journal Batch Name";
                GenJnlLine."Line No." := GenJournalLine."Line No.";
                GenJnlLine."Account No." := GenJournalLine."Account No.";
                GenJnlLine."Applies-to ID" := GenJournalLine."Applies-to ID";
                GenJnlLine."External Document No." := GenJournalLine."External Document No.";
                GenJnlLine."Posting Date" := GenJournalLine."Posting Date";
                GenJnlLine.Amount := GenJournalLine.Amount;
                GenJnlLine."Debit Amount" := GenJournalLine."Debit Amount";
                GenJnlLine."Document No." := GenJournalLine."Document No.";
                GenJnlLine.INSERT;
            UNTIL GenJournalLine.NEXT = 0;
    end;
}

