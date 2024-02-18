function onClickButtonAddDeleteRow(app,event)

if strcmp(event.Source.Tag,'AddRow')
    newrow = struct();
    newrow(1).Enable = true;
    newrow(1).Key = "";
    newrow(1).Value = "";
    if strcmp(app.TabGroup_Request.SelectedTab.Title,'Params')
        app.UITable_Params.Data = [app.UITable_Params.Data; struct2table(newrow)];
    end
    if strcmp(app.TabGroup_Request.SelectedTab.Title,'Headers')
        app.UITable_Headers.Data = [app.UITable_Headers.Data; struct2table(newrow)];
    end

elseif strcmp(event.Source.Tag,'DeleteRow')
    if strcmp(app.TabGroup_Request.SelectedTab.Title,'Params')
        selectedCell = app.UITable_Params.Selection;
        if isempty(selectedCell) == false
            app.UITable_Params.Data(selectedCell(1),:) = [];
            common.controller.callback.onCellEditParamsTable(app);
        end
    end
    if strcmp(app.TabGroup_Request.SelectedTab.Title,'Headers')
        selectedCell = app.UITable_Headers.Selection;
        if isempty(selectedCell) == false
            app.UITable_Headers.Data(selectedCell(1),:) = [];
        end
    end
end

end

