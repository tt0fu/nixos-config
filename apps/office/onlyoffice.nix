{ userSettings, ... }:
{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.onlyoffice-desktopeditors ];
    };
}
