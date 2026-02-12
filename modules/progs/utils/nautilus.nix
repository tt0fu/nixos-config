{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nautilus ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, E, exec, nautilus"
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<org.gnome.Nautilus>" =
        "";
    };
}
