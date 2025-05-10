nix-env --delete-generations 3d
sudo nix-env --delete-generations 3d

nix-collect-garbage --delete-older-than 3d
sudo nix-collect-garbage --delete-older-than 3d

nix-collect-garbage -d
sudo nix-collect-garbage -d

nix-store --gc
sudo nix-store --gc

nix store optimise
sudo nix store optimise

rm -rf ~/.local/state/home-manager
rm -f ~/.local/state/nix/profiles/home-manager*
