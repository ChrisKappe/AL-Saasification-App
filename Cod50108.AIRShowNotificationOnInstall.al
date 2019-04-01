codeunit 50108 "AIR ShowNotificationOnInstall"
{
    trigger OnRun()
    begin

    end;

    procedure ShowNotificationOnInstallApp()
    var
        MyNotifications: Record "My Notifications";
        MyNotification: Notification;
        NotificationMgt: Codeunit "Notification Management";
    begin

        IF MyNotifications.Get(USERID, GetNotificationGUID()) Then
            MyNotifications.Delete();

        MyNotifications.InsertDefault(GetNotificationGUID, 'Airport app set up', 'Notify if Airport app is not configured', true);
        If NOT MyNotifications.IsEnabled(GetNotificationGUID) THEN
            EXIT;

        WITH MyNotification DO BEGIN
            Id := GetNotificationGUID;
            Message := 'Congratulations! You have new Airport app installed. Do you want to setup it now?';
            Scope := NotificationScope::LocalScope;
            AddAction('Yes', CODEUNIT::"AIR Notifications Actions", 'RunSetup');
            AddAction('Do not show again', Codeunit::"AIR Notifications Actions", 'HideNotification');
            Send;
        END;

    end;


    local procedure GetNotificationGUID(): Guid
    begin
        EXIT('5aed0572-c004-425a-92c7-94fd820bc8b6');
    end;

}