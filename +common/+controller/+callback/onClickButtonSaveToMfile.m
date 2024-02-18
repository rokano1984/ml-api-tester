function onClickButtonSaveToMfile(app)
import common.model.AppHTTPClient;
try
    % Specify a file name to save
    filterspec = {'*.m','MATLAB Code File'};
    [f, p] = uiputfile(filterspec,string(app.Image_SaveToMfile.Tooltip));
    if (ischar(p))
        fname = [p f];

        % Generate code
        httpClient = AppHTTPClient.createAppHTTPClient(app);
        httpClient.generateMFile(fname);
        msg = sprintf("Successfully created a file [%s].",fname);
        edit(fname);
        figure(app.UIFigure);
        uialert(app.UIFigure,msg,string(app.Image_SaveToMfile.Tooltip),"Icon","success","Modal",true);
    end
catch ex
    app.appStatusMessageModelObj.set(sprintf("Something wrong..."));
    app.TextArea_DebugLog.Value = ex.getReport();
    uialert(app.UIFigure,ex.message,"Error during Code Generation","Icon","error");
end
end

