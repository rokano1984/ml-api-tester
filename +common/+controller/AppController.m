classdef AppController < handle
    properties (Access=private)
        eventHandlerObj;
    end

    methods (Access=public)
        % Constructor
        function obj = AppController(app)
            % Register event listeners
            obj.eventHandlerObj = common.view.listeners.EventHandler();
            obj.eventHandlerObj.addAPICallHistoryListener(app, app.apiCallHistoryModelObj);
            obj.eventHandlerObj.addAppStatusMessageListener(app, app.appStatusMessageModelObj);
        end

        % Destructor
        function delete(obj)
            delete(obj.eventHandlerObj);
        end
        
        % Startup
        function startup(obj,app)
            common.controller.callback.startup(app);
        end

        % Handle callback
        function handleCallback(obj,app,event)
            handler = common.controller.callback.CallbackHandler();
            handler.handleEvent(app,event);
        end        
    end
end