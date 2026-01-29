{
  deps =
    modules: with modules.progs.networking; [
      # cloudflare-warp
      # throne
      # tor
      winbox
      wireguard
    ];
}
