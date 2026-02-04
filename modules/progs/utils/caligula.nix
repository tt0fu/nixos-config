{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.caligula ];
    };
}
