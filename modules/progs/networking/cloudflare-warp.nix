{
  os =
    { ... }:

    {
      services.cloudflare-warp = {
        enable = true;
        openFirewall = true;
      };
    };
}
