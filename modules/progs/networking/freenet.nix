{
  inputs = {
    freenet = {
      url = "github:freenet/freenet-core";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  os =
    { ... }:
    {
      networking.firewall.allowedUDPPorts = [ 49367 ];
    };
  home =
    { pkgs, inputs, ... }:
    {
      home.packages = [
        inputs.freenet.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      # systemd.user.services.freenet-autoupdate = {
      #   Service = {
      #     ExecStart = "${inputs.freenet.packages.${pkgs.stdenv.system}.default}/bin/freenet-autoupdate";
      #   };
      # };
    };
}
