set -euo pipefail

nix run .#generate-inputs

git add --all

nh os "${1-switch}" . --show-trace "${@:2}"

# nixos-rebuild $command --flake . --cores 0 --show-trace --log-format bar-with-logs --sudo "${@:2}" # --debug --print-build-logs
