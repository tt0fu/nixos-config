{
  userSettings,
  style,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            offset = "(5, 5)";
            origin = "top-right";
            frame_width = style.border.thickness;
            background = "#00000001";
            font = style.font.name;
            corner_radius = style.border.radius;
            progress_bar = true;
          };
          urgency_low = {
            frame_color = "#808080";
            foreground = "#808080";
          };
          urgency_normal = {
            frame_color = "#ffffff";
            foreground = "#ffffff";
          };
          urgency_critical = {
            frame_color = "#ff8080";
            foreground = "#ff8080";
          };
        };
      };
      wayland.windowManager.hyprland.settings = {
        exec-once = [
          "dunst"
        ];
        layerrule = [
          "blur, notifications"
          "ignorezero, notifications"
          "blurpopups, notifications"
        ];
      };
    };
}
