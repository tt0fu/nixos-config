git add --all

command=$1;

if [ "$1" == "" ]; then
    command="switch"
fi
# --debug --print-build-logs
nixos-rebuild $command --flake . --cores 0 --show-trace --log-format bar-with-logs --sudo
