{
  os =
    {
      pkgs,
      ...
    }:
    let
      wivrn = pkgs.wivrn.overrideAttrs (old: {
        src = pkgs.applyPatches {
          src = old.src;
          patches = [ ./alpha-blend.patch ];
        };
      });
    in
    {
      environment.systemPackages = [ pkgs.motoc ];
      services.wivrn = {
        enable = true;

        package = wivrn;

        steam = {
          enable = true;
          importOXRRuntimes = true;
        };
        openFirewall = true;
        autoStart = true;
        config = {
          enable = true;
          json = {
            application = (
              pkgs.writeShellScriptBin "wivrn-launch-script" ''
                motoc continue && notify-send "motoc calibration loaded"
                wayvr
              ''
            );
            bit-depth = 10;
            tcp-only = true;
            encoder = {
              codec = "av1";
              encoder = "vaapi";
            };
            openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
            scale = 1;
            use-steamvr-lh = true;
          };
        };
      };
    };
}
