{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.vlc ];
      xdg.mimeApps.defaultApplications = {
        "audio/*" = "vlc.desktop";
        "video/*" = "vlc.desktop";
      };
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<vlc>" = "󰕼";
    };
}
