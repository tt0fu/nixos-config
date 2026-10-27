{
  inputs = {
    metashape = {
      url = "github:lalzhanov/metashape-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  home =
    { inputs, pkgs, ... }:
    {
      home.packages = [
        inputs.metashape.packages.${pkgs.stdenv.hostPlatform.system}.metashape-pro
      ];
    };
}
