{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.element-desktop ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, F, exec, element-desktop"
      ];
    };
}
