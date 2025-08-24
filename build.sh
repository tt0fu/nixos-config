git add --all

command=$1;

if [ "$1" == "" ]; then
    command="switch"
fi

sudo nixos-rebuild $command --flake . --cores 0 --max-jobs 4 --show-trace
