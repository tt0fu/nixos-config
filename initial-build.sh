mkdir ./systems/$HOSTNAME

cp ./systems/default-template.nix ./systems/$HOSTNAME/default.nix

nixos-generate-config --show-hardware-config > ./systems/$HOSTNAME/hardware-configuration.nix

nano config.nix

./build.sh boot && reboot
