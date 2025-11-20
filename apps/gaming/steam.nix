{ userSettings, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    # extraCompatPackages = [
    #   (import ./proton-ge-rtsp.nix {
    #     lib = pkgs.lib;
    #     stdenvNoCC = pkgs.stdenvNoCC;
    #     fetchzip = pkgs.fetchzip;
    #     writeScript = pkgs.writeScript;

    #     # Can be overridden to alter the display name in steam
    #     # This could be useful if multiple versions should be installed together
    #     steamDisplayName = "GE-Proton-RTSP";
    #   })
    #   # (pkgs.proton-ge-bin.overrideAttrs (
    #   #   finalAttrs: previousAttrs: {
    #   #     pname = "proton-ge-rtsp-bin";
    #   #     version = "GE-Proton10-20-rtsp19";
    #   #     src = pkgs.fetchzip {
    #   #       url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/GE-Proton10-20-rtsp19/GE-Proton10-20-rtsp19.tar.gz";
    #   #       hash = "sha256-VzUzZjILqndtqi/nLGAXrup2lKoZ7RxGXGoPLo2voHQ=";
    #   #     };
    #   #   }
    #   # ))
    # ];
  };
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      wayland.windowManager.hyprland.settings.exec-once = [
        "steam -silent"
      ];
    };
}
