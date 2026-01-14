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
    nix-math.url = "github:xddxdd/nix-math";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
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
    sonusmix = {
      url = "git+https://codeberg.org/ttofu/sonusmix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wivrn = {
      url = "github:WiVRn/WiVRn/v25.12";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
            ]
            ++ (map (p: ./apps + p) system.apps);
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
