{
  enable = true;
  os =
    { pkgs, ... }:

    {
      systemd.tmpfiles.rules = [ "d /etc/ipsec.d 0700 root root -" ];
      environment.etc."strongswan.conf".text = "";
      networking.networkmanager.plugins = [
        (pkgs.networkmanager-l2tp.override {
          strongswan = pkgs.strongswan.overrideAttrs (oldAttrs: {
            dontStrip = true;
            configureFlags = (oldAttrs.configureFlags or [ ]) ++ [ "--enable-ikev1" ];
          });
        })
      ];
    };
}
