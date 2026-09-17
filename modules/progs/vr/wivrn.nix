{
  inputs = {
    wivrn = {
      url = "github:WiVRn/WiVRn/poc/layer-alpha-blend";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  os =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [ pkgs.motoc ];
      services.wivrn = {
        enable = true;

        # package = pkgs.wivrn;
        package = inputs.wivrn.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
