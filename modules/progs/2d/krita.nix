{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.krita ];
    };
}
