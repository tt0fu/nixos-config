{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
      };
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, E, exec, kitty --class yazi yazi"
      ];
    };
}
