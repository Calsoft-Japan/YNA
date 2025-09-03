codeunit 50010 Eventsubscriber
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnModifyOnBeforeTestCheckPrinted, '', false, false)]
    local procedure "Gen. Journal Line_OnModifyOnBeforeTestCheckPrinted"(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if GenJnlBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then begin
            if GenJnlBatch.Name = 'ACH' then
                IsHandled := true;
        end;
    end;
}
