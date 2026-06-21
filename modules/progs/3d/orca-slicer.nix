{
  home =
    { pkgs-stable, ... }:
    {
      home.packages = with pkgs-stable; [
        orca-slicer
      ];
    };
}
