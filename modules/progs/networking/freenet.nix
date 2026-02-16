{
  os =
    { pkgs, ... }:
    {
      # systemd.services.freenet = {
      #   enable = true;
      #   path = [ (pkgs.callPackage allModules.progs.networking.freenet.package { }) ];
      #   script = "freenet";
      # };

    };
  home =
    { pkgs, inputs, ... }:
    {
      home.packages = [
        # inputs.freenet.packages.${pkgs.stdenv.system}.default
        (pkgs.writeShellScriptBin "freenet-autoupdate" ''
          trap "" INT

          while true; do
              nix run github:freenet/freenet-core#freenet
              exit_code=$?

              if [ $exit_code -eq 42 ]; then
                  echo "Autoupdate triggered. Restarting..."
              else
                  echo "Non-autoupdate exit code: $exit_code. Stopping."
                  break
              fi
          done'')
      ];
    };
}
