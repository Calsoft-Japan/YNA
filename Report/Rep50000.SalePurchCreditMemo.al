report 50000 "Sale-Purch.Credit memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Sale-Purch.Credit memo.rdlc';
    TransactionType = UpdateNoLocks;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            UseTemporary = true;
            column(ItemNo; "Gen. Journal Line"."Item No.")
            {
            }
            column(ItemDesc; "Gen. Journal Line"."Item Description")
            {
            }
            column(RMANo; "Gen. Journal Line"."RMA No.")
            {
            }
            column(QTY; "Gen. Journal Line".Quantity1)
            {
            }
            column(UnitPrice; "Gen. Journal Line"."Unit Price")
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyState; CompanyInfo.County)
            {
            }
            column(CompanyZIP; CompanyInfo."Post Code")
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyFax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(BilltoName; BilltoName)
            {
            }
            column(BilltoAddress; BilltoAddress)
            {
            }
            column(Billtocity; Billtocity)
            {
            }
            column(BilltoState; BilltoState)
            {
            }
            column(BilltoZip; BilltoZip)
            {
            }
            column(BilltoCountry; BilltoCountry)
            {
            }
            column(CreditmemoNo; CreditmemoNo)
            {
            }
            column(Creditmemodate; Creditmemodate)
            {
            }
            column(Amount; "Gen. Journal Line".Amount)
            {
            }
            column(Postingdate; "Gen. Journal Line"."Posting Date")
            {
            }
            column(DocumentNo; "Gen. Journal Line"."Document No.")
            {
            }
            column(LineNo; "Gen. Journal Line"."Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                // message("Gen. Journal Line"."Item No.");
                IF "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Customer THEN BEGIN
                    Customer.RESET;
                    Customer.SETRANGE("No.", "Gen. Journal Line"."Account No.");
                    IF Customer.FIND('-') THEN BEGIN
                        BilltoName := Customer.Name;
                        BilltoAddress := Customer.Address;
                        Billtocity := Customer.City;
                        BilltoState := Customer.County;
                        BilltoZip := Customer."Post Code";
                        BilltoCountry := Customer."Country/Region Code";


                    END;

                END
                ELSE BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE("No.", "Gen. Journal Line"."Account No.");
                    IF Vendor.FIND('-') THEN BEGIN
                        BilltoName := Vendor.Name;
                        BilltoAddress := Vendor.Address;
                        Billtocity := Vendor.City;
                        BilltoState := Vendor.County;
                        BilltoZip := Vendor."Post Code";
                        BilltoCountry := Vendor."Country/Region Code";


                    END;

                END;
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

    trigger OnPreReport()
    var
        Lineno: Integer;
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
        Customer: Record Customer;
        VendorLedgEntry: Record "Vendor Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        BilltoName: Text[250];
        BilltoAddress: Text;
        Billtocity: Text[250];
        BilltoState: Text[250];
        BilltoZip: Text[250];
        BilltoCountry: Text[250];
        CreditmemoNo: Code[20];
        Creditmemodate: Date;
        PrintType: Option Customer,Vendor;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        CopyTxt: Text[100];
        TempGLE: Record "Gen. Journal Line" temporary;

    procedure Settemptable(var temptable: Record "Gen. Journal Line" temporary)
    begin

        REPEAT
        // IF temptable."Print Debit/Credit Memo"  THEN
        BEGIN
            "Gen. Journal Line".INIT;
            "Gen. Journal Line" := temptable;
            "Gen. Journal Line".INSERT;
        END;

        UNTIL temptable.NEXT <= 0;
    end;

    procedure SetPrintType(PrintPurchase: Boolean)
    begin
    end;
}

