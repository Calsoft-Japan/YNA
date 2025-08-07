pageextension 50579 PostApplicationExt extends "Post Application"
{
    layout
    {

    }
    var
        DocNo: Code[20];
        PostingDate: Date;

    procedure SetValues(NewDocNo: Code[20]; NewPostingDate: Date)
    begin
        DocNo := NewDocNo;
        PostingDate := NewPostingDate;
    end;

    procedure GetValues(var NewDocNo: Code[20]; var NewPostingDate: Date)
    begin
        NewDocNo := DocNo;
        NewPostingDate := PostingDate;
    end;
}
