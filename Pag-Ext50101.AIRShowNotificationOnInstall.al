pageextension 50101 "AIR ShowNotificationOnInstall" extends "O365 Activities"
{
    trigger OnOpenPage()
    var
        ShowNotificationOnInstallApp: Codeunit "AIR ShowNotificationOnInstall";
    begin
        ShowNotificationOnInstallApp.ShowNotificationOnInstallApp();
    end;


}