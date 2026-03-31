{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.libnotify ];
    };
}
