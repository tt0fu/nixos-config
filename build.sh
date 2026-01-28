git add --all

command=$1;

if [ "$1" == "" ]; then
    command="switch"
fi
nh os $command .
# --debug --print-build-logs
# nixos-rebuild $command --flake . --cores 0 --show-trace --log-format bar-with-logs --sudo