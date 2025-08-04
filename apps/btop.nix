{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      programs.btop = {
        enable = true;
      };
      wayland.windowManager.hyprland.settings.bind = [
        "CTRL_SHIFT, ESCAPE, exec, kitty btop"
      ];
    };
}
