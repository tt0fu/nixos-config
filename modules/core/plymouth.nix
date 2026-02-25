{
  os =
    { pkgs, ... }:
    {
      boot.plymouth = {
        enable = true;
        font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Medium.ttf";
        themePackages = [
          pkgs.adi1090x-plymouth-themes
        ];
        theme = "circle_alt";
      };
    };
}
