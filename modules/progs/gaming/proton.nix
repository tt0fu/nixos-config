{
  os =
    { pkgs, ... }:
    {
      programs.steam.extraCompatPackages = [
        pkgs.proton-ge-bin
        pkgs.proton-ge-rtsp-bin
        pkgs.proton-rtsp-bin
      ];
    };

  deps =
    modules: with modules; [
      progs.vr.nixpkgs-xr
    ];
}
