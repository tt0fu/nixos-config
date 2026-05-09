{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.winbox4 ];
    };
}
