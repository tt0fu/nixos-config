{
  os =
    { ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    };
  home =
    { ... }:
    {
      wayland.windowManager.hyprland.settings.exec-once = [
        "steam -silent"
      ];
    };
}
