{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.qbittorrent ];
    };
}
