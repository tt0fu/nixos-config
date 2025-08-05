{
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    shaderbg
  ];
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      wayland.windowManager.hyprland.settings.exec-once = [
        "shaderbg ${systemSettings.monitor} ${./wallpaper.frag}"
      ];
    };
}
