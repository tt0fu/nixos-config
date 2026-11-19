{
  os =
    { pkgs, ... }:
    {
      programs.dconf.enable = true;
      programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    };
  home =
    { pkgs, style, ... }:
    let
      adwaitaIconTheme = pkgs.adwaita-icon-theme.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace index.theme \
            --replace-fail "Inherits=hicolor" "Inherits=AdwaitaLegacy,hicolor"
        '';
      });
    in
    {
      home.packages = [ pkgs.adwaita-icon-theme-legacy ];
      gtk = {
        enable = true;
        colorScheme = "dark";
        iconTheme = {
          package = adwaitaIconTheme;
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
