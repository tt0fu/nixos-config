{ userSettings, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      wayland.windowManager.hyprland.settings.exec-once = [
        "steam -silent"
      ];
    };
}
