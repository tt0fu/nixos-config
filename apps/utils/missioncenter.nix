{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.mission-center ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, M, exec, missioncenter"
      ];
    };
}
