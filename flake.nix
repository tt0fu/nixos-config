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
      };

      baseStyle = {
        font = {
          size = 15;
          package = pkgs: pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Propo";
        };
        border = {
          thickness = 2;
          radius = 10;
        };
        spacing = 6;
      };

      systems = [
        {
          settings = {
            hostname = "ttofu-laptop";
            system = "x86_64-linux";
            timeZone = "Europe/Moscow";
            locale = "en_US.UTF-8";
            monitor = {
              name = "eDP-1";
              settings = "1920x1200@60, 0x0, 1";
            };
            vpnName = "NL2_Laptop";
          };
          styleOverrides = {
            font.size = 20;
          };
        }
        {
          settings = {
            hostname = "ttofu-pc";
            system = "x86_64-linux";
            timeZone = "Europe/Moscow";
            locale = "en_US.UTF-8";
            monitor = {
              name = "DP-1";
              settings = "1920x1080@165, 0x0, 1";
            };
            vpnName = "NL2_PC";
          };
          styleOverrides = { };
        }
      ];
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
              inherit userSettings;
              style = nixpkgs.lib.recursiveUpdate baseStyle system.styleOverrides;
              color = import ./lib/color.nix { math = inputs.nix-math.lib.math; };
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
}
