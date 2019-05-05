codeunit 50103 "AIR ManageAssistedSetup"
{

    [EventSubscriber(ObjectType::Table, Database::"Aggregated Assisted Setup", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure RegisterAIRSetupInAssistedSetupList(var TempAggregatedAssistedSetup: Record "Aggregated Assisted Setup")
    var
        MyAppSetup: Record "AIR Airport Setup";
    begin

        TempAggregatedAssistedSetup.AddExtensionAssistedSetup(50104, 'Set up Airplane App Wizard', true, MyAppSetup.RecordId(), GetStatus(), '');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Aggregated Assisted Setup", 'OnUpdateAssistedSetupStatus', '', false, false)]
    local procedure UpdateLittleAppAssistedSetupStatus(var TempAggregatedAssistedSetup: Record "Aggregated Assisted Setup")
    begin
        TempAggregatedAssistedSetup.SetStatus(TempAggregatedAssistedSetup, Page::"AIR Setup Airport App Wizard", GetStatus());
    end;

    local procedure GetStatus(): Integer
    var
        Status: Boolean;
        MyAppSetup: Record "AIR Airport Setup";
        TempAggregatedAssistedSetup: Record "Aggregated Assisted Setup";
    begin
        MyAppSetup.InsertIfNotExists();
        Status := MyAppSetup."My Airport" <> '';

        Case Status of
            false:
                Exit(TempAggregatedAssistedSetup.Status::"Not Completed");
            true:
                Exit(TempAggregatedAssistedSetup.Status::Completed);
        end;
    end;
}