pageextension 50102 "AIR Airport Headline to BM RC" extends "Headline RC Business Manager" //MyTargetPageId
{
    layout
    {
        addlast(Content)
        {

            group("AIR AirportHeadline")
            {
                Visible = AirportHeadlineVisible;
                ShowCaption = false;
                Editable = false;

                field("AIR HowManyFlightsWillArriveTodayHeadlineText"; "HowManyFlightsWillArriveTodayHeadlineText")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnDrillDown();
                    var
                    begin
                        OnDrillDownHowManyFlightsWillArriveToday();
                    end;

                }
                field("AIR HowManyFlightsWillBeDelayedTodayHeadlineText"; "HowManyFlightsWillBeDelayedTodayHeadlineText")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnDrillDown();
                    var
                    begin
                        OnDrillDownHowManyFlightsWillBeDelayedToday();
                    end;
                }
            }
        }
    }

    var
        [InDataSet]
        AirportHeadlineVisible: Boolean;
        HowManyFlightsWillArriveTodayHeadlineText: Text;
        HowManyFlightsWillBeDelayedTodayHeadlineText: Text;


    trigger OnOpenPage()
    begin
        HandleVisibility();

        HandleHowManyFlightsWillArriveTodayHeadline();
        HandleHowManyFlightsWillBeDelayedTodayHeadline();


        OnSetVisibilityOfAirportApp(AirportHeadlineVisible);
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

    local procedure HandleHowManyFlightsWillBeDelayedTodayHeadline();
    var
        HeadlineManagement: Codeunit "Headline Management";
        PayloadText: Text;
        QualifierText: Text;
        Flight: Record "AIR Flight";
    begin
        PayloadText := 'Number of predicted delayes is ' + HeadlineManagement.Emphasize(FORMAT(Flight.GetNumberOfPredictedDelaysForToday));
        QualifierText := 'Predicted delays';
        HeadlineManagement.GetHeadlineText(QualifierText, PayloadText, HowManyFlightsWillBeDelayedTodayHeadlineText);

    end;

    local procedure OnDrillDownHowManyFlightsWillArriveToday();
    var
        Flight: Record "AIR Flight";
    begin
        Flight.DrillDownInPlannedArrivalsForToday();
    end;

    local procedure OnDrillDownHowManyFlightsWillBeDelayedToday();
    var
        Flight: Record "AIR Flight";
    begin
        Flight.DrillDownInPredictedDelaysForToday();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetVisibilityOfAirportApp(var AirportHeadlineVisible: Boolean)
    begin
    end;

}