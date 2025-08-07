page 50001 ExportGLEntry
{
    Caption = 'Export GL Entry';
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
                field(ConditionPostingDateFrom; ConditionPostingDateFrom)
                {
                    ApplicationArea = all;
                    Caption = 'Posting Date (From):';
                }
                field(ConditionPostingDateTo; ConditionPostingDateTo)
                {
                    ApplicationArea = all;
                    Caption = 'Posting Date (To):';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var
        iyear: Integer;
        imonth: Integer;
    begin
        iyear := DATE2DMY(TODAY, 3);
        imonth := DATE2DMY(TODAY, 2);
        ConditionPostingDateTo := CALCDATE('-1D', DMY2DATE(1, imonth, iyear));
        ConditionPostingDateFrom := CALCDATE('-8M', DMY2DATE(1, imonth, iyear));
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction = ACTION::OK THEN BEGIN
            InterfaceMessage.UpdateInterfaceMessage(1, 2, '-----Start Export G/L Entry (' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
            ExportGLEntry;
            InterfaceMessage.UpdateInterfaceMessage(1, 2, '-----End Export G/L Entry ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
            EXIT(TRUE);
        END;
    end;

    var
        ConditionPostingDate: Text[250];
        logFileNameTime: Text[1024];
        MYXMLFILE: File;
        //FileOpen: Codeunit "File Management";
        Errormessage: Text[1024];
        //FileOperator: Codeunit "50001";
        LogFileName: Text[1024];
        isOK: Boolean;
        XMLOutStream: OutStream;
        ConditionPostingDateFrom: Date;
        ConditionPostingDateTo: Date;
        InterfaceMessage: Codeunit "Interface Message";

    procedure ExportGLEntry()
    var
        destFile: File;
        Filename: Text;
        showmessageFilename: Text;
        Backupfilename: Text;
        BackupfilenameTmp: Text;
        ExportGLEntry: XMLport ExportGLEntry;
    begin
        /*
        LogFileName := GetFilePath() + '\LOG\AKFGX';
        Filename := GetFilePath() + '\INBOUND\AKFGX.TSV';
        BackupfilenameTmp := FORMAT(ConditionPostingDateFrom, 0, '<Year4><Month,2><Day,2>') + '-' + FORMAT(ConditionPostingDateTo, 0, '<Year4><Month,2><Day,2>');
        Backupfilename := GetFilePath() + '\Backup\AKFGX_' + BackupfilenameTmp + '.TSV';
        
        /*
        IF FileOperator.FileExists(Filename) THEN
            IF NOT DIALOG.CONFIRM('%1 already exists \Do you want to replace it?      ', TRUE, Filename) THEN
                EXIT;

        destFile.CREATE(Filename);
        destFile.CREATEOUTSTREAM(XMLOutStream);
*/
        //XMLPort part
        //Set Posting Date Filter
        ConditionPostingDate := FORMAT(ConditionPostingDateFrom) + '..' + FORMAT(ConditionPostingDateTo) + '&>6/30/2016';
        ExportGLEntry.SetpostingdateFilter(ConditionPostingDate);

        //Export
        ExportGLEntry.SETDESTINATION(XMLOutStream);
        ExportGLEntry.Filename := 'AKFGX_' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.tsv';
        ExportGLEntry.Run();
        /*destFile.CLOSE;

        IF isOK THEN BEGIN
            IF FILE.COPY(Filename, Backupfilename) THEN BEGIN

                FileOperator.SaveLogFile(LogFileName, 'Export file saved in ' + Filename, FALSE);
                FileOperator.SaveLogFile(LogFileName, 'Backup file saved in ' + Backupfilename, FALSE);

                logFileNameTime := FileOperator.GetLogfile(LogFileName, TRUE);

                FileOperator.SaveLogFile(LogFileName, 'Log file saved in ' + logFileNameTime, FALSE);
                FileOperator.SaveLogFile(LogFileName, '-------End Export G/L Entry ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ' ---------', FALSE);

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

