git add --all

nixos-rebuild switch --flake . --cores 0 --max-jobs 4 --show-trace --sudo
