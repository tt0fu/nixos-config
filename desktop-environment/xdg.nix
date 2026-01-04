{
  inputs,
  userSettings,
  ...
}:

{
  hardware.graphics.enable = true;
  home-manager.users.${userSettings.username} =
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
          extraPortals = [
            inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-wlr
            pkgs.xdg-desktop-portal-xapp
          ];
          config.common.default = "*";
        };
      };
    };
}
