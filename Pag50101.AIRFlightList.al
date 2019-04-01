page 50101 "AIR Flight List"
{

    PageType = List;
    SourceTable = "AIR Flight";
    Caption = 'Flights';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Flight Number"; "Flight Number")
                {
                    ApplicationArea = All;
                }
                field("Airplane No."; "Airplane No.")
                {
                    ApplicationArea = All;
                }

                field("Departure"; "Departure")
                {
                    ApplicationArea = All;
                }
                field("Destination"; "Destination")
                {
                    ApplicationArea = All;
                }
                field("Status"; "Status")
                {
                    ApplicationArea = All;
                }

                field("Actual Departure Date"; "Actual Departure Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Departure Time"; "Actual Departure Time")
                {
                    ApplicationArea = All;
                }
                field("Actual Arrival Date"; "Actual Arrival Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Arrival Time"; "Actual Arrival Time")
                {
                    ApplicationArea = All;
                }
                field("Planned Departure Date"; "Planned Departure Date")
                {
                    ApplicationArea = All;
                }
                field("Planned Departure Time"; "Planned Departure Time")
                {
                    ApplicationArea = All;
                }
                field("Planned Arrival Date"; "Planned Arrival Date")
                {
                    ApplicationArea = All;
                }
                field("Planned Arrival Time"; "Planned Arrival Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("GetFlights")
            {
                CaptionML = ENU = 'Update flights';
                ToolTipML = ENU = 'Update flights from flightaware.com service';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = UpdateXML;
                trigger OnAction();
                var
                    Flight: Record "AIR Flight";
                begin
                    Flight.UpdateFlights();
                    CurrPage.Update;
                    if FindFirst then;

                end;
            }
        }
    }




}