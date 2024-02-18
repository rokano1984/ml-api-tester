function onCellEditHeadersTable(app)
    % indices = event.Indices;
    % newData = event.NewData;
    
    % Duplicate check
    keysT = app.UITable_Headers.Data;
    idx = keysT.Enable == true;
    keysT = keysT(idx,:);
    if height(keysT.Key) ~= height(unique(keysT.Key))
        uialert(app.UIFigure,"Duplicate Key","Validation Error");
    end
end

