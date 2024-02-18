function onDoubleClickAPICallHistoryList(app,event)
    item = event.InteractionInformation.Item;
    if isempty(item)
        return;
    end

    % Get History
    key = app.ListBox_History.UserData(item);
    history = app.apiCallHistoryModelObj.findHistory(key);
    [method,uri,paramsT,headerT,body] = history.getRequest();
    
    % Apply History data to UI
    app.DropDown_Method.Value = method;
    app.EditField_URI.Value = uri;
    app.UITable_Params.Data = paramsT;
    app.UITable_Headers.Data = headerT;
    if isempty(body)
        app.ButtonGroup_Body.SelectedObject = app.NoneButton;
        app.TextArea_Body.Value = "";
    else
        contentType = string(headerT{string(headerT.Key) == 'Content-Type',"Value"});
        if strcmp(contentType,"application/json")
            app.ButtonGroup_Body.SelectedObject = app.JSONButton;
            app.TextArea_Body.Value = jsonencode(common.util.csjsondecode(body),"PrettyPrint",true);
        else
            app.ButtonGroup_Body.SelectedObject = app.TextButton;
            app.TextArea_Body.Value = body;
        end
    end
    common.controller.callback.onChangeButtonGroupBodyContentType(app);

    response = history.getResponse();
    app.appStatusMessageModelObj.set(sprintf("HTTP Response [%s].",response.StatusLine.string));
    responseHeader = struct();
    for ii=1:length(response.Header)
        responseHeader(ii).Name = response.Header(ii).Name;
        responseHeader(ii).Value = response.Header(ii).Value;
    end
    app.UITable_ResponseHeaders.Data = struct2table(responseHeader);
    contentType = getFields(response.Header,"Content-Type");
    if ~isempty(contentType)
        if contains(contentType.Value,"application/json")
            app.TextArea_ResponseBody.Value = jsonencode(response.Body.Data,"PrettyPrint",true);
        else
            app.TextArea_ResponseBody.Value = response.Body.Data;
        end
    end
end

