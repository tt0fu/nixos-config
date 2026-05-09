{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.telegram-desktop ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, T, exec, Telegram"
      ];
    };
}
