{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.onlyoffice-desktopeditors ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<ONLYOFFICE>" = "";
    };
}
