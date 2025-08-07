page 50000 ExportFixedAssetPage
{
    Caption = 'Export Fixed Asset';
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(asof; asof)
                {
                    ApplicationArea = all;
                    Caption = 'As of';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        iyear: Integer;
        imonth: Integer;
    begin
        iyear := DATE2DMY(TODAY, 3);
        imonth := DATE2DMY(TODAY, 2);
        asof := CALCDATE('-1D', DMY2DATE(1, imonth, iyear));
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        AccPer: Record "Accounting Period";
        FiscalStartingDate: Date;
    begin

        IF CloseAction = ACTION::OK THEN BEGIN
            IF asof = 0D THEN BEGIN
                MESSAGE('Please enter As of Date');
                EXIT(FALSE);
            END;

            AccPer.RESET;
            AccPer.SETRANGE("New Fiscal Year", TRUE);
            AccPer.SETRANGE(Closed, FALSE);
            AccPer.SETRANGE("Date Locked", TRUE);
            IF AccPer.FIND('-') THEN FiscalStartingDate := AccPer."Starting Date";
            IF asof < FiscalStartingDate THEN BEGIN
                MESSAGE('You cannot enter As of Date in the closed year.');
                EXIT(FALSE);
            END;
            InterfaceMessage.UpdateInterfaceMessage(1, 3, '-----Start Export Fixed Asset ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ' -----');
            ExportFixedAsset;
            InterfaceMessage.UpdateInterfaceMessage(1, 3, '-----End Export Fixed Asset  ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
            EXIT(TRUE);
        END;
    end;

    var
        asof: Date;
        logFileNameTime: Text[1024];
        MYXMLFILE: File;
        //FileOpen: Codeunit "File Management";
        Errormessage: Text[1024];
        //FileOperator: Codeunit "50001";
        LogFileName: Text[1024];
        isOK: Boolean;
        XMLOutStream: OutStream;
        InterfaceMessage: Codeunit "Interface Message";

    procedure ExportFixedAsset()
    var
        destFile: File;
        Filename: Text;
        backupfilename: Text;
        ExportFixAsset: XMLport ExportFixedAsset;

    begin
        //Clear(InterfaceMessage);
        /*
                LogFileName := GetFilePath() + '\LOG\AFWZD';
                Filename := GetFilePath() + '\INBOUND\AFWZD.TSV';
                backupfilename := GetFilePath() + '\Backup\AFWZD_' + FORMAT(CREATEDATETIME(TODAY, TIME), 0, '<Year4><Month,2><Day,2>') + '.TSV';
        */
        //XMLPort part
        ExportFixAsset.SetAsofDate(asof);
        ExportFixAsset.SETDESTINATION(XMLOutStream);
        ExportFixAsset.Filename := 'AFWZD_' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.tsv';
        ExportFixAsset.Run();

        /*isOK := ExportFixAsset.EXPORT;
        IF isOK THEN BEGIN
            InterfaceMessage.UpdateInterfaceMessage(1, 3, '-----End Export Fixed Asset  ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
        end;
       
                IF FileOperator.FileExists(Filename) THEN
                    IF NOT DIALOG.CONFIRM('%1 already exists \Do you want to replace it?      ', TRUE, Filename) THEN
                        EXIT;

                destFile.CREATE(Filename);
                destFile.CREATEOUTSTREAM(XMLOutStream);
                //XMLPort part
                ExportFixAsset.SetAsofDate(asof);
                ExportFixAsset.SETDESTINATION(XMLOutStream);
                isOK := ExportFixAsset.EXPORT;
                destFile.CLOSE;

                IF isOK THEN BEGIN


                    IF FILE.COPY(Filename, backupfilename) THEN BEGIN
                        FileOperator.SaveLogFile(LogFileName, 'Export file saved in ' + Filename, FALSE);
                        FileOperator.SaveLogFile(LogFileName, 'Backup file saved in ' + backupfilename, FALSE);

                        logFileNameTime := FileOperator.GetLogfile(LogFileName, TRUE);

                        FileOperator.SaveLogFile(LogFileName, 'Log file saved in ' + logFileNameTime, FALSE);
                        FileOperator.SaveLogFile(LogFileName, '-------EndTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + '----', FALSE);
                        FileOperator.SaveLogFile(LogFileName, '', FALSE);

                        FileOperator.MoveFile(FileOperator.GetLogfile(LogFileName, FALSE), logFileNameTime, TRUE);

                        HYPERLINK(logFileNameTime);


                    END;
                END
                ELSE BEGIN
                    Errormessage := GETLASTERRORTEXT;
                END;
                */
    end;

    local procedure GetFilePath() FilePath: Text
    var
        companyinfo: Record "Company Information";
    begin

        companyinfo.RESET;
        IF companyinfo.FINDFIRST THEN BEGIN
            FilePath := companyinfo."File Path";
        END;
    end;
}

