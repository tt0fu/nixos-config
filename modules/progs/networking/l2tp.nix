{
  enable = true;
  os =
    { pkgs, ... }:

    {
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
