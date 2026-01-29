{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vrc-get
        alcom
        (pkgs.callPackage ./vpm-cli.nix { })
      ];
    };
  deps =
    modules: with modules; [
      progs."3d".unity
    ];
}
