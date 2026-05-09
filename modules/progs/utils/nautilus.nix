{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nautilus ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, E, exec, nautilus"
      ];
    };
}
