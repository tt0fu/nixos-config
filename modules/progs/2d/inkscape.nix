{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.inkscape ];
    };
}
