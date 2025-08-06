{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.libnotify ];
      programs.eww = {
        enable = true;
        enableBashIntegration = true;
        configDir = ./eww-config;
      };
      wayland.windowManager.hyprland.settings.layerrule = [
        "blur, eww"
        "ignorezero, eww"
        "blurpopups, eww"
      ];
    };
}
