{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        grim
        slurp
        hyprpicker
        wl-clipboard
        jq
        libnotify
        grimblast
      ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, S, exec, grimblast -nf copysave area \"$HOME/Pictures/Screenshots/$(date +\"%Y-%m-%d_%H-%M-%S\").png\""
        "SUPER SHIFT, S, exec, grimblast -nf copysave screen \"$HOME/Pictures/Screenshots/$(date +\"%Y-%m-%d_%H-%M-%S\").png\""
      ];
      # programs.niri.settings.binds."Mod+S".action.spawn = [
      #   "hyprshot"
      #   "-z"
      #   "-o"
      #   "~/Pictures/Screenshots"
      #   "-m"
      #   "region"
      # ];
    };
}
