{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.thunar ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, E, exec, thunar"
      ];
    };
}
