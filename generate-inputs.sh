set -euo pipefail

export generated="$(nix eval --raw --file "lib/generate-inputs.nix" generatedInputs)"

awk '
  /^[[:space:]]*# GENERATED INPUTS START$/ { print; print ENVIRON["generated"]; in_gen = 1; next }
  /^[[:space:]]*# GENERATED INPUTS END$/ { print; in_gen = 0; next }
  !in_gen { print }
' "flake.nix" > "flake.nix.tmp"

if grep -q '# GENERATED INPUTS START' "flake.nix.tmp" && grep -q '# GENERATED INPUTS END' "flake.nix.tmp"; then
    mv "flake.nix.tmp" "flake.nix"
else
    echo "error: failed to generate flake inputs" >&2
    rm "flake.nix.tmp"
    exit 1
fi

