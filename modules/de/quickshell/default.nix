{
  home =
    { ... }:
    {
      programs.quickshell = {
        enable = true;
      };
      wayland.windowManager.hyprland.settings = {
        layerrule = [
          "blur on, match:namespace quickshell"
          "ignore_alpha 0, match:namespace quickshell"
          "blur_popups on, match:namespace quickshell"
        ];
      };
    };
}
