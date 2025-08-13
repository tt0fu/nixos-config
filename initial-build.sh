nixos-generate-config --show-hardware-config > "./hosts/$HOSTNAME.nix"

nano flake.nix

git add --all

sudo nixos-rebuild boot --flake . --cores 0 --max-jobs 4 --show-trace --sudo

reboot
