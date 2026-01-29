{
  os =
    { ... }:
    {
      qt = {
        enable = true;
        platformTheme = "kde";
        style = "adwaita-dark";
      };
    };
  home =
    { ... }:
    {
      home.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt6ct";
      };
    };
}
