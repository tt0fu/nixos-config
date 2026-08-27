set -euo pipefail

./generate-inputs.sh

nix flake update && ./build.sh "${1-boot}" "${@:2}"
