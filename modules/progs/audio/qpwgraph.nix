{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.qpwgraph ];
      wayland.windowManager.hyprland.settings.exec-once = [
        "qpwgraph -m"
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<org.rncbc.qpwgraph>" =
        "󱡫";
    };
}
