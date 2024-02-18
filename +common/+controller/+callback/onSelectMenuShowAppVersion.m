function onSelectMenuShowAppVersion(app)
    version = sprintf("App Name : %s\r\nVersion : %s",app.AppName,app.VersionNo);
    uialert(app.UIFigure,version,"App Version","Icon","info");
end

