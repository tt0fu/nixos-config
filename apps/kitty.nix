{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      programs = {
        kitty = {
          enable = true;
          font = {
            name = "JetBrainsMono Nerd Font Propo";
            size = 12;
          };
          shellIntegration.enableBashIntegration = true;
          enableGitIntegration = true;
          settings = {
            cursor_shape = "beam";
            cursor_shape_unfocused = "unchanged";
            background_opacity = 0.0;
            confirm_os_window_close = 0;
          };
        };
      };
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, Q, exec, kitty"
      ];
    };
}
