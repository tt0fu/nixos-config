{
  deps =
    modules: with modules.progs.networking; [
      # cloudflare-warp
      freenet
      # throne
      # tor
      winbox
      wireguard
    ];
}
