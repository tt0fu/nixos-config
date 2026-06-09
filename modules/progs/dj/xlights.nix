{
  home =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.xlights
      ];
    };
}
