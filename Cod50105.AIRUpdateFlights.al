codeunit 50105 "AIR UpdateFlights"
{
    procedure UpdateFlights()
    var
    begin
        DoUpdateFlights();
    end;

    local procedure DoUpdateFlights()
    var
    begin
        UpdateArrivals();
    end;

    local procedure UpdateArrivals()
    begin
        GetArrivals(GetDefaultAirport());
    end;

    local procedure GetDefaultAirport(): Code[20]
    var
        Setup: Record "AIR Airport Setup";
    begin
        EXIT(Setup.GetDefaultAirport());
    end;

    local procedure GetArrivals(ToAirport: Code[20]);
    var
    begin
        GetArrivalsFromFlightAwareInXML3Format(ToAirport);
    end;

    local procedure GetArrivalsFromFlightAwareInXML3Format(ToAirport: Code[20]);
    var
        Arguments: Record "AIR WebService Argument";
    begin
        InitArguments(Arguments, STRSUBSTNO('AirportBoards?airport_code=%1&type=arrivals&howMany=100', ToAirport));//change request here
        IF not CallWebService(Arguments) then
            EXIT;
        SaveResultInAirportFlightTable(Arguments);
    end;

    local procedure InitArguments(var Arguments: Record "AIR WebService Argument" temporary; APIRequest: Text);
    var
    begin
        WITH Arguments DO begin
            URL := STRSUBSTNO('%1%2', GetBaseURL, APIRequest);
            RestMethod := RestMethod::get;
            UserName := GetUserName;
            Password := GetAPIKey;
        end;
    end;

    local procedure GetBaseURL(): Text;
    var
    begin
        EXIT('https://flightxml.flightaware.com/json/FlightXML3/');
    end;

    local procedure GetUserName(): Text;
    var
    begin
        EXIT('dkatson'); //change for setup
    end;

    local procedure GetAPIKey(): Text;
    var
    begin
        EXIT('f7217091a2bdc7fda21686a1f157afa9a11e6d01'); //change for setup
    end;

    local procedure CallWebService(var Arguments: Record "AIR WebService Argument" temporary) Success: Boolean
    var
        WebService: codeunit "AIR WebService Call Functions";
    begin
        Success := WebService.CallWebService(Arguments);
    end;

    local procedure SaveResultInAirportFlightTable(var Arguments: Record "AIR WebService Argument" temporary)
    var
        Flight: Record "AIR Flight";
        WebService: Codeunit "AIR WebService Call Functions";
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        i: Integer;
        ResponseInTextFormat: Text;
    begin
        ResponseInTextFormat := Arguments.GetResponseContentAsText;
        //Message(ResponseInTextFormat);

        HandleResponseForJsonArrayFormat(ResponseInTextFormat);
        Flight.DeleteAll;
        If not JsonArray.ReadFrom(ResponseInTextFormat) then
            error('Invalid response, expected an JSON array as root object');



        For i := 0 to JsonArray.Count - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonObject := JsonToken.AsObject;
            WITH Flight do begin
                //WebService.GetJsonToken(JsonObject,'country_code').AsValue.AsText; //if field
                //WebService.SelectJsonToken(JsonObject,'$.user.login').AsValue.AsText; //if nested structure
                if JsonObject.GET('ident', JsonToken) THEN begin
                    INIT;
                    "Flight Number" := WebService.GetJsonValueAsText(JsonObject, 'ident');
                    //Departure := WebService.SelectJsonValueAsText(JsonObject, '$.origin.alternate_ident');
                    Departure := COPYSTR(WebService.SelectJsonValueAsText(JsonObject, '$.origin.code'), 2, 3);
                    //Destination := WebService.SelectJsonValueAsText(JsonObject, '$.destination.alternate_ident');
                    Destination := COPYSTR(WebService.SelectJsonValueAsText(JsonObject, '$.destination.code'), 2, 3);
                    ConvertFromTextToDate("Planned Departure Date", WebService.SelectJsonValueAsText(JsonObject, '$.estimated_departure_time.date'));
                    "Planned Departure Time" := WebService.SelectJsonValueAsText(JsonObject, '$.estimated_departure_time.time');
                    ConvertFromTextToDate("Planned Arrival Date", WebService.SelectJsonValueAsText(JsonObject, '$.estimated_arrival_time.date'));
                    "Planned Arrival Time" := WebService.SelectJsonValueAsText(JsonObject, '$.estimated_arrival_time.time');
                    ConvertFromTextToDate("Actual Departure Date", WebService.SelectJsonValueAsText(JsonObject, '$.filed_departure_time.date'));
                    "Actual Departure Time" := WebService.SelectJsonValueAsText(JsonObject, '$.filed_departure_time.time');
                    ConvertFromTextToDate("Actual Arrival Date", WebService.SelectJsonValueAsText(JsonObject, '$.actual_arrival_time.date'));
                    "Actual Arrival Time" := WebService.SelectJsonValueAsText(JsonObject, '$.actual_arrival_time.time');
                    "Aircraft Type" := WebService.GetJsonValueAsText(JsonObject, 'aircrafttype');
                    "Progress %" := WebService.GetJsonValueAsDecimal(JsonObject, 'progress_percent');
                    "Distance" := WebService.GetJsonValueAsDecimal(JsonObject, 'distance_filed');
                    "Destination City" := WebService.SelectJsonValueAsText(JsonObject, '$.destination.city');
                    "Flight ID" := WebService.GetJsonValueAsText(JsonObject, 'faFlightID');
                    "airline_iata" := WebService.GetJsonValueAsText(JsonObject, 'airline_iata');
                    "flightnumber" := WebService.GetJsonValueAsText(JsonObject, 'flightnumber');
                    "tailnumber" := WebService.GetJsonValueAsText(JsonObject, 'tailnumber');
                    "departure_delay" := WebService.SelectJsonValueAsText(JsonObject, '$.departure_delay');

                    Status := GetStatus();
                    INSERT;
                end;
            end;
        end;


    end;

    local procedure HandleResponseForJsonArrayFormat(var Response: Text);
    var
        CopyFrom: Integer;
        CopyTo: Integer;
    begin
        CopyFrom := GetStartPositionOfJsonArray(Response);
        CopyTo := GetLastPositionOfJsonArray(Response);
        IF CopyTo > CopyFrom then
            Response := CopyStr(Response, CopyFrom, CopyTo - CopyFrom + 1);
    end;

    local procedure GetStartPositionOfJsonArray(Response: Text): Integer;
    var
    begin
        EXIT(STRPOS(Response, '['));
    end;

    local procedure GetLastPositionOfJsonArray(Response: Text): Integer;
    var
    begin
        EXIT(STRPOS(Response, ']'));
    end;

    local procedure ConvertFromTextToDate(var DateInDateFormat: Date; DateInTextFormat: Text)
    var
        dayValue: Integer;
        monthValue: Integer;
        yearValue: Integer;
    begin
        if DateInTextFormat = '' then begin
            DateInDateFormat := 0D;
            exit;
        end;
        if StrLen(DateInTextFormat) <> 10 then
            Error('Wrong format. Date value should be in format dd.mm.yyyy');
        Evaluate(dayValue, CopyStr(DateInTextFormat, 1, 2));
        Evaluate(monthValue, CopyStr(DateInTextFormat, 4, 2));
        Evaluate(yearValue, CopyStr(DateInTextFormat, 7, 4));
        DateInDateFormat := DMY2Date(dayValue, monthValue, yearValue);
    end;
}