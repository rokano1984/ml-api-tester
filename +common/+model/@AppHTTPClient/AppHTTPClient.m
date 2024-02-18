classdef AppHTTPClient < handle

    properties (Access = private)
        method
        uri
        paramsT = table()
        headerT = table()
        bodyData
        bodyContentType
        option
        request
        response
    end
   
    methods (Access = public)
        function obj = AppHTTPClient(method,uri,paramsT,headerT,bodyData,bodyConentType,option)
            obj.method = method;
            obj.uri = uri;
            obj.paramsT = paramsT;
            obj.headerT = headerT;
            obj.bodyData = bodyData;
            obj.bodyContentType = bodyConentType;
            obj.option = option;

            % Method
            switch method
                case 'GET'
                    method = matlab.net.http.RequestMethod.GET;
                case 'POST'
                    method = matlab.net.http.RequestMethod.POST;
                otherwise
                    msg = sprintf("Unsupported HTTP Request Method [%s] was given.",method);
                    throw(MException("MatlabHTTPClient:Exception",msg));
            end
            
            % URI and Params
            obj.uri = obj.getEncodedURI(uri,paramsT);
            
            % Header
            defaultOpts = weboptions;
            header = matlab.net.http.HeaderField("User-Agent",defaultOpts.UserAgent);
            for ii=1:height(headerT)
                row = headerT(ii,:);
                key = char(row.Key{:});
                value = char(row.Value{:});
                if strcmp(key,"User-Agent")
                    header = changeFields(header,key,value);
                end
                header = addFields(header,key,value);
            end

            % Body & related headers
            contentLength = 0;
            contentType = "application/json";
            switch bodyConentType
                case 'None'
                    obj.bodyData = [];
                    body = matlab.net.http.MessageBody();
                case 'JSON'
                    try
                        bodyData = string(jsonencode(common.util.csjsondecode(bodyData)));
                        body = matlab.net.http.MessageBody(common.util.csjsondecode(bodyData));
                    catch ex
                        msg = sprintf("JSON format in Request Body is invalid. Please check.");
                        throw(MException("MatlabHTTPClient:Exception",msg));
                    end
                    contentLength = bodyData.strlength;
                    contentType = "application/json";
                case 'Text'
                    body = matlab.net.http.MessageBody(bodyData);
                    contentLength = bodyData.strlength;
                    contentType = "text/plain";
                otherwise
                    msg = sprintf("Unsupported HTTP Request Body Content Type [%s] was given.",bodyConentType);
                    throw(MException("MatlabHTTPClient:Exception",msg));
            end
            header = removeFields(header,"Content-Length");
            header = addFields(header,"Content-Length", contentLength);
            header = removeFields(header,"Content-Type");
            header = addFields(header,"Content-Type",contentType);

            % Option
            obj.option.Debug = true;

            obj.request = matlab.net.http.RequestMessage(method,header,body);
        end
        
        function [response,request,history,debugLog] = sendRequest(obj)
            try
                debugLogFile = "MatlabHTTPClient.debuglog";
                URI = matlab.net.URI(obj.uri);
                diary(debugLogFile);
                [response,request,history] = obj.request.send(URI, obj.option);
                diary off
                debugLog = readlines(debugLogFile);
                delete(debugLogFile);
                obj.response = response;
            catch ex
                ex.getReport
                throw(ex);
            end
        end

        function [method,uri,params,header,body] = getRequest(obj)
            method = obj.method;
            [uri,params] = obj.getDecodedURIandParams(obj.uri);
            header = obj.headerT;
            body = obj.bodyData;
        end

        function response = getResponse(obj)
            response = obj.response;
        end

        function generateMFile(obj,filePath)
            try
                mlines = readlines(fullfile("code_template","sendHttpRequest.template"));
                % Method
                mlines = replace(mlines,"%{method}",obj.method);
                % URI
                mlines = replace(mlines,"%{uri}",obj.uri);
                % Header
                tbl = sprintf("table([""%s""],[""%s""],'VariableNames',{'Key','Value'})", ...
                    string(obj.headerT.Key).join(""";"""), ...
                    string(obj.headerT.Value).join(""";"""));
                mlines = replace(mlines,"%{headerT}",tbl);
                % Body
                mlines = replace(mlines,"%{bodyContentType}",obj.bodyContentType);
                if isempty(obj.bodyData)
                    mlines = replace(mlines,"%{bodyData}","[]");
                else
                    bodyData = replace(obj.bodyData,"""","""""");
                    bodyData = """" + bodyData + """";
                    mlines = replace(mlines,"%{bodyData}",bodyData);
                end
                
                writelines(mlines,filePath,"WriteMode","overwrite");
            catch ex
                ex.getReport
                throw ex;                
            end
        end
    end

    methods (Static=true)
        function encodedURI = getEncodedURI(uri,paramsT)
            % Check input parameter
            if isstring(uri)
                encodedURI = uri.char();
            elseif ischar(uri)
                encodedURI = uri;
            else
                throw(MException("MatlabHTTPClient:Exception","Data type of uri is invalid."));
            end

            % Clear existing params
            encodedURI(find(encodedURI == '?'):end) = [];
            
            % Generate params
            params = "";
            for ii=1:height(paramsT)
                paramName = string(paramsT{ii,1});
                paramValue = string(paramsT{ii,2});
                if paramName.strlength > 0
                    if params.strlength > 0
                        params = params + "&";
                    end
                    params = params + urlencode(paramName);
                    if paramValue.strlength > 0
                        params = params + "=" + urlencode(paramValue);
                    end
                end
            end
            if params.strlength > 0
                encodedURI = sprintf("%s?%s",encodedURI,params);
            end            
        end
        function [uri,paramsT] = getDecodedURIandParams(encodedURI)
            % Check input parameter
            if isstring(encodedURI)
                uri = encodedURI.char();
            elseif ischar(encodedURI)
                uri = encodedURI;
            else
                throw(MException("MatlabHTTPClient:Exception","Data type of encodedURI is invalid."));
            end

            % Get params strings
            paramsT = table();
            uri = split(uri,'?');
            if numel(uri) > 1
                params = uri(2);
                params = split(params,'&');
                uri = string(uri(1));
            
                % Convert params strings to UITable
                paramsStruct = struct();
                for ii=1:numel(params)
                    vals = split(params(ii),'=');
                    if numel(vals) > 1
                        paramsStruct(ii).Enable = true;
                        paramsStruct(ii).Key = string(vals(1));
                        try
                            paramsStruct(ii).Value = string(urldecode(string(vals(2))));
                        catch ex
                            ex.getReport()
                            paramsStruct(ii).Value = "(error while decoding)";
                        end
                    else
                        paramsStruct(ii).Enable = true;
                        paramsStruct(ii).Key = string(vals(1));
                        paramsStruct(ii).Value = "";
                    end
                end
                if numel(params) > 0
                    paramsT = struct2table(paramsStruct);
                end
            else
                uri = string(uri);
            end
        end
        
        function httpClient = createAppHTTPClient(app)
            % Get Method
            method = app.DropDown_Method.Value;
            % Get URI
            uri = app.EditField_URI.Value;
            % Get Params
            paramsT = app.UITable_Params.Data;
            if ~isempty(paramsT)
                paramsT = paramsT(paramsT{:,1}==true,2:3);
            end
            % Get Header
            headerT = app.UITable_Headers.Data;
            if ~isempty(headerT)
                for ii=1:height(headerT)
                    row = headerT(ii,:); 
                    if ~isempty(app.UITable_Headers.UserData) && ~isempty(app.UITable_Headers.UserData.HiddenHeaderT)
                        hiddenHeaderT = app.UITable_Headers.UserData.HiddenHeaderT;
                        idx = [string(hiddenHeaderT{:,2})] == string(row.Key{:});
                        if any(idx)
                            headerT(ii,:).Value{:} = char(hiddenHeaderT{idx,3});
                        end
                    end
                end
                headerT = headerT(headerT{:,1}==true,:);
            end
            % Get Body
            selectedButton = app.ButtonGroup_Body.SelectedObject;
            bodyContentType = selectedButton.Text;
            bodyData = string(join(app.TextArea_Body.Value));
            % Get HTTP Options
            option = matlab.net.http.HTTPOptions('ConnectTimeout',20);
            
            import common.model.AppHTTPClient;
            httpClient = AppHTTPClient(method,uri,paramsT,headerT,bodyData,bodyContentType,option);
        end        
    end
end

