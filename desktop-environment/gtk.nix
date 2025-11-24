{
  systemSettings,
  userSettings,
  style,
  ...
}:

{
  programs.dconf.enable = true;
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      gtk = {
        enable = true;
        theme = {
          package = pkgs.flat-remix-gtk;
          name = "Flat-Remix-GTK-Grey-Darkest";
          # package = pkgs.materia-theme-transparent;
          # name = "Materia-dark";
        };
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
