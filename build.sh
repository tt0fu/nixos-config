FILE_PATH="./core/hardware-configuration.nix"

if [ ! -f "$FILE_PATH" ]; then
  nixos-generate-config --show-hardware-config > "$FILE_PATH"
fi

sudo nixos-rebuild switch --flake . --show-trace
