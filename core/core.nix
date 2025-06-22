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
    ./git.nix
    ./hardware-configuration.nix
    ./home-stateversion.nix
    ./internationalisation.nix
    ./networking.nix
    ./sound.nix
    ./ssh.nix
    ./time.nix
    ./user.nix
  ];
}
