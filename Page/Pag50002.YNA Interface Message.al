page 50002 "YNA Interface Message"
{
    Editable = false;
    PageType = List;
    SourceTable = "Interface Message";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'YNA Interface Message';
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Data Type"; Rec."Data Type")
                {
                }
                field("Data Name"; Rec."Data Name")
                {
                }
                field("Created At"; Rec."Created At")
                {
                }
                field(Message; Rec.Message)
                {
                }
            }
        }
    }

    actions
    {
    }
}

