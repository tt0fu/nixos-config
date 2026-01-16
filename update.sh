command=$1;

if [ "$1" == "" ]; then
    command="boot"
fi

sudo nix flake update && ./build.sh $command
