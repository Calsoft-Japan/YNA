tableextension 50027 "Item Ext" extends "Item"
{
    fields
    {
        field(50001; "Ctn per Pallet"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(50002; "Contain"; Decimal)
        {
        }
        field(50003; "Alcohol %"; Decimal)
        {
        }
        field(50004; "Sake Ratio"; Decimal)
        {
        }
        field(50005; "Acidity"; Decimal)
        {
        }
        field(50006; "Amino Acid"; Decimal)
        {
        }
        field(50007; "Genshu"; Decimal)
        {
        }
        field(50008; "Package"; Decimal)
        {
        }
        field(50009; "Tsumeguchi"; Decimal)
        {
        }
        field(50010; "Royalty"; Decimal)
        {
        }
        field(50011; "Federal Tax"; Decimal)
        {
        }
        field(50012; "State Tax"; Decimal)
        {
        }
        field(50013; "Pallet High"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(50014; "ParentItemCategory"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Category"."Parent Category" WHERE(Code = FIELD("Item Category Code")));
        }
    }
}

