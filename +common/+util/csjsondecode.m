function out = csjsondecode(jsonstring)
% Wrapper function to pre-process or post-process json-format string
% before or after sending to jsondecode
try
    %----------------------------------------------------------
    % Pre-Process
    %----------------------------------------------------------
    % TODO : Handle null in value
    
    % Call jsondecode
    out = jsondecode(jsonstring);
    
    %----------------------------------------------------------
    % Post-Process
    %----------------------------------------------------------
    % Handle keyname that contains hyphen '-'
    if isstruct(out)
        out = convertForKeynameWithHyphen(jsonstring,out);
    end
catch ex
    msg = sprintf("Error while decoding JSON string ""%s""",jsonstring);
    throw(MException("csjsondecode:error",msg));
end
end

function strout = convertForKeynameWithHyphen(jsonstring,strin)
    % Check if any name contains '-'
    tmpstr = jsonencode(jsondecode(jsonstring));
    idx = find(jsonstring ~= tmpstr);
    orig_namelist = strings(0);
    new_namelist = strings(0);
    for ii=1:numel(idx)
        if jsonstring(idx(ii))=='-'
            name = '';
            if idx(ii) > 1
                name_pre = jsonstring(1:idx(ii)-1);
                lastidx = regexp(name_pre,'.*[,{]','end')+1;
                if ~isempty(lastidx)
                    name_pre = name_pre(lastidx:end);
                end
            end
            if idx(ii) < length(jsonstring)
                name_post = char(regexp(jsonstring(idx(ii)+1:end),'(^.*?)(?=:)','match'));
            end
            orig_namelist(end+1) = replace([name_pre,'-',name_post],"""","");
            new_namelist(end+1) = replace([name_pre,'_',name_post],"""","");
        end
    end
    if isempty(new_namelist)
        strout = strin;
    else
        strout = convStructToTableKeepHyphen(strin,new_namelist,orig_namelist);
    end
end
function table_out = convStructToTableKeepHyphen(struct_in,new_namelist,orig_namelist)
    names = string(fieldnames(struct_in));
    values = cell(0);
    for nameCnt=1:numel(names)
        value = struct_in.(names(nameCnt));
        if isstruct(value)
            table_out = convStructToTableKeepHyphen(value,new_namelist,orig_namelist);
            values(end+1) = {table_out};
        else
            values(end+1) = {value};
        end
        if any(names(nameCnt) == new_namelist)
            idx = find(names(nameCnt) == new_namelist);
            names(nameCnt) = orig_namelist(idx);
        end
    end
    table_out = table(names,values','VariableNames',["Name","Value"]);
end
