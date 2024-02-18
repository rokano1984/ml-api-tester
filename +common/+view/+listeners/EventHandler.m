classdef EventHandler < handle
    properties (Access = private)
        Listener(:,1) event.listener
    end
    
    methods (Access = public)
        function obj = EventHandler()
        end

        function addAPICallHistoryListener(obj,app,model)
            obj.Listener(end+1) = listener(model, ...
                "historyListChanged", ...
                 @(~,~)common.view.listeners.refreshApiCallHistory(app,model));
            common.view.listeners.refreshApiCallHistory(app,model);
        end

        function addAppStatusMessageListener(obj,app,model)
            obj.Listener(end+1) = listener(model, ...
                "statusMessageChanged", ...
                 @(~,~)common.view.listeners.refreshAppStatusMessage(app,model));
        end
    end
end

