{
  inputs = {
    gridboard = {
      url = "github:tt0fu/gridboard";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  home =
    { pkgs, inputs, ... }:
    {
      home.packages = [
        inputs.gridboard.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
