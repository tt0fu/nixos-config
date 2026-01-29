{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.audacity ];
    };
}
