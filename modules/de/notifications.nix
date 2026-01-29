{
  home =
    { style, ... }:
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
          "blur on, match:namespace notifications"
          "ignore_alpha 0, match:namespace notifications"
          "blur_popups on, match:namespace notifications"
        ];
      };
    };
}
