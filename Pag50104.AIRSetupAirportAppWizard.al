page 50104 "AIR Setup Airport App Wizard"
{
    CaptionML = ENU = 'Set up Airplane app wizard';
    PageType = NavigatePage;
    SourceTable = "AIR Airport Setup";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("TopBannerOnFirstStep")
            {
                Visible = TopBannerVisible AND NOT FinalStepVisible;
                CaptionML = ENU = '';
                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group("TopBannerOnFinishStep")
            {
                Visible = TopBannerVisible AND FinalStepVisible;
                CaptionML = ENU = '';

                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group("Step1")
            {
                Visible = FirstStepVisible;
                group("Step1Welcome")
                {
                    Visible = FirstStepVisible;
                    CaptionML = ENU = 'Welcome to Airport app set up';
                    InstructionalTextML = ENU = 'This wizard will help you to configure app. After filling all fields, click Finish.';
                }
                group("Step1LetsGo")
                {
                    Visible = FirstStepVisible;
                    CaptionML = ENU = 'Lets Go!';
                    InstructionalTextML = ENU = 'Choose Next! Good Luck!';
                }
            }
            group("Step2")
            {
                Visible = SecondStepVisible;

                group("Step2Welcome")
                {
                    CaptionML = ENU = 'Welcome to Airport app set up';
                    Visible = SecondStepVisible;
                    group("Step2FillFields")
                    {
                        CaptionML = ENU = '';
                        InstructionalTextML = ENU = 'Fill in the following fields';
                        Visible = SecondStepVisible;

                        field("My Airport"; "My Airport")
                        {
                            ApplicationArea = All;
                        }

                        field("UploadFlights"; "UploadFlights")
                        {
                            ApplicationArea = All;
                            Caption = 'Update Flights';
                            ToolTip = 'Update Flights from flightaware.com. You should be connected to the internet!';
                        }

                    }

                }

            }
            group("StepFinal")
            {
                Visible = FinalStepVisible;
                group("That's it!")
                {
                    CaptionML = ENU = 'That''s it!';
                    InstructionalTextML = ENU = 'To use Airport App, click Finish.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("AIR ActionBack")
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NextStep(TRUE);
                end;
            }
            action("AIR ActionNext")
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NextStep(FALSE);
                end;
            }
            action("AIR ActionFinish")
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction();
                begin
                    FinishAction;
                end;
            }
        }
    }


    trigger OnInit();
    begin

        LoadTopBanners;
    end;

    trigger OnOpenPage();
    begin
        INSERT;

        Step := Step::Start;
        EnableControls;
    end;

    var
        MediaRepositoryStandard: Record 9400;
        MediaRepositoryDone: Record 9400;
        MediaResourcesStandard: Record 2000000182;
        MediaResourcesDone: Record 2000000182;
        Step: Option Start,Creation,Finish;
        TopBannerVisible: Boolean;
        FirstStepVisible: Boolean;
        SecondStepVisible: Boolean;
        FinalStepVisible: Boolean;
        FinishActionEnabled: Boolean;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        UploadFlights: Boolean;
        SelectAirportMsg: TextConst ENU = 'Please, fill your Airport code';

    local procedure EnableControls();
    begin

        CheckFilledValues();

        ResetControls;

        CASE Step OF
            Step::Start:
                ShowStartStep;
            Step::Creation:
                ShowSecondStep;
            Step::Finish:
                ShowFinalStep;
        END;
    end;

    local procedure NextStep(Backwards: Boolean);
    begin
        IF Backwards THEN
            Step := Step - 1
        ELSE
            Step := Step + 1;

        EnableControls;
    end;

    local procedure FinishAction();
    var
        Setup: Record "AIR Airport Setup";
    begin
        SaveInDatabase(Setup);
        UploadFlightsFromWebService();
        CurrPage.CLOSE;
    end;

    local procedure SaveInDatabase(var Setup: Record "AIR Airport Setup")
    var
    begin
        Setup.InsertIfNotExists();
        Setup.TransferFields(Rec);
        Setup.Modify();
    end;

    local procedure UploadFlightsFromWebService()
    var
        UpdateFlightsMgt: Codeunit "AIR UpdateFlights";
    begin
        if Not UploadFlights then
            exit;
        UpdateFlightsMgt.UpdateFlights();
    end;

    local procedure ShowStartStep();
    begin
        FirstStepVisible := TRUE;
        FinishActionEnabled := FALSE;
        BackActionEnabled := FALSE;
    end;

    local procedure ShowSecondStep();
    begin
        SecondStepVisible := TRUE;
        FinishActionEnabled := FALSE;
    end;

    local procedure ShowFinalStep();
    var
    begin
        FinalStepVisible := TRUE;
        BackActionEnabled := FALSE;
        NextActionEnabled := FALSE;
    end;

    local procedure ResetControls();
    begin
        FinishActionEnabled := TRUE;
        BackActionEnabled := TRUE;
        NextActionEnabled := TRUE;

        FirstStepVisible := FALSE;
        SecondStepVisible := FALSE;
        FinalStepVisible := FALSE;
    end;

    local procedure LoadTopBanners();
    begin
        IF MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png', FORMAT(CURRENTCLIENTTYPE)) AND
           MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png', FORMAT(CURRENTCLIENTTYPE))
        THEN
            IF MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
               MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
            THEN
                TopBannerVisible := MediaResourcesDone."Media Reference".HASVALUE;
    end;

    local procedure SetFieldsEditable();
    var
    begin

    end;

    local procedure CheckFilledValues()
    begin
        IF Step = Step::Finish THEN BEGIN
            If "My Airport" = '' THEN BEGIN
                MESSAGE(SelectAirportMsg);
                Step := Step - 1;
                EXIT;
            END;

        END;
    end;
}
