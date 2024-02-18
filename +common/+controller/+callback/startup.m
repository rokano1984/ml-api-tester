function startup(app)
    import common.util.AppMessage;

    try
        common.controller.callback.onChangeButtonGroupBodyContentType(app);
    catch ex
        uialert(app.UIFigure, ...
            sprintf(AppMessage.MSG_APP_STARTUP_ERROR,ex.message), ...
            AppMessage.TITLE_ERROR, ...
            "Icon","error", ...
            "CloseFcn",@(src,~)delete(src));
    end
end