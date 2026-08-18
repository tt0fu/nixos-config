{
  description = "ttofu's nixos config";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "nixpkgs/nixos-25.11";
    };
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
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
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };
    # niri = {
    #   url = "github:sodiboo/niri-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wivrn = {
      url = "github:WiVRn/WiVRn/poc/layer-alpha-blend";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    freenet = {
      url = "github:freenet/freenet-core";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gridboard = {
      url = "github:tt0fu/gridboard";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: ((import ./lib/builder.nix).outputs inputs);
}
