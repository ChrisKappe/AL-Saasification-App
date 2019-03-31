table 50101 "AIR Airport Setup"
{
    Caption = 'Airport App Setup';

    fields
    {
        field(1; "Code"; Code[20])
        {

        }
        field(11; "My Airport"; Code[20])
        {

        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    var
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;

    procedure GetDefaultAirport(): Code[20]
    begin
        IF get then
            exit("My Airport");
        exit('');
    end;
}