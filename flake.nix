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
    hyprland.url = "github:hyprwm/Hyprland";
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

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      hyprland,
      ...
    }:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostname = "ttofu-laptop";
        timeZone = "Asia/Yekaterinburg";
        locale = "en_US.UTF-8";
        monitor = "eDP-1";
      };
      userSettings = {
        username = "ttofu";
        gitEmail = "tt0fu@users.noreply.github.com";
      };
    in
    {
      nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
        system = systemSettings.system;
        modules = [
          inputs.home-manager.nixosModules.default
          inputs.nixvim.nixosModules.nixvim
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
    };
}
