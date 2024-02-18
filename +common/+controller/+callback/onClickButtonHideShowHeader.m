function onClickButtonHideShowHeader(app,event)
    if strcmp(app.TabGroup_Request.SelectedTab.Title,'Headers')
        selectedCell = app.UITable_Headers.Selection(1,:);
        if isempty(selectedCell) == false
            if strcmp(event.Source.Tooltip,'Hide value')
                % if a value is already hidden, do nothing
                chk = replace(app.UITable_Headers.Data{selectedCell(1),3},'*','');
                if string(chk).strlength == 0
                    return;
                end

                if ~isempty(app.UITable_Headers.UserData) && ~isempty(app.UITable_Headers.UserData.HiddenHeaderT)
                    hiddenHeaderT = app.UITable_Headers.UserData.HiddenHeaderT;
                    idx = [string(hiddenHeaderT{:,2})] == string(app.UITable_Headers.Data{selectedCell(1),2});
                    if any(idx)
                        hiddenHeaderT{idx,3} = app.UITable_Headers.Data{selectedCell(1),3};
                    else
                        hiddenHeaderT = [hiddenHeaderT; app.UITable_Headers.Data(selectedCell(1),:)];
                    end
                    app.UITable_Headers.UserData.HiddenHeaderT = hiddenHeaderT;
                else
                    app.UITable_Headers.UserData.HiddenHeaderT = table();
                    app.UITable_Headers.UserData.HiddenHeaderT = app.UITable_Headers.Data(selectedCell(1),:);
                end
                app.UITable_Headers.Data{selectedCell(1),3} = {'**********'};
            end
            if strcmp(event.Source.Tooltip,'Show value')
                if ~isempty(app.UITable_Headers.UserData) && ~isempty(app.UITable_Headers.UserData.HiddenHeaderT)
                    hiddenHeaderT = app.UITable_Headers.UserData.HiddenHeaderT;
                    idx = [string(hiddenHeaderT{:,2})] == string(app.UITable_Headers.Data{selectedCell(1),2});
                    if any(idx)
                        app.UITable_Headers.Data{selectedCell(1),3} = hiddenHeaderT{idx,3};
                        hiddenHeaderT(idx,:) = [];
                        app.UITable_Headers.UserData.HiddenHeaderT = hiddenHeaderT;
                    end
                end
            end
        end
    end            
end

