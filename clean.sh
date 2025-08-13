before=$(df -k . | awk 'NR==2 {print $4}')

sudo nix-collect-garbage -d
nix-collect-garbage -d

sudo nix store gc
nix store gc

sudo nix profile wipe-history
nix profile wipe-history

sudo nh clean all
nh clean all

sudo nix store optimise
nix store optimise

after=$(df -k . | awk 'NR==2 {print $4}')

freed_kb=$((after - before))

echo ""

echo "Cleaning freed $freed_kb KB"
