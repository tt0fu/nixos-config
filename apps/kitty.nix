{
  userSettings,
  style,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      programs = {
        kitty = {
          enable = true;
          font = {
            name = style.font.name;
            size = style.font.size / 1.2;
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
