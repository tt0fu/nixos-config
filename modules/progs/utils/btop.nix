{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.btop ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER SHIFT, M, exec, kitty --class btop btop"
      ];
    };
}
