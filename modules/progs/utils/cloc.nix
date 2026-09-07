{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.cloc ];
    };
}
