codeunit 50106 "AIR Notifications Actions"
{
    procedure RunSetupWizard(var MyNotification: Notification);
    var
        Setup: page "AIR Setup Airport App Wizard";
    begin
        Setup.Run();
    end;

    procedure HideNotification(var MyNotification: Notification);
    var
        MyNotifications: Record "My Notifications";
        NotificationID: Guid;

    begin
        with MyNotifications do begin
            LOCKTABLE;
            NotificationID := MyNotification.ID;
            if Get(UserId, NotificationID) then begin
                Enabled := false;
                Modify;
            end;
        end;
    end;

}