codeunit 50005 "Interface Message"
{
    procedure UpdateInterfaceMessage(DataType: Option; DataName: Option; Message: Text[250])
    var
        InterfaceMessage: Record "Interface Message";
    begin
        InterfaceMessage.Init();
        InterfaceMessage."Entry No." := 0;
        InterfaceMessage."Data Type" := DataType;
        InterfaceMessage."Data Name" := DataName;
        InterfaceMessage."Created At" := CurrentDateTime;
        InterfaceMessage.Message := Message;
        InterfaceMessage.Insert();

    end;
}
