{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.hyprshot ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, S, exec, hyprshot -z -o ~/Pictures/Screenshots -m region"
        "SUPER SHIFT, S, exec, hyprshot -z -o ~/Pictures/Screenshots -m output"
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
