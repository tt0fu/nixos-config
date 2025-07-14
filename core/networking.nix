{ systemSettings, ... }:

{
  networking.hostName = systemSettings.hostname; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
}
