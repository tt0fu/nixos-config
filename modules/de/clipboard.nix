{
  home =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.wl-clipboard
      ];
      services.cliphist = {
        enable = true;
        allowImages = true;
      };
      wayland.windowManager.hyprland = {
        settings = {
          bind = [ "SUPER, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy" ];
          exec-once = [ "cliphist wipe" ];
        };
      };
      # programs.niri.settings.binds."Mod+V".action.spawn = [
      #   "sh"
      #   "-c"
      #   "cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      # ];
    };
}
