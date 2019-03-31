page 50102 "AIR Setup"
{
    PageType = Card;
    SourceTable = "AIR Airport Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Airport App Setup';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("GroupName")
            {
                Caption = '';
                field("Default Airport"; "My Airport")
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
                ToolTipML = ENU = 'Update flights from Flightaware service';
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
                end;


            }
            action("Flights")
            {
                RunObject = page "AIR Flight List";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Warehouse;
                ApplicationArea = All;
            }

        }

    }


    var
    trigger OnOpenPage();
    var
    begin
        InsertIfNotExists();
    end;
}