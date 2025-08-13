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

if [ "$freed_kb" -ge 1048576 ]; then
    freed=$(echo "scale=2; $freed_kb / 1048576" | bc)
    unit="GB"
elif [ "$freed_kb" -ge 1024 ]; then
    freed=$(echo "scale=2; $freed_kb / 1024" | bc)
    unit="MB"
else
    freed=$freed_kb
    unit="KB"
fi

# Display results
echo "Freed $freed $unit"
