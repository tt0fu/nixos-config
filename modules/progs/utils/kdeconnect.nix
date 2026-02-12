{
  os =
    { ... }:
    {
      networking.firewall = rec {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
    };
  home =
    { ... }:
    {
      services.kdeconnect.enable = true;
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, C, exec, kdeconnect-app"
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<org.kde.kdeconnect.app>" =
        "";
    };
}
