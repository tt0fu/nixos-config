{
  description = "ttofu's nixos config";

  inputs = {
    nixos-builder.url = "github:tt0fu/nixos-builder";
    
    # Do not edit the inputs between the markers. They will get rewritten by
    # `nix run .#generate-inputs` (run automatically by build.sh / update.sh).
    # GENERATED INPUTS START
    freenet = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:freenet/freenet-core";
    };
    gridboard = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:tt0fu/gridboard";
    };
    home-manager = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/home-manager";
    };
    hypr-dynamic-cursors = {
      inputs = {
        hyprland = {
          follows = "hyprland";
        };
      };
      url = "github:VirtCode/hypr-dynamic-cursors";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    hyprland-plugins = {
      inputs = {
        hyprland = {
          follows = "hyprland";
        };
      };
      url = "github:hyprwm/hyprland-plugins";
    };
    nix-math = {
      url = "github:xddxdd/nix-math";
    };
    nixcord = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:4evy/nixcord";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "nixpkgs/nixos-25.11";
    };
    nixpkgs-xr = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/nixpkgs-xr";
    };
    pulsemeeter = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:theRealCarneiro/pulsemeeter";
    };
    quickshell = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:quickshell-mirror/quickshell";
    };
    wivrn = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:WiVRn/WiVRn/poc/layer-alpha-blend";
    };
    zen-browser = {
      inputs = {
        home-manager = {
          follows = "home-manager";
        };
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:0xc000022070/zen-browser-flake";
    };
    # GENERATED INPUTS END
  };

  outputs =
    inputs:
    (inputs.nixos-builder.lib.outputs {
      inherit inputs;
      settingsPath = ./settings.nix;
      modulesPath = ./modules;
      extraNixpkgs = {
        pkgs-stable = inputs.nixpkgs-stable;
      };
    });
}
