function onSelectDeleteApiCallHistoryList(app,event)
    selectedIdx = app.apiCallHistoryModelObj.getSelectedIdx();
    if selectedIdx ~= 0
        key = app.ListBox_History.UserData(selectedIdx);
        app.apiCallHistoryModelObj.removeHistory(key);
    end
end

