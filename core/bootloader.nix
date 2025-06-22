{ pkgs, ... }:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      backgroundColor = "#000000";
      theme = pkgs.minimal-grub-theme;
    };
  };
}
