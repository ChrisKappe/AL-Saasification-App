codeunit 50111 "AIR GetFlightStatus"
{
    procedure GetStatus(var Flight: Record "AIR Flight"): Integer
    var
    begin
        WITH Flight Do begin
            If "Progress %" = 0 then
                EXIT(Status::"Did not take off");
            If "Progress %" = 100 then
                EXIT(Status::Landed);
            EXIT(Status::"In the air");
        end;
    end;

}