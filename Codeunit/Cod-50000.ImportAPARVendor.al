codeunit 50000 ImportAPARVendor
{

    trigger OnRun()
    begin
        //ImportVendor();
        //ImportGenJournalLine();
    end;

    var
        logFileNameTime: Text[1024];
        //XMLPortAPARGEN: XMLport "50004";
        MYXMLFILE: File;
        xlsFileName: Text[1024];
        FileOpen: Codeunit "File Management";
        Errormessage: Text[1024];
        //FileOperator: Codeunit "50001";
        LogFileName: Text[1024];
        isOK: Boolean;
        companyinfo: Record "Company Information";
        InterfaceMessage: Codeunit "Interface Message";
        ImportXmlFile: Codeunit "File Management";
        XMLinStream: InStream;
        XmlOutStream: OutStream;
        tempblobb: Codeunit "Temp Blob";
        clientfile: Text;
        XMLFileTEXT: BigText;
        MessageText: Text;
        importText: Label 'Data import finished.';
        importTextErr: Label 'Data import finished with errors. Please see YNA Interface Message page for details.';

    procedure ImportVendor()
    begin
        //bobby FDD101 Begin
        if UploadIntoStream('Choose TSV Template', 'c:\', 'TSV|*.TSV', xlsFileName, XMLinStream) then begin
            isOK := XMLPORT.IMPORT(XMLPORT::ImportVendorData, XMLinStream);
            Errormessage := GETLASTERRORTEXT;

            IF STRPOS(Errormessage, 'OK') > 0 THEN BEGIN
                MessageText := importText;
            END
            ELSE begin
                IF STRPOS(Errormessage, 'ErrorMessage') > 0 THEN BEGIN
                    MessageText := importTextErr;
                END
                ELSE begin
                    MessageText := Errormessage;
                    InterfaceMessage.UpdateInterfaceMessage(0, 0, Errormessage);
                end;
            end;
            InterfaceMessage.UpdateInterfaceMessage(0, 0, '-----End Import Vendor Card (' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
            Message(MessageText);
        end;

        //bobby FDD101 End

        /*
        // hcj CS1.0
        IF STRPOS(Errormessage, 'OK') > 0 THEN BEGIN
            //FileOpen.DeleteClientFile(xlsFileName);
        END
        ELSE BEGIN
            IF STRPOS(Errormessage, '#*#') <= 0 THEN BEGIN
                InterfaceMessage.UpdateInterfaceMessage(0, 0, '-----End Import Vendor Card (' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
            END
        END;

        // hcj CS1.0 end;
        */
    end;
    /*
        procedure ImportSalesJournal()
        begin

            // hcj CS1.0

            xlsFileName := FileOpen.OpenFileDialog('Choose Import file', '*.TSV', 'TSV|TSV');
            IF (STRLEN(xlsFileName) = 0) THEN
                EXIT
            ELSE IF (STRPOS(UPPERCASE(xlsFileName), '.TSV') = 0) THEN BEGIN
                MESSAGE('The import file must be TSV file.');
                EXIT;
            END;



            companyinfo.RESET;
            companyinfo.FINDFIRST;
            LogFileName := companyinfo."File Path" + '\Log\GL';


            MYXMLFILE.OPEN(xlsFileName);
            MYXMLFILE.CREATEINSTREAM(XMLinStream);


            CLEARLASTERROR;

            //XMLPortAPARGEN.setJournaltype('Sales');
            //XMLPortAPARGEN.SETSOURCE(XMLinStream);
            //XMLPortAPARGEN.IMPORT;
            isOK := XMLPORT.IMPORT(XMLPORT::ImportGenJournalImport, XMLinStream);


            Errormessage := GETLASTERRORTEXT;

            MYXMLFILE.CLOSE();

            IF STRPOS(Errormessage, 'OK') > 0 THEN BEGIN
                FileOpen.DeleteClientFile(xlsFileName);
            END
            ELSE BEGIN
                IF STRPOS(Errormessage, '#*#') <= 0 THEN BEGIN
                    FileOperator.SaveLogFile(LogFileName, Errormessage, FALSE);

                    logFileNameTime := FileOperator.GetLogfile(LogFileName, TRUE);

                    FileOperator.SaveLogFile(LogFileName, 'Log file saved in ' + logFileNameTime, FALSE);
                    FileOperator.SaveLogFile(LogFileName, '-------EndTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + '----', FALSE);
                    FileOperator.SaveLogFile(LogFileName, '', FALSE);

                    FileOperator.MoveFile(FileOperator.GetLogfile(LogFileName, FALSE), logFileNameTime, TRUE);

                    HYPERLINK(logFileNameTime);
                END

            END;



            // hcj CS1.0 end;
        end;

        procedure ImportPurchaseJournal()
        begin

            // hcj CS1.0

            xlsFileName := FileOpen.OpenFileDialog('Choose Purchase Journal Template', '*.TSV', 'TSV|TSV');
            IF (STRLEN(xlsFileName) = 0) THEN
                EXIT
            ELSE IF (STRPOS(UPPERCASE(xlsFileName), '.TSV') = 0) THEN BEGIN
                MESSAGE('The import file must be TSV file.');
                EXIT;
            END;


            companyinfo.RESET;
            companyinfo.FINDFIRST;
            LogFileName := companyinfo."File Path" + '\Log\GL';



            FileOperator.SaveLogFile(LogFileName, 'Starting import Vendor ', FALSE);
            FileOperator.SaveLogFile(LogFileName, '-------StartTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ' ---------', FALSE);
            FileOperator.SaveLogFile(LogFileName, 'Reading file:' + xlsFileName, FALSE);

            MYXMLFILE.OPEN(xlsFileName);
            MYXMLFILE.CREATEINSTREAM(XMLinStream);


            CLEARLASTERROR;

            XMLPortAPARGEN.setJournaltype('Purchase');
            XMLPortAPARGEN.SETSOURCE(XMLinStream);
            XMLPortAPARGEN.IMPORT;
            //isOK :=  XMLPORT.IMPORT(XMLPORT::ImportVendorData, XMLinStream);


            Errormessage := GETLASTERRORTEXT;

            MYXMLFILE.CLOSE();

            IF STRPOS(Errormessage, 'OK') > 0 THEN BEGIN
                FileOpen.DeleteClientFile(xlsFileName);
            END
            ELSE BEGIN
                IF STRPOS(Errormessage, '#*#') <= 0 THEN BEGIN
                    FileOperator.SaveLogFile(LogFileName, Errormessage, FALSE);

                    logFileNameTime := FileOperator.GetLogfile(LogFileName, TRUE);

                    FileOperator.SaveLogFile(LogFileName, 'Log file saved in ' + logFileNameTime, FALSE);
                    FileOperator.SaveLogFile(LogFileName, '-------EndTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + '----', FALSE);
                    FileOperator.SaveLogFile(LogFileName, '', FALSE);

                    FileOperator.MoveFile(FileOperator.GetLogfile(LogFileName, FALSE), logFileNameTime, TRUE);

                    HYPERLINK(logFileNameTime);
                END
            END;

            // hcj CS1.0 end;
        end;
*/
    procedure ImportGenJournalLine()
    begin
        //bobby FDD101 Begin
        if UploadIntoStream('Choose TSV Template', 'c:\', 'TSV|*.TSV', xlsFileName, XMLinStream) then begin
            //InterfaceMessage.UpdateInterfaceMessage(0, 0, '-----Starting Import GL/AP/AR (' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
            isOK := XMLPORT.IMPORT(XMLPORT::ImportGenJournalImport, XMLinStream);
            Errormessage := GETLASTERRORTEXT;
            IF STRPOS(Errormessage, 'OK') > 0 THEN BEGIN
                MessageText := importText;
            END
            ELSE begin
                IF STRPOS(Errormessage, 'ErrorMessage') > 0 THEN BEGIN
                    MessageText := importTextErr;
                END
                ELSE begin
                    MessageText := Errormessage;
                    InterfaceMessage.UpdateInterfaceMessage(0, 1, Errormessage);
                end;
            end;
            InterfaceMessage.UpdateInterfaceMessage(0, 1, '-----End Import GL/AP/AR (' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');

            Message(MessageText);

        end;

        //bobby FDD101 End

        // hcj CS1.0
        /*
                xlsFileName := FileOpen.OpenFileDialog('Choose Import file', '*.TSV', 'TSV|TSV');
                IF (STRLEN(xlsFileName) = 0) THEN
                    EXIT
                ELSE IF (STRPOS(UPPERCASE(xlsFileName), '.TSV') = 0) THEN BEGIN
                    MESSAGE('The import file must be TSV file.');
                    EXIT;
                END;

                companyinfo.RESET;
                companyinfo.FINDFIRST;
                LogFileName := companyinfo."File Path" + '\Log\GL';

                FileOperator.SaveLogFile(LogFileName, 'Starting import Gen. Journal ', FALSE);
                FileOperator.SaveLogFile(LogFileName, '-------StartTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ' ---------', FALSE);
                FileOperator.SaveLogFile(LogFileName, 'Reading file:' + xlsFileName, FALSE);


                MYXMLFILE.OPEN(xlsFileName);
                MYXMLFILE.CREATEINSTREAM(XMLinStream);


                CLEARLASTERROR;

                //XMLPortAPARGEN.setJournaltype('Sales');
                //XMLPortAPARGEN.SETSOURCE(XMLinStream);
                //XMLPortAPARGEN.IMPORT;
                isOK := XMLPORT.IMPORT(XMLPORT::ImportGenJournalImport, XMLinStream);


                Errormessage := GETLASTERRORTEXT;

                MYXMLFILE.CLOSE();
        

        IF STRPOS(Errormessage, 'OK') > 0 THEN BEGIN
            //FileOpen.DeleteClientFile(xlsFileName);
        END
        ELSE BEGIN
            IF STRPOS(Errormessage, '#*#') <= 0 THEN BEGIN
                InterfaceMessage.UpdateInterfaceMessage(0, 0, '-----End Import GL/AP/AR (' + FORMAT(CREATEDATETIME(TODAY, TIME)) + ')-----');
                //*FileOperator.SaveLogFile(LogFileName, Errormessage, FALSE);

                logFileNameTime := FileOperator.GetLogfile(LogFileName, TRUE);

                FileOperator.SaveLogFile(LogFileName, 'Log file saved in ' + logFileNameTime, FALSE);
                FileOperator.SaveLogFile(LogFileName, '-------EndTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + '----', FALSE);
                FileOperator.SaveLogFile(LogFileName, '', FALSE);

                FileOperator.MoveFile(FileOperator.GetLogfile(LogFileName, FALSE), logFileNameTime, TRUE);

                HYPERLINK(logFileNameTime);
                //*
            END

        END;



        // hcj CS1.0 end;
        */
    end;
    /*
            procedure ExportFixedAsset()
            var
                destFile: File;
                Filename: Text;
                backupfilename: Text;
                isOK: Boolean;
                ExportFixAsset: XMLport "50005";
            begin


                LogFileName := GetFilePath() + '\Export\LOG\Fixed Asset';
                Filename := GetFilePath() + '\Export\Fixed Asset';
                backupfilename := GetFilePath() + '\Export\Backup\Fixed Asset';

                destFile.CREATE(Filename);
                destFile.CREATEOUTSTREAM(XMLOutStream);
                //XMLPort part
                ExportFixAsset.RUN;
                //      isOK := XMLPORT.EXPORT(XMLPORT::ExportFixedAsset,XMLOutStream);
                destFile.CLOSE;

                IF isOK THEN BEGIN


                    IF FILE.COPY(Filename, backupfilename) THEN BEGIN
                        FileOperator.SaveLogFile(LogFileName, 'Export file saved in ' + Filename, FALSE);
                        FileOperator.SaveLogFile(LogFileName, 'Backup file saved in ' + backupfilename, FALSE);
                        FileOperator.SaveLogFile(LogFileName, '-------EndTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + '----', FALSE);
                        FileOperator.SaveLogFile(LogFileName, '', FALSE);

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


                HYPERLINK(Filename); //To open the file when it is done
            end;

            procedure ExportGenLE()
            var
                destFile: File;
                Filename: Text;
                backupfilename: Text;
                isOK: Boolean;
                ExportFixAsset: XMLport "50005";
                CRLF: Text[2];
            begin


                LogFileName := GetFilePath() + '\Export\LOG\Fixed Asset';
                Filename := GetFilePath() + '\Export\Fixed Asset';
                backupfilename := GetFilePath() + '\Export\Backup\Fixed Asset';

                destFile.CREATE(Filename);
                destFile.CREATEOUTSTREAM(XMLOutStream);
                //XMLPort part
                ExportFixAsset.RUN;
                //      isOK := XMLPORT.EXPORT(XMLPORT::ExportFixedAsset,XMLOutStream);
                destFile.CLOSE;

                IF isOK THEN BEGIN


                    IF FILE.COPY(Filename, backupfilename) THEN BEGIN
                        FileOperator.SaveLogFile(LogFileName, 'Export file saved in ' + Filename, FALSE);
                        FileOperator.SaveLogFile(LogFileName, 'Backup file saved in ' + backupfilename, FALSE);
                        FileOperator.SaveLogFile(LogFileName, '-------EndTime: ' + FORMAT(CREATEDATETIME(TODAY, TIME)) + '----', FALSE);
                        FileOperator.SaveLogFile(LogFileName, '', FALSE);

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


                HYPERLINK(Filename); //To open the file when it is done
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

            */
}

