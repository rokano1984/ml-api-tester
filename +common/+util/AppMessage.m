classdef AppMessage < handle
    properties (Access = public, Constant)
        MSG_APP_STARTUP_ERROR = "Start-up is failed with following error.\r\n%s";
        MSG_REFRESH_API_CALL_HISTORY_ERROR = "API Call History is failed to update.\r\n%s";
        MSG_REFRESH_APP_STATUS_MESSAGE_ERROR = "App Status Message is failed to update.\r\n%s";
        MSG_SENDING_API_REQUEST = "Sending API Request...";
        MSG_DEPLICATE_KEY_NAME = "Duplicate Key.";
        MSG_APP_SYSTEM_ERROR = "System error is occurred.\r\n%s";

        TITLE_ERROR = "Error";
        TITLE_API_CALL = "API Call";
    end
end

