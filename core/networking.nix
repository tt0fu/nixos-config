{ pkgs, systemSettings, ... }:

{
  # environment.systemPackages = [ pkgs.wireguard-tools ];
  networking = {
    hostName = systemSettings.hostname;
    networkmanager.enable = true;
    # wireguard.enable = true;
    firewall.enable = true;
  };
}
