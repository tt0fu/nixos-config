# ttofu's NixOS config



## Installation

1. Install NixOS and add these lines to your `/etc/nixos/configuration.nix`

```
...
networking.hostName = "MY-HOSTNAME";
environment.systemPackages = with pkgs; [
  ...
  git
  ...
];
nix.settings.experimental-features = ["nix-command" "flakes"];
nixpkgs.config.allowUnfree = true;
...
```

2. Rebuild the repository:

```
sudo nixos-rebuild switch
```

3. Clone this repository and enter it:

```
git clone https://github.com/tt0fu/nixos-config my-config
cd my-config
```

4. Run `initial-build.sh`

```
./initial-build.sh
```

It will generate a hardware configuration file based on your hostname and open `flake.nix` for editing.

You must change the `systems` list to have an entry describing your machine.

After saving and exiting, the config will get built using `nixos-rebuild boot` and the computer will be rebooted to avoid any problems with switching.

## Usage

- To rebuild, run `build.sh`.
- To update the packages, run `update.sh`.
- To clean unused files, delete previous generations and optimize the nix store, run `clean.sh`.
