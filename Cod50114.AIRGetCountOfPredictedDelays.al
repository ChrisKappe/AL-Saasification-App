codeunit 50114 "AIR GetCountOfPredictedDelays"
{

    procedure GetNumberOfPredictedDelaysForToday(): Integer
    var
        Flights: Record "AIR Flight";
    begin
        Flights.SetRange("Planned Arrival Date", TODAY);
        Flights.SetRange("Prediction Arrival Delay", Flights."Prediction Arrival Delay"::Delay);
        exit(Flights.Count());
    end;

    procedure DrillDownInPredictedDelaysForToday(): Integer
    var
        Flights: Record "AIR Flight";
    begin
        Flights.SetRange("Planned Arrival Date", TODAY);
        Flights.SetRange("Prediction Arrival Delay", Flights."Prediction Arrival Delay"::Delay);
        Page.Run(0, Flights);
    end;

}