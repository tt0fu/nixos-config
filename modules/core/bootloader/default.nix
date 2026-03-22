{
  os =
    { systemSettings, pkgs, ... }:

    {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.configurationLimit = 5;
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
          backgroundColor = "#000000";
          theme = pkgs.minimal-grub-theme;
          splashImage = ./grub-bg.png;
          gfxmodeEfi = with systemSettings.monitor; "${toString width}x{toString height}, auto";
          gfxpayloadEfi = "keep";
        };
      };
    };
}
