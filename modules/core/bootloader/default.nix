{
  os =
    { systemSettings, pkgs, ... }:

    {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
          configurationLimit = 5;
          backgroundColor = "#000000";
          theme = pkgs.minimal-grub-theme;
          splashImage = ./grub-bg.png;
          gfxmodeEfi = with systemSettings.monitor; "${toString width}x{toString height}, auto";
          gfxpayloadEfi = "keep";
        };
      };
    };
}
