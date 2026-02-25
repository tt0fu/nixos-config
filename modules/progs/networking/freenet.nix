{
  # os =
  #   { pkgs, allModules, ... }:
  #   {
  #     systemd.services.freenet = {
  #       enable = true;
  #       path = [ (pkgs.callPackage allModules.progs.networking.freenet.package { }) ];
  #       script = "freenet";
  #     };
  #   };
  home =
    { pkgs, inputs, ... }:
    {
      home.packages = [
        inputs.freenet.packages.${pkgs.stdenv.system}.default
      ];
    };
}
