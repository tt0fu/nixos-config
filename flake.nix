{
  description = "ttofu's nixos config";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-math.url = "github:xddxdd/nix-math";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      config = import ./config.nix;
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (system: {
          name = system.settings.hostname;
          value = nixpkgs.lib.nixosSystem {
            system = system.settings.system;
            modules = [
              home-manager.nixosModules.default
              ./systems
              ./core
              ./desktop-environment
              ./apps
            ];
            specialArgs = {
              inherit inputs;
              systemSettings = system.settings;
              userSettings = config.userSettings;
              style = nixpkgs.lib.recursiveUpdate config.baseStyle system.styleOverrides;
              color = import ./lib/color.nix { math = inputs.nix-math.lib.math; };
            };
          };
        }) config.systems
      );
    };
}
