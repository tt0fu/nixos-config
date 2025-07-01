FILE_PATH="./core/hardware-configuration.nix"

rm "$FILE_PATH"

nixos-generate-config --show-hardware-config > "$FILE_PATH"

git add --all

sudo nixos-rebuild switch --flake . --show-trace
