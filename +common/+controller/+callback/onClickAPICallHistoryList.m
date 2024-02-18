function onClickAPICallHistoryList(app,event)
    idx = event.InteractionInformation.Item;
    app.apiCallHistoryModelObj.setSelectedIdx(idx);
end

