{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nmgui ];
    };
}
