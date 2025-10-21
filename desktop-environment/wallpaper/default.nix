{
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      home.packages = with pkgs; [
        shaderbg
      ];
      wayland.windowManager.hyprland.settings.exec-once = [
        "shaderbg ${systemSettings.monitor.name} ${./fbm.frag}"
      ];
    };
}
