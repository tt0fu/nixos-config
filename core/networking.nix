{ pkgs, systemSettings, ... }:

{
  environment.systemPackages = [ pkgs.wireguard-tools ];
  networking = {
    hostName = systemSettings.hostname; # Define your hostname.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    wireguard.enable = true;
  };
}
