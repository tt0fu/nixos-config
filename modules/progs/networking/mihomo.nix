{
  os =
    { pkgs, userSettings, ... }:

    {
      services.mihomo = {
        enable = true;
        tunMode = true;
        configFile = "/home/${userSettings.username}/.config/mihomo/config.yaml";
        webui = pkgs.metacubexd;
      };

      services.resolved = {
        enable = true;
        settings.Resolve = {
          DNS = [
            "8.8.8.8#dns.google"
            "1.1.1.1#one.one.one.one"
          ];
          FallbackDNS = [
            "77.88.8.8#common.dot.dns.yandex.net"
            "223.5.5.5"
          ];
          Domains = "~.";
          DNSOverTLS = false;
          DNSSEC = false;
        };
      };
    };
}
