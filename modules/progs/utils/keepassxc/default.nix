{
  home =
    { pkgs, lib, ... }:
    {
      home = {
        packages = [ pkgs.keepassxc ];
        file.".config/keepassxc/keepassxc.ini" = {
          source = ./keepassxc.ini;
        };
      };
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("sleep 30; keepassxc --minimized") end'')
          ];
        }
      ];
    };
}
