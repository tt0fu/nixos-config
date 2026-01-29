{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.blender ];
    };
}
