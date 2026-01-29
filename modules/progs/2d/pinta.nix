{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.pinta ];
    };
}
