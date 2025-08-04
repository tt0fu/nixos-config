FILE_PATH="./core/hardware-configuration.nix"

rm "$FILE_PATH"

nixos-generate-config --show-hardware-config > "$FILE_PATH"

nano flake.nix

git add --all

sudo nixos-rebuild boot --flake . --show-trace

reboot
