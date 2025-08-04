{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      services.kdeconnect.enable = true;
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, C, exec, kdeconnect-app"
      ];
    };
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
