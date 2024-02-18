function onChangeEditFieldURIValue(app,event)
    import common.model.AppHTTPClient;
    
    [~,paramsT] = AppHTTPClient.getDecodedURIandParams(app.EditField_URI.Value);
    app.UITable_Params.Data = paramsT;
end

