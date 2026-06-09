{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gparted ];
    };
}
