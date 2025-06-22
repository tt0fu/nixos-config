{
  inputs,
  lib,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [
    ./anki.nix
    ./discord.nix
    ./fastfetch/fastfetch.nix
    #./nvim.nix
    ./obs-studio.nix
    ./oh-my-posh.nix
    ./steam.nix
    ./telegram.nix
    ./terminal.nix
    ./vlc.nix
    ./vscode.nix
    ./yazi.nix
    ./zapret.nix
    ./zen-browser.nix
  ];
}
