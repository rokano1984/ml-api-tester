classdef AppStatusMessageModel < handle
    properties (Access=private)
        statusMessage = "";
    end
    
    events (NotifyAccess = private, ListenAccess = public)
        % Event broadcast when statusMessage property is changed
        statusMessageChanged
    end

    methods (Access=public)
        function obj = AppStatusMessageModel()
        end
        function statusMessage = get(obj)
            statusMessage = obj.statusMessage;
        end
        function set(obj,message)
            obj.statusMessage = message;
            obj.notify("statusMessageChanged");
        end
        function clear(obj)
            obj.statusMessage = "";
            obj.notify("statusMessageChanged");
        end
    end
end
