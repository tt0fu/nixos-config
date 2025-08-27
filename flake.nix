{
  description = "ttofu's nixos config";

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # change these settings
      userSettings = {
        username = "ttofu";
        gitEmail = "tt0fu@users.noreply.github.com";
      };

      systems = [
        {
          hostname = "ttofu-laptop";
          system = "x86_64-linux";
          timeZone = "Europe/Moscow";
          locale = "en_US.UTF-8";
          monitor = "eDP-1";
          vpnName = "NL2_Laptop";
        }
        {
          hostname = "ttofu-pc";
          system = "x86_64-linux";
          timeZone = "Europe/Moscow";
          locale = "en_US.UTF-8";
          monitor = "DP-1";
          vpnName = "NL2_PC";
        }
      ];
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (systemSettings: {
          name = systemSettings.hostname;
          value = nixpkgs.lib.nixosSystem {
            system = systemSettings.system;
            modules = [
              home-manager.nixosModules.default
              ./systems
              ./core
              ./desktop-environment
              ./apps
            ];
            specialArgs = {
              inherit inputs;
              inherit systemSettings;
              inherit userSettings;
            };
          };
        }) systems
      );
    };

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
  };
}
