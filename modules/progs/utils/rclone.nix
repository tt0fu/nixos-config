{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.rclone ];
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("rclone mount google-drive:Synced ~/DriveSynced/") end'')
          ];
        }
      ];
    };
}
