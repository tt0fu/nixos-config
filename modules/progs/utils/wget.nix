{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.wget ];
    };
}
