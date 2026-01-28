before=$(df -k . | awk 'NR==2 {print $4}')

# sudo nix-collect-garbage -d
# nix-collect-garbage -d

# sudo nix store gc
# nix store gc

# sudo nix profile wipe-history
# nix profile wipe-history

# sudo nix store optimise
# nix store optimise

nh clean all

after=$(df -k . | awk 'NR==2 {print $4}')

freed_gb=$(echo $after $before | awk '{print ($1 - $2) / 1024.0 / 1024.0}')

echo ""

echo "Cleaning freed $freed_gb GB"
