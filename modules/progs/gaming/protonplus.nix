{
  enable = false;
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.protonplus ];
    };
}
