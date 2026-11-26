{
  enable = false;
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.protonplus ];
    };
  deps = modules: with modules; [ progs.gaming.steam ];
}
