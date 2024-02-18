function onCellEditParamsTable(app)
    import common.util.AppMessage;
    import common.model.AppHTTPClient;
    
    % Duplicate check
    keysT = app.UITable_Params.Data;
    idx = keysT.Enable == true;
    keysT = keysT(idx,:);
    if height(keysT.Key) ~= height(unique(keysT.Key))
        uialert(app.UIFigure, ...
            AppMessage.MSG_DEPLICATE_KEY_NAME, ...
            AppMessage.TITLE_ERROR);
    end
    
    % Update URI params
    uri = app.EditField_URI.Value;
    paramsT = app.UITable_Params.Data;
    paramsT = paramsT(paramsT{:,1}==true,2:3);
    app.EditField_URI.Value = AppHTTPClient.getEncodedURI(uri,paramsT);
end

