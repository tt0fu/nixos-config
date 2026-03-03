{
  os =
    { ... }:
    {
      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];
    };
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        glib
        hyprshot
        brightnessctl
      ];
      xdg = {
        mimeApps.enable = true;
        portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
            xdg-desktop-portal-gnome
            xdg-desktop-portal-wlr
            xdg-desktop-portal-xapp
          ];
          config.common.default = "*";
        };
      };
    };
}
