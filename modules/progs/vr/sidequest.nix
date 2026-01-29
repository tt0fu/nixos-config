{
  home =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.sidequest
      ];
    };
}
