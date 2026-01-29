{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.protonplus ];
    };
}
