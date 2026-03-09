{
  os =
    { ... }:
    {
      programs.dconf.enable = true;
    };
  home =
    { pkgs, style, ... }:
    {
      gtk = rec {
        enable = true;
        colorScheme = "dark";
        theme = {
          package = pkgs.flat-remix-gtk;
          name = "Flat-Remix-GTK-Grey-Darkest";
          # package = pkgs.materia-theme-transparent;
          # name = "Materia-dark";
        };
        gtk4.theme = theme;
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
        font = {
          name = style.font.name;
          package = (style.font.package pkgs);
        };
      };
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          icon-theme = "Adwaita";
        };
      };
    };
}
