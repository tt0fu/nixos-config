{
  inputs,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./font.nix
    ./git.nix
    ./hardware-configuration.nix
    ./internationalisation.nix
    ./networking.nix
    ./power.nix
    ./sound.nix
    ./ssh.nix
    ./time.nix
    ./user.nix
  ];
}
