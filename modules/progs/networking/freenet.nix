{
  os =
    { ... }:
    {
      networking.firewall.allowedUDPPorts = [ 49367 ];
    };
  home =
    { pkgs, inputs, ... }:
    {
      home.packages = [
        inputs.freenet.packages.${pkgs.stdenv.system}.default
      ];
      # systemd.user.services.freenet-autoupdate = {
      #   Service = {
      #     ExecStart = "${inputs.freenet.packages.${pkgs.stdenv.system}.default}/bin/freenet-autoupdate";
      #   };
      # };
    };
}
