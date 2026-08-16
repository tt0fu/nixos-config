{
  deps =
    modules: with modules.progs.vr; [
      nixpkgs-xr
      sidequest
      wayvr.default
      wivrn
    ];
}
