{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.onlyoffice-desktopeditors ];
    };
}
