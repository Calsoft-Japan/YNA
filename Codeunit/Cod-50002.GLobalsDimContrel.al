codeunit 50002 GLobalsDimContrel
{

    trigger OnRun()
    begin
    end;

    procedure AddDimensions(VarDimenSetID: Integer; var VarDimSetEntry: Record "Dimension Set Entry" temporary) newDmSetID: Integer
    var
        DimTable: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        TmpDimTable: Record "Dimension Set Entry" temporary;
        DimsetID: Integer;
        DimMgtLocal: Codeunit DimensionManagement;
    begin

        newDmSetID := VarDimenSetID;
        DimMgtLocal.GetDimensionSet(TmpDimTable, VarDimenSetID);
        //VarDimSetEntry.RESET;
        IF VarDimSetEntry.FIND('-') THEN BEGIN
            REPEAT
                DimValue.RESET;
                DimValue.SETRANGE("Dimension Code", VarDimSetEntry."Dimension Code");
                DimValue.SETRANGE(Code, VarDimSetEntry."Dimension Value Code");
                IF NOT DimValue.FIND('-') THEN BEGIN
                    DimValue.INIT;
                    DimValue."Dimension Code" := VarDimSetEntry."Dimension Code";
                    DimValue.Code := VarDimSetEntry."Dimension Value Code";
                    DimValue.INSERT(TRUE);

                END;

                TmpDimTable.RESET;
                TmpDimTable.SETRANGE("Dimension Code", VarDimSetEntry."Dimension Code");
                IF TmpDimTable.FIND('-') THEN BEGIN
                    TmpDimTable.VALIDATE("Dimension Value Code", VarDimSetEntry."Dimension Value Code");

                    TmpDimTable.MODIFY(TRUE);

                END
                ELSE BEGIN

                    TmpDimTable.INIT;
                    TmpDimTable."Dimension Code" := VarDimSetEntry."Dimension Code";
                    TmpDimTable.VALIDATE("Dimension Value Code", VarDimSetEntry."Dimension Value Code");
                    TmpDimTable.INSERT(TRUE);


                END;



            UNTIL VarDimSetEntry.NEXT <= 0;

            EXIT(DimMgtLocal.GetDimensionSetID(TmpDimTable));
        END;

    end;

    procedure DeleteDimensions(VarDimenSetID: Integer; var VarDimSetEntry: Record "Dimension Set Entry" temporary) newDmSetID: Integer
    var
        DimTable: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        TmpDimTable: Record "Dimension Set Entry" temporary;
        DimsetID: Integer;
        DimMgtLocal: Codeunit DimensionManagement;
    begin

        DimMgtLocal.GetDimensionSet(TmpDimTable, VarDimenSetID);
        IF VarDimSetEntry.FIND('-') THEN BEGIN
            REPEAT

                TmpDimTable.RESET;
                TmpDimTable.SETRANGE("Dimension Code", VarDimSetEntry."Dimension Code");
                TmpDimTable.SETRANGE("Dimension Value Code", VarDimSetEntry."Dimension Value Code");
                IF TmpDimTable.FIND('-') THEN BEGIN
                    TmpDimTable.DELETE(TRUE);
                END;

            UNTIL VarDimSetEntry.NEXT <= 0;

            EXIT(DimMgtLocal.GetDimensionSetID(TmpDimTable));
        END;
    end;

    procedure GetDimensionName("DimNo.": Integer) DimName: Code[20]
    var
        GenLegerSetup: Record "General Ledger Setup";
    begin
        GenLegerSetup.GET();
        CASE "DimNo." OF
            1:
                EXIT(GenLegerSetup."Shortcut Dimension 1 Code");
            2:
                EXIT(GenLegerSetup."Shortcut Dimension 2 Code");
            3:
                EXIT(GenLegerSetup."Shortcut Dimension 3 Code");
            4:
                EXIT(GenLegerSetup."Shortcut Dimension 4 Code");
            5:
                EXIT(GenLegerSetup."Shortcut Dimension 5 Code");
            6:
                EXIT(GenLegerSetup."Shortcut Dimension 6 Code");
            7:
                EXIT(GenLegerSetup."Shortcut Dimension 7 Code");
            8:
                EXIT(GenLegerSetup."Shortcut Dimension 8 Code");
        END;
    end;

    procedure GetDimnensionNo(DimName: Code[20]) DimNo: Integer
    var
        GenLegerSetup: Record "General Ledger Setup";
    begin
    end;
}

