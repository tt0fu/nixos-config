{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.keepassxc ];
      # wayland.windowManager.hyprland.settings.bind = [
      #   "SUPER, E, exec, nautilus"
      # ];
    };
}
