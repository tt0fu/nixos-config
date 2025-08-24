nixos-generate-config --show-hardware-config > "./systems/$HOSTNAME.nix"

nano flake.nix

./build.sh boot && reboot
