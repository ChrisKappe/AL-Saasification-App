codeunit 50113 "AIR PredictDelays"
{

    procedure PredictDelays()
    var
    begin
        DoPredictDelays();
    end;

    local procedure DoPredictDelays()
    var
        Flight: Record "AIR Flight";
        IsDelayPredicted: Integer;
        Probability: Decimal;
    begin
        IF Flight.FindFirst() then
            repeat
                PredictIfFlightWillBeDelayedUsingML(Flight, IsDelayPredicted, Probability);
                Flight."Prediction Arrival Delay" := IsDelayPredicted;
                Flight."Probability %" := Probability;
                Flight.Modify();
            until Flight.Next() = 0;
    end;

    local procedure PredictIfFlightWillBeDelayedUsingML(Flight: Record "AIR Flight"; var IsDelayPredicted: Integer; var Probability: Decimal);
    var
        AzureMLConnector: Codeunit "Azure ML Connector";
        ResultInt: Integer;
        APIKey: text;
        Uri: Text;
        IsDelayPredictedTxt: Text;
        ProbabilityTxt: Text;
    begin
        APIKey := 'cwZn40CkuGgv16YZ0Y8Ea+gURQQ0GHhT8o1quCRMzbBANp28Rn64Ii2HTSJdjHqxBrN9kWvCIvyM2l1TbLKwNA==';
        Uri := 'https://europewest.services.azureml.net/workspaces/34d4c3e685704c51b0c14c79e4fd9f21/services/b8d3df5335e74fdc813b8ec96dbf71ef/execute?api-version=2.0&details=true';

        AzureMLConnector.Initialize(APIKey, Uri, 30);
        AzureMLConnector.SetInputName('input1');
        AzureMLConnector.SetOutputName('output1');

        AzureMLConnector.AddInputColumnName('month');
        AzureMLConnector.AddInputColumnName('day');
        AzureMLConnector.AddInputColumnName('dep_time');
        AzureMLConnector.AddInputColumnName('sched_dep_time');
        AzureMLConnector.AddInputColumnName('dep_delay');
        AzureMLConnector.AddInputColumnName('sched_arr_time');
        AzureMLConnector.AddInputColumnName('carrier');
        AzureMLConnector.AddInputColumnName('flight');
        AzureMLConnector.AddInputColumnName('tailnum');
        AzureMLConnector.AddInputColumnName('dest');
        AzureMLConnector.AddInputColumnName('origin');

        AzureMLConnector.AddInputRow();
        AzureMLConnector.AddInputValue(FORMAT(Date2DMY(Flight."Actual Departure Date", 2)));
        AzureMLConnector.AddInputValue(FORMAT(Date2DMY(Flight."Actual Departure Date", 1)));
        AzureMLConnector.AddInputValue(ConvertTimeToAMLFormat(Flight."Actual Departure Time"));
        AzureMLConnector.AddInputValue(ConvertTimeToAMLFormat(Flight."Planned Departure Time"));
        AzureMLConnector.AddInputValue(FORMAT(Flight.CalcDepartureDelay));
        AzureMLConnector.AddInputValue(ConvertTimeToAMLFormat(Flight."Planned Arrival Time"));
        AzureMLConnector.AddInputValue(Flight.airline_iata);
        AzureMLConnector.AddInputValue(Flight.flightnumber);
        AzureMLConnector.AddInputValue(Flight.tailnumber);
        AzureMLConnector.AddInputValue(Flight.Destination);
        AzureMLConnector.AddInputValue(Flight.Departure);

        AzureMLConnector.SendToAzureML();

        IF AzureMLConnector.GetOutput(1, 1, IsDelayPredictedTxt) then begin
            if IsDelayPredictedTxt = '' then
                IsDelayPredictedTxt := '0';
            Evaluate(IsDelayPredicted, IsDelayPredictedTxt);

        end;
        IF AzureMLConnector.GetOutput(1, 2, ProbabilityTxt) then begin
            if ProbabilityTxt = '' then
                ProbabilityTxt := '0';
            Evaluate(Probability, ProbabilityTxt);

        end;
        Probability := Probability * 100;
    end;

    local procedure ConvertTimeToAMLFormat(TimeInOriginalFormat: Text) TimeInAMLFormat: Text
    var
        Hours: Text;
        Minutes: Text;
    begin
        Hours := CopyStr(TimeInOriginalFormat, 1, 2);
        Minutes := CopyStr(TimeInOriginalFormat, 4, 2);
        If CopyStr(Hours, 1, 1) = '0' then
            Hours := CopyStr(Hours, 2, 1);
        TimeInAMLFormat := Hours + Minutes;
    end;

}