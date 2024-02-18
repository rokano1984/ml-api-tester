function refreshAppStatusMessage(app,model)
arguments
    app ML_APITester
    model common.model.AppStatusMessageModel
end
import common.util.AppMessage;
try
    statusMessage = model.get();
    app.Label_AppStatusMessage.Text = statusMessage;
catch ex
    uialert(app.UIFigure, ...
        sprintf(AppMessage.MSG_REFRESH_APP_STATUS_MESSAGE_ERROR,ex.message), ...
        AppMessage.TITLE_ERROR, ...
        "Icon","error");
end
end

