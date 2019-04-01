table 50100 "AIR Flight"
{
    Caption = 'Flight';
    DrillDownPageId = "AIR Flight List";
    LookupPageId = "AIR Flight List";

    fields
    {
        field(1; "Flight Number"; Code[20])
        {
            Caption = 'Flight number';
        }
        field(7; "Departure"; Code[20])
        {
            Caption = 'Departure airport';
        }

        field(8; "Destination"; Code[20])
        {
            Caption = 'Destination airport';

        }

        field(9; "Airplane No."; Code[20])
        {
            Caption = 'Airplane No.';
        }

        field(11; "Actual Departure Date"; Date)
        {
            Caption = 'Actual departure date';

        }
        field(12; "Actual Departure Time"; Text[30])
        {
            Caption = 'Actual departure time';

        }
        field(13; "Actual Arrival Date"; Date)
        {
            Caption = 'Actual arrival date';

        }
        field(14; "Actual Arrival Time"; Text[30])
        {
            Caption = 'Actual arrival date';

        }

        field(15; "Planned Departure Date"; Date)
        {
            Caption = 'Planned departure date';

        }
        field(16; "Planned Departure Time"; Text[30])
        {
            Caption = 'Planned departure time';

        }
        field(17; "Planned Arrival Date"; Date)
        {
            Caption = 'Planned arrival date';

        }
        field(18; "Planned Arrival Time"; Text[30])
        {
            Caption = 'Planned arrival date';

        }

        field(20; "Status"; Option)
        {
            OptionMembers = "Did not take off","In the air","Landed";
            OptionCaption = 'Did not take off,In the air,Landed';
        }
        field(21; "Aircraft Type"; text[20])
        {
            CaptionML = ENU = 'Aircraft type';

        }
        field(22; "Progress %"; Decimal)
        {
            CaptionML = ENU = 'Progress %';
        }
        field(23; "Distance"; Decimal)
        {
            CaptionML = ENU = 'Distance';
        }

        field(24; "Destination City"; text[50])
        {
            CaptionML = ENU = 'Destination City';
        }

        field(25; "Flight ID"; Text[50])
        {
            CaptionML = ENU = 'Flight ID';
        }

        field(26; "airline_iata"; Text[50])
        {

        }
        field(27; "flightnumber"; Text[50])
        {

        }
        field(28; "tailnumber"; Text[50])
        {

        }
        field(29; "departure_delay"; Text[50])
        {

        }


    }

    keys
    {
        key(PK; "Flight Number")
        {
            Clustered = true;
        }
    }

    procedure UpdateFlights()
    var
        UpdateFlights: Codeunit "AIR UpdateFlights";
    begin
        UpdateFlights.UpdateFlights();
    end;

    procedure GetStatus(): Integer;
    var
        GetFlightStatus: Codeunit "AIR GetFlightStatus";
    begin
        EXIT(GetFlightStatus.GetStatus(Rec));
    end;

    procedure GetPlannedArrivalsForToday(): Integer
    var
        GetPlannedArrivalsForToday: Codeunit "AIR GetPlannedArrivalsForToday";
    begin
        exit(GetPlannedArrivalsForToday.GetPlannedArrivalsForToday())
    end;

    procedure DrillDownInPlannedArrivalsForToday()
    var
        GetPlannedArrivalsForToday: Codeunit "AIR GetPlannedArrivalsForToday";
    begin
        GetPlannedArrivalsForToday.DrillDownInPlannedArrivalsForToday();
    end;
}