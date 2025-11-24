{
  systemSettings,
  userSettings,
  style,
  ...
}:

{
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "adwaita-dark";
  };
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      home.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt6ct";
      };
    };
}
