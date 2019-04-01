page 50106 "AIR Headline RC Airport"
{
    PageType = HeadlinePart;

    layout
    {
        area(content)
        {
            group("AirportHeadline")
            {
                Visible = AirportHeadlineVisible;
                ShowCaption = false;
                Editable = false;

                field("HowManyFlightsWillArriveTodayHeadlineText"; "HowManyFlightsWillArriveTodayHeadlineText")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnDrillDown();
                    var
                    begin
                        OnDrillDownHowManyFlightsWillArriveToday();
                    end;

                }
            }
        }
    }

    var
        [InDataSet]
        AirportHeadlineVisible: Boolean;
        HowManyFlightsWillArriveTodayHeadlineText: Text;

    trigger OnOpenPage()
    begin
        HandleVisibility();

        HandleHowManyFlightsWillArriveTodayHeadline();

        OnSetVisibility(AirportHeadlineVisible);
    end;

    local procedure HandleVisibility()
    var
    begin
        AirportHeadlineVisible := true;
    end;

    local procedure HandleHowManyFlightsWillArriveTodayHeadline();
    var
        HeadlineManagement: Codeunit "Headline Management";
        PayloadText: Text;
        QualifierText: Text;
        Flight: Record "AIR Flight";
    begin
        PayloadText := 'Today will arrive ' + HeadlineManagement.Emphasize(FORMAT(Flight.GetPlannedArrivalsForToday)) + ' airplanes';
        QualifierText := 'Arrivals Today';
        HeadlineManagement.GetHeadlineText(QualifierText, PayloadText, HowManyFlightsWillArriveTodayHeadlineText);

    end;

    local procedure OnDrillDownHowManyFlightsWillArriveToday();
    var
        Flight: Record "AIR Flight";
    begin
        Flight.DrillDownInPlannedArrivalsForToday();
    end;


    [IntegrationEvent(false, false)]
    local procedure OnSetVisibility(var LittleAirportHeadlineVisible: Boolean)
    begin
    end;
}