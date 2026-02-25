{
  os =
    { pkgs, ... }:

    {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.configurationLimit = 5;
        grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = true;
          backgroundColor = "#000000";
          theme = pkgs.minimal-grub-theme;
          splashImage = ./grub-bg.png;
          font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Medium.ttf";
        };
      };
    };
}
