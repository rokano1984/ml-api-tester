function refreshApiCallHistory(app,model)
arguments
    app ML_APITester
    model common.model.APICallHistoryModel
end
import common.util.AppMessage;
try
    historyList = model.listAllHistory();
    keys = string(historyList.keys());
    itemNames = keys.extractAfter("_");
    app.ListBox_History.Items = itemNames;
    app.ListBox_History.UserData = keys;
catch ex
    uialert(app.UIFigure, ...
        sprintf(AppMessage.MSG_REFRESH_API_CALL_HISTORY_ERROR,ex.message), ...
        AppMessage.TITLE_ERROR, ...
        "Icon","error");
end
end

