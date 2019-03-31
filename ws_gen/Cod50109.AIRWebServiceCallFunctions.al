codeunit 50109 "AIR WebService Call Functions"
{
    //https://www.kauffmann.nl/2017/06/24/al-support-for-rest-web-services/
    //https://github.com/ajkauffmann/ALWebServiceExamples/blob/master/BaseObjects/Codeunits/RESTWebServiceCode.al
    //https://github.com/ajkauffmann/ALWebServiceExamples/blob/master/BaseObjects/Codeunits/RESTWebServiceCode.al
    procedure CallWebService(var Arguments: Record "AIR WebService Argument"): Boolean
    var
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        AuthText: Text;
        TempBlob: Record TempBlob temporary;
    begin
        RequestMessage.Method := Format(Arguments.RestMethod);
        RequestMessage.SetRequestUri(Arguments.URL);
        if Arguments.UserName <> '' then begin
            AuthText := StrSubstNo('%1:%2', Arguments.UserName, Arguments.Password);
            TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
            HttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('Basic %1', TempBlob.ToBase64String()));
        end;

        HttpClient.Send(RequestMessage, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\\' +
                  'Status code: %1\' +
                  'Description: %2',
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);
        Content := ResponseMessage.Content;
        Arguments.SetResponseContent(Content);
        EXIT(ResponseMessage.IsSuccessStatusCode);
    end;

    procedure GetJsonValueAsText(var JsonObject: JsonObject; Property: text) Value: Text;
    var
        JsonValue: JsonValue;
    begin
        if not GetJsonValue(JsonObject, Property, JsonValue) then
            EXIT;
        Value := JsonValue.AsText;
    end;

    procedure GetJsonValueAsDecimal(var JsonObject: JsonObject; Property: text) Value: Decimal;
    var
        JsonValue: JsonValue;
    begin
        if not GetJsonValue(JsonObject, Property, JsonValue) then
            EXIT;
        Value := JsonValue.AsDecimal;
    end;

    local procedure GetJsonValue(var JsonObject: JsonObject; Property: text; var JsonValue: JsonValue): Boolean;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(Property, JsonToken) then
            exit;
        JsonValue := JsonToken.AsValue;
        Exit(true);
    end;

    procedure SelectJsonValueAsText(var JsonObject: JsonObject; Path: text) Value: Text;
    var
        JsonValue: JsonValue;
    begin
        if not SelectJsonValue(JsonObject, Path, JsonValue) then
            EXIT;
        Value := JsonValue.AsText;
    end;

    procedure SelectJsonValueAsDate(var JsonObject: JsonObject; Path: text) Value: Date;
    var
        JsonValue: JsonValue;
    begin
        if not SelectJsonValue(JsonObject, Path, JsonValue) then
            EXIT;
        Value := JsonValue.AsDate();
    end;

    local procedure SelectJsonValue(var JsonObject: JsonObject; Path: text; var JsonValue: JsonValue): Boolean;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            exit;
        JsonValue := JsonToken.AsValue;
        Exit(true);
    end;
}