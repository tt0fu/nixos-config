# ttofu's NixOS config

![image](assets/preview.png)

## Installation

1. Install NixOS and add these lines to your `/etc/nixos/configuration.nix`

```nix
...
networking.hostName = "<your hostname>";
environment.systemPackages = with pkgs; [
  ...
  git
  ...
];
nix.settings.experimental-features = ["nix-command" "flakes"];
nixpkgs.config.allowUnfree = true;
programs.nh.enable = true;
...
```

2. Rebuild the system:

```sh
$ sudo nixos-rebuild switch
```

3. Clone this repository and enter it:

```sh
$ git clone https://github.com/tt0fu/nixos-config
$ cd nixos-config
```

4. Add your `hardware-configuration.nix` as a module in `./modules/systems/<your hostname>.nix`. Don't forget to wrap it:

```nix
# modules/systems/<your hostname>.nix
{
  os = <the contents of the original hardware-configuration.nix>
}
```

So it will look something like this:

```nix
# modules/systems/<your hostname>.nix
{
  os =
    {
      pkgs,
      config,
      lib,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
      ...
    };
}
```

5. Go to `settings.nix`. Add your hostname to the `systems` attrset, copying the configuration from other systems. Change the settings to your liking, they should be self-explanatory. Make sure to add `systems.<your hostname>` to the module list.

6. Build the system and reboot:

```sh
$ ./build.sh boot && reboot
```

After rebooting, you should now see the config successfully applied to your install.

## Build system

The config is built with the [nixos-builder](https://github.com/tt0fu/nixos-builder) flake. Read it's README file to understand it's capabilities.

## Usage

- To rebuild, run `build.sh` with the command of nh os and any additional arguments. For example: `build.sh boot --install-bootloader` or `build.sh repl`, etc. The default command is `switch`.
- To update and rebuild, run `update.sh` with the command of nh os and any additional arguments. The default command is `boot`.
- To clean unused files, delete previous generations and optimize the nix store, run `clean.sh`.
