codeunit 50006 "Delete Interface Message"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        InterfaceMessage: Record "Interface Message";
        dateType: DateFormula;
        endDate: Date;
    begin
        if Rec."Parameter String" <> '' then begin
            if Evaluate(dateType, Rec."Parameter String") then begin
                endDate := CalcDate('<-' + Format(dateType) + '>', Today);
                InterfaceMessage.Reset();
                InterfaceMessage.SetFilter("Created At", '<=%1', CREATEDATETIME(endDate, 235959T));
                InterfaceMessage.DeleteAll();
            end else begin
                Error('Parameter String is not Date Formula.');
            end;
        end
        else begin
            Error('Parameter String must not be blank.');
        end;
    end;


}
