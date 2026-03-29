{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.kdePackages.kdenlive ];
    };
}
