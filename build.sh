git add --all

command=$1;

if [ "$1" == "" ]; then
    command="switch"
fi

nh os $command . --show-trace "${@:2}"

# nixos-rebuild $command --flake . --cores 0 --show-trace --log-format bar-with-logs --sudo "${@:2}" # --debug --print-build-logs