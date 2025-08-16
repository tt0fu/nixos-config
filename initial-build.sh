nixos-generate-config --show-hardware-config > "./hosts/$HOSTNAME.nix"

nano flake.nix

./build.sh boot && reboot
