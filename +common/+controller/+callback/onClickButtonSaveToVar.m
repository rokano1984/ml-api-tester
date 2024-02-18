function onClickButtonSaveToVar(app)
try
    bodyData = string(join(app.TextArea_ResponseBody.Value(:)));
    if bodyData.strlength > 0
        varName = string(inputdlg('Enter a variable name.', ...
            string(app.Image_SaveToVar.Tooltip), ...
            [1 80]));
        bodyData = common.util.csjsondecode(bodyData);
        assignin("base",varName,bodyData);
        msg = sprintf("Successfully saved to a variable [%s].",varName);
        uialert(app.UIFigure,msg,string(app.Image_SaveToVar.Tooltip),"Icon","success");
    end
catch ex
    app.appStatusMessageModelObj.set(sprintf("Something wrong..."));
    app.TextArea_DebugLog.Value = ex.getReport();
    uialert(app.UIFigure,ex.message,"Error during Code Generation","Icon","error");
end
end

