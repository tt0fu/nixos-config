{
  enabled = false;
  os =
    { ... }:
    {
      services.tor = {
        enable = true;
        client.enable = true;
      };
    };
}
