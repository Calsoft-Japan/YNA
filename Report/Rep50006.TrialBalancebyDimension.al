report 50006 "Trial Balance by Dimension"
{
    Permissions = tabledata "G/L Entry" = rimd;
    DefaultLayout = RDLC;

    RDLCLayout = './RDLC/Trial Balance by Dimension.rdlc';
    Caption = 'Trial Balance by Dimension';
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            RequestFilterFields = "No.";
            dataitem("Analysis View Entry"; "Analysis View Entry")
            {
                DataItemTableView = SORTING("Analysis View Code", "Account No.", "Account Source", "Dimension 1 Value Code", "Dimension 2 Value Code", "Dimension 3 Value Code", "Dimension 4 Value Code", "Business Unit Code", "Posting Date", "Entry No.", "Cash Flow Forecast No.");
                UseTemporary = true;
                column(GLAccNo; "Analysis View Entry"."Account No.")
                {
                }
                column(Description; "G/L Account".Name)
                {
                }
                column(SubCode; Subcode)
                {
                }
                column(DepartmentCode; Departmentcode)
                {
                }
                column(BeginBalance; Amount)// beginBalance)
                {
                }
                column(Debit; "Debit Amount")// sumdebit) // lewis. 20250827 modified
                {
                }
                column(Credit; "Credit Amount")// sumCredit) // lewis. 20250827 modified
                {
                }
                column(endingbalance; "Add.-Curr. Amount")//endingbalance)
                {
                }
                column(SubDesc; SubDesc)
                {
                }
                column(Datestring; FORMAT(begindate) + '~' + FORMAT(endingdate))
                {
                }
                column(CloseDep; CloseDep)
                {
                }

                trigger OnAfterGetRecord()
                var
                    TmpDimTable: Record "Dimension Set Entry" temporary;
                begin


                    Subcode := '';
                    Departmentcode := '';
                    SubDesc := '';
                    beginBalance := 0;
                    endingbalance := 0;
                    sumdebit := 0;
                    sumCredit := 0;

                    GLE.RESET;
                    GLE.SETRANGE("Account No.", "Analysis View Entry"."Account No.");
                    GLE.SETRANGE("Analysis View Code", "Analysis View Entry"."Analysis View Code");
                    IF ((COPYSTR("Analysis View Entry"."Analysis View Code", 1, 5) = 'BSDEP')
                       AND CloseDep) OR (COPYSTR("Analysis View Entry"."Analysis View Code", 1, 5) = 'BSSUB') THEN
                        GLE.SETRANGE("Dimension 1 Value Code", "Analysis View Entry"."Dimension 1 Value Code");
                    IF GLE.FIND('-') THEN BEGIN
                        REPEAT
                            IF (COPYSTR(GLE."Analysis View Code", 1, 5) = 'BSSUB') THEN BEGIN
                                //SubCode
                                Subcode := GLE."Dimension 1 Value Code";
                                IF DimValue.GET("Analysis View Entry"."Account No.", Subcode) THEN
                                    SubDesc := DimValue.Name;
                            END ELSE IF (COPYSTR(GLE."Analysis View Code", 1, 5) = 'BSDEP') AND CloseDep THEN BEGIN
                                // Department
                                Departmentcode := GLE."Dimension 1 Value Code";
                                IF DimValue.GET('DEPARTMENT', Departmentcode) THEN
                                    SubDesc := DimValue.Name;

                            END;

                        // IF GLE."Posting Date" < begindate THEN
                        //     beginBalance := beginBalance + GLE.Amount;
                        // IF GLE."Posting Date" <= endingdate THEN
                        //     endingbalance := endingbalance + GLE.Amount;

                        //IF (GLE."Posting Date" >= begindate) AND (GLE."Posting Date" <= endingdate) THEN BEGIN
                        //    sumCredit := sumCredit + GLE."Credit Amount";
                        //    sumdebit := sumdebit + GLE."Debit Amount";
                        //END;

                        UNTIL GLE.NEXT <= 0;
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            var
                TmpDimTable: Record "Dimension Set Entry" temporary;
                needbreak: Boolean;
            begin

                GLE.RESET;
                GLE.SETFILTER("Posting Date", '<=' + FORMAT(endingdate));
                GLE.SETRANGE("Account No.", "G/L Account"."No.");

                IF GLE.FIND('-') THEN BEGIN
                    REPEAT
                        IF (COPYSTR(GLE."Analysis View Code", 1, 5) = 'BSDEP') OR (COPYSTR(GLE."Analysis View Code", 1, 5) = 'BSSUB') THEN BEGIN
                            "Analysis View Entry".RESET;
                            "Analysis View Entry".SETRANGE("Account No.", GLE."Account No.");
                            IF ((COPYSTR(GLE."Analysis View Code", 1, 5) = 'BSDEP') AND CloseDep) OR (COPYSTR(GLE."Analysis View Code", 1, 5) = 'BSSUB') THEN
                                "Analysis View Entry".SETRANGE("Dimension 1 Value Code", GLE."Dimension 1 Value Code");
                            IF NOT "Analysis View Entry".FIND('-') THEN BEGIN

                                "Analysis View Entry".INIT;
                                "Analysis View Entry" := GLE;
                                "Analysis View Entry".INSERT;

                                GetAmounts("Analysis View Entry");

                            END;
                        END;
                    UNTIL GLE.NEXT <= 0;
                END;
            end;
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
                    group("Trial Period")
                    {
                        Caption = 'Trial Period';
                        field(begindate; begindate)
                        {
                            Caption = 'From date';
                            ApplicationArea = Basic, Suite;
                        }
                        field(endingdate; endingdate)
                        {
                            Caption = 'To Date';
                            ApplicationArea = Basic, Suite;
                        }
                    }
                    field(CloseDep; CloseDep)
                    {
                        Caption = 'Show Department Code';
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        // "G/L Entry".SETRANGE("Posting Date", begindate, endingdate);
    end;

    var
        begindate: Date;
        endingdate: Date;
        GLE: Record "Analysis View Entry";
        DefDimen: Record "Default Dimension";
        Subcode: Code[20];
        Departmentcode: Code[20];
        beginBalance: Decimal;
        endingbalance: Decimal;
        SubDesc: Text[250];
        DimTable: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        DimsetID: Integer;
        DimMgtLocal: Codeunit DimensionManagement;
        sumCredit: Decimal;
        sumdebit: Decimal;
        CloseDep: Boolean;

        TrueGLE: Record "G/L Entry";

    procedure GetAmounts(var AVE: Record "Analysis View Entry" temporary)
    begin
        TrueGLE.Reset();
        TrueGLE.SetRange("G/L Account No.", AVE."Account No.");
        //TrueGLE.SetRange("Global Dimension 1 Code", AVE."Dimension 1 Value Code");
        TrueGLE.SetFilter("Posting Date", '<%1', begindate);
        TrueGLE.CalcSums(Amount);
        AVE.Amount := TrueGLE.Amount;


        TrueGLE.Reset();
        TrueGLE.SetRange("G/L Account No.", AVE."Account No.");
        //TrueGLE.SetRange("Global Dimension 1 Code", AVE."Dimension 1 Value Code");
        TrueGLE.SetFilter("Posting Date", '<=%1', endingdate);
        TrueGLE.CalcSums(Amount);
        AVE."Add.-Curr. Amount" := TrueGLE.Amount; //endingbalance 

        TrueGLE.Reset();
        TrueGLE.SetRange("G/L Account No.", AVE."Account No.");
        //TrueGLE.SetRange("Global Dimension 1 Code", AVE."Dimension 1 Value Code");
        TrueGLE.SetRange("Posting Date", begindate, endingdate);
        TrueGLE.CalcSums(Amount, "Credit Amount", "Debit Amount");
        AVE."Credit Amount" := TrueGLE."Credit Amount";
        AVE."Debit Amount" := TrueGLE."Debit Amount";
        AVE.Modify();

    end;
}

