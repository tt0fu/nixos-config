{
  description = "ttofu's flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
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
  };

  outputs = inputs@{ nixpkgs, home-manager, hyprland, ... }: 
    let 
      systemSettings = {
        system = "x86_64-linux";
        hostname = "ttofu-pc";
        timeZone = "Europe/Moscow";
        locale = "en_US.UTF-8";
	monitor = "DP-1";
      };
      userSettings = {
        username = "ttofu";
	gitEmail = "tt0fu@users.noreply.github.com";
      };
      pkgs-unstable = import inputs.nixpkgs {
       system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
    in {
      nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
        system = systemSettings.system;
        modules = [
	  ./core/core.nix
          ./desktop-environment/desktop-environment.nix
	  ./apps/apps.nix
	];
	specialArgs = {
	  inherit inputs; 
	  inherit systemSettings;
	  inherit userSettings; 	
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
