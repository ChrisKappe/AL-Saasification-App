tableextension 50101 "AIR AirportActivitiesCue" extends "Activities Cue"
{
    fields
    {

        field(50101; "AIR Arrivals Today"; Integer)
        {
            Caption = 'Arrivals today';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("AIR Flight" where ("Planned Arrival Date" = field ("AIR Date Filter")));

        }

        field(50104; "AIR Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }

    }

}