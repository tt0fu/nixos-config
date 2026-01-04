{
  ...
}:

{
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./bootloader
    ./configuration.nix
    ./git.nix
    ./internationalisation.nix
    ./kernel.nix
    # ./keyring.nix
    ./mounting.nix
    ./networking.nix
    ./power.nix
    ./sound.nix
    ./ssh.nix
    ./systemd.nix
    ./time.nix
    ./user.nix
  ];
}
