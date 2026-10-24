{
  inputs = {
    rbxport = {
      url = "github:tt0fu/rbxport/nix-source-package";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  home =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      home.packages = [
        inputs.rbxport.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
