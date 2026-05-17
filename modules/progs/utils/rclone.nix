{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.rclone ];
      wayland.windowManager.hyprland.settings.exec-once = [
        "rclone mount google-drive:Synced ~/DriveSynced/"
      ];
    };
}
