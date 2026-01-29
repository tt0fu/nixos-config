{
  home =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.callPackage ./package.nix { })
      ];
    };
}
