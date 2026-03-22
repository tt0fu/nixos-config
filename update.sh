command=$1;

if [ "$1" == "" ]; then
    command="boot"
fi

nix flake update && ./build.sh $command "${@:2}"
