{
  home =
    { pkgs, ... }:
    {
      home = {
        packages = [ pkgs.keepassxc ];
        file.".config/keepassxc/keepassxc.ini" = {
          source = ./keepassxc.ini;
        };
      };
      wayland.windowManager.hyprland.settings.exec-once = [
        "sleep 60; keepassxc --minimized"
      ];
    };
}
