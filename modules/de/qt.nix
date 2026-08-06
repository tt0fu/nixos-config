{
  os =
    { ... }:
    {
      # qt = {
      #   enable = true;
      #   platformTheme = "gnome";
      #   style = "adwaita-dark";
      # };
    };
  home =
    { ... }:
    {
      qt = {
        enable = true;
        platformTheme.name = "adwaita";
        style.name = "adwaita-dark";
      };
    };
}
