{
  os =
    { systemSettings, ... }:

    {
      time = {
        timeZone = systemSettings.timeZone;
      };
      services.timesyncd = {
        enable = true;
        servers = [
          "162.159.200.1" # time.cloudflare.com (anycast)
          "162.159.200.123" # time.cloudflare.com (anycast)
          "216.239.35.0" # time.google.com (anycast)
          "216.239.35.1" # time.google.com (anycast)
        ];
        settings.Time.ConnectionRetrySec = 5;
      };
    };
}
