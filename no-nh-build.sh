set -euo pipefail

nix run .#generate-inputs

git add --all

nixos-rebuild "${1-switch}" --flake . --show-trace --log-format bar-with-logs --sudo "${@:2}" # --debug --print-build-logs
