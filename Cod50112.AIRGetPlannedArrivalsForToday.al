codeunit 50112 "AIR GetPlannedArrivalsForToday"
{
    procedure GetPlannedArrivalsForToday(): Integer
    var
    begin
        exit(DoGetPlannedArrivalsForToday());
    end;

    local procedure DoGetPlannedArrivalsForToday(): Integer
    var
        ActivitiesCue: Record "Activities Cue" temporary;
    begin
        With ActivitiesCue do begin
            SetRange("AIR Date Filter", Today());
            CalcFields("AIR Arrivals Today");
            exit("AIR Arrivals Today");
        end;
    end;

    procedure DrillDownInPlannedArrivalsForToday(): Integer
    var
        Flight: Record "AIR Flight";
    begin
        Flight.SetRange("Planned Arrival Date", Today());
        //Flight.SetFilter(Status, '<>%1', Flight.Status::Landed);
        Page.Run(0, Flight);
    end;

}