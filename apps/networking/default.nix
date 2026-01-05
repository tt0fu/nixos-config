{ ... }:
{
  imports = [
    # ./cloudflare-warp.nix
    ./throne.nix
    # ./tor.nix
    ./winbox.nix
    ./wireguard.nix
    # ./zapret
  ];
}
