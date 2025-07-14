{
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    glpaper
  ];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings.exec-once = [
        "glpaper ${systemSettings.monitor} ${./wallpaper.frag} --fork"
      ];
    };
}
