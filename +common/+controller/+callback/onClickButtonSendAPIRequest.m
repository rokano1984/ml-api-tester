function onClickButtonSendAPIRequest(app, event)
import common.util.AppMessage;
import common.model.AppHTTPClient;

dlg = uiprogressdlg(app.UIFigure, ...
    Title=AppMessage.TITLE_API_CALL, ...
    Message=AppMessage.MSG_SENDING_API_REQUEST, ...
    Indeterminate="on", Icon="info");

try
    % Clear response
    app.TextArea_ResponseBody.Value = "";
    app.UITable_ResponseHeaders.Data = table();
    app.TextArea_DebugLog.Value = "";
    drawnow

    % Send a request
    httpClient = AppHTTPClient.createAppHTTPClient(app);
    [response, ~, ~, debugLog] = httpClient.sendRequest();

    % Get Response
    app.appStatusMessageModelObj.set(sprintf("HTTP Response [%s].",response.StatusLine.string));
    responseHeader = struct();
    for ii=1:length(response.Header)
        responseHeader(ii).Name = response.Header(ii).Name;
        responseHeader(ii).Value = response.Header(ii).Value;
    end
    app.UITable_ResponseHeaders.Data = struct2table(responseHeader);
    contentType = getFields(response.Header,"Content-Type");
    if ~isempty(contentType)
        app.TextArea_ResponseBody.Value = jsonencode(response.Body.Data,"PrettyPrint",true);
    end

    % Get Debug Log
    app.TextArea_DebugLog.Value = debugLog;

    % Save History
    [URI,~] = AppHTTPClient.getDecodedURIandParams(app.EditField_URI.Value);
    itemName = sprintf("[%s] %s",app.DropDown_Method.Value,URI);
    key = sprintf("%s_%s",datetime("now","Format","uuuu-MM-dd-HH:mm:ss"),itemName);
    app.apiCallHistoryModelObj.addHistory(key,httpClient);

 catch ex
    app.appStatusMessageModelObj.set(sprintf("Something wrong..."));
    app.TextArea_DebugLog.Value = ex.getReport();
    uialert(app.UIFigure,ex.message,"Error during API Call","Icon","error");
end
close(dlg);
common.controller.callback.onChangeButtonGroupBodyContentType(app);
end

