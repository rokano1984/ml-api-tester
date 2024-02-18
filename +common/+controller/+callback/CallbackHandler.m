classdef CallbackHandler < handle
    methods (Access=public)
        % Constructor
        function obj = CallbackHandler()
        end

        function handleEvent(obj, app, event)
            import common.util.AppMessage;

            try
                eventName = event.EventName;
                eventSourceType = event.Source.Type;
                eventSource = event.Source.Tag;
    
                %------------------------------------------------------
                % Menu Bar
                %------------------------------------------------------
                if strcmp(eventSourceType,'uimenu')
                    if strcmp(eventName,'MenuSelected')
                        if strcmp(eventSource,'ClearAPICallHistory')
                            common.controller.callback.onSelectMenuClearAPICallHistory(app,event);
                        end
                        if strcmp(eventSource,'ShowAppVersion')
                            common.controller.callback.onSelectMenuShowAppVersion(app);
                        end
                        if strcmp(eventSource,'DeleteApiCallHistoryList')
                            common.controller.callback.onSelectDeleteApiCallHistoryList(app,event);
                        end
                    end
                end
                
                %------------------------------------------------------
                % Edit Field
                %------------------------------------------------------
                if strcmp(eventSourceType,'uieditfield')
                    if strcmp(eventSource,'URIValue') && strcmp(eventName,'ValueChanged')
                        common.controller.callback.onChangeEditFieldURIValue(app,event);
                    end
                end
    
                %------------------------------------------------------
                % Table
                %------------------------------------------------------
                if strcmp(eventSourceType,'uitable')
                    if strcmp(eventSource,'ParamsTable') && strcmp(eventName,'CellEdit')
                        common.controller.callback.onCellEditParamsTable(app);
                    end
                    if strcmp(eventSource,'HeadersTable') && strcmp(eventName,'CellEdit')
                        common.controller.callback.onCellEditHeadersTable(app);
                    end
                end
    
                %------------------------------------------------------
                % Button (Image)
                %------------------------------------------------------
                if strcmp(eventSourceType,'uiimage')
                    if strcmp(eventName,'ImageClicked')
                        if strcmp(eventSource,'AddRow') || strcmp(eventSource,'DeleteRow')
                            common.controller.callback.onClickButtonAddDeleteRow(app,event);
                        end
                        if strcmp(eventSource,'HideHeader') || strcmp(eventSource,'ShowHeader')
                            common.controller.callback.onClickButtonHideShowHeader(app,event);
                        end
                        if strcmp(eventSource,'SendAPIRequest')
                            common.controller.callback.onClickButtonSendAPIRequest(app,event);
                        end
                        if strcmp(eventSource,'SaveToVar')
                            common.controller.callback.onClickButtonSaveToVar(app);
                        end
                        if strcmp(eventSource,'SaveToMfile')
                            common.controller.callback.onClickButtonSaveToMfile(app);
                        end
                    end
                end
    
                %------------------------------------------------------
                % Radio Button Group
                %------------------------------------------------------
                if strcmp(eventSourceType,'uibuttongroup') 
                    if strcmp(eventSource,'BodyContentType') && strcmp(eventName,'SelectionChanged')
                        common.controller.callback.onChangeButtonGroupBodyContentType(app);
                    end
                end
    
                %------------------------------------------------------
                % List Box
                %------------------------------------------------------
                if strcmp(eventSourceType,'uilistbox') 
                    if strcmp(eventSource,'APICallHistoryList') && strcmp(eventName,'DoubleClicked')
                        common.controller.callback.onDoubleClickAPICallHistoryList(app,event);
                    end
                    if strcmp(eventSource,'APICallHistoryList') && strcmp(eventName,'Clicked')
                        common.controller.callback.onClickAPICallHistoryList(app,event);
                    end
                end
                
            catch ex
                uialert(app.UIFigure, ...
                    sprintf(common.util.AppMessage.MSG_APP_SYSTEM_ERROR,ex.message), ...
                    AppMessage.TITLE_ERROR, ...
                    "Icon","error");
            end
        end
    end
end

