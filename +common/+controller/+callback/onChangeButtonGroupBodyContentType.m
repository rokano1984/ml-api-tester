function onChangeButtonGroupBodyContentType(app)
    selectedButton = app.ButtonGroup_Body.SelectedObject;
    switch selectedButton.Text
        case "None"
            app.TextArea_Body.Value = "";
            app.TextArea_Body.Enable = "off";
        case "JSON"
            app.TextArea_Body.Enable = "on";
        case "Text"
            app.TextArea_Body.Enable = "on";
    end
end

