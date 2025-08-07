report 50003 "Check 53 NoData"
{
    // =================================================================================
    // Ver.No.     Date         Sign.  ID              Description
    // ---------------------------------------------------------------------------------
    // CSPH1       2015-12-3    Tony  FDD206
    // =================================================================================
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Check 53 NoData.rdlc';

    Caption = 'Check';
    UseRequestPage = false;
    UseSystemPrinter = true;

    dataset
    {
        dataitem(PrintCheck; Integer)
        {
            DataItemTableView = SORTING(Number);
            MaxIteration = 1;
            column(CheckAmountText; CheckAmountText)
            {
            }
            column(CheckDateText; FORMAT(TODAY, 0, 0))
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
            column(TotalLineAmount; TotalLineAmount)
            {
                AutoFormatType = 1;
            }
            column(ChecktoVendorName; VendorName)
            {
            }
            column(ChecktoVendorNo; BalancingNo)
            {
            }
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

    var
        VendorName: Text[50];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[132];
        CheckToAddr: array[8] of Text[50];
        Receiptmessage: Text[140];
        VoidText: Text[30];
        TotalLineAmount: Decimal;
        BalancingNo: Code[20];

    procedure SetReportData(mCheckNoText: Text[30]; mCheckAmountText: Text[30]; mDescriptionLine: array[2] of Text[132]; mCheckToAddr: array[8] of Text[50]; mReceiptmessage: Text[140]; mVoidText: Text[30]; mTotalLineAmount: Decimal; mVendorName: Text[50]; mBalancingNo: Code[20])
    begin
        CheckNoText := mCheckNoText;
        CheckAmountText := mCheckAmountText;
        COPYARRAY(DescriptionLine, mDescriptionLine, 1);
        COPYARRAY(CheckToAddr, mCheckToAddr, 1);
        Receiptmessage := mReceiptmessage;
        VoidText := mVoidText;
        TotalLineAmount := mTotalLineAmount;
        VendorName := mVendorName;
        BalancingNo := mBalancingNo;
    end;
}

