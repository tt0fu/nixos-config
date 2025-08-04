{ inputs, ... }:

{
  environment.systemPackages = [ inputs.wireguard-gui.packages.wireguard-gui-tauri ];
}
