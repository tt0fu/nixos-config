{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.openseeface ];
    };
}
