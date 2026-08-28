set -euo pipefail

nix run .#generate-inputs

nix flake update && ./build.sh "${1-boot}" "${@:2}"
