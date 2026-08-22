{
  os =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    {
      # services.avahi = {
      #   enable = true;
      #   publish = {
      #     enable = true;
      #     userServices = true;
      #   };
      # };

      # networking.firewall = {
      #   allowedTCPPorts = [ 9757 ];
      #   allowedUDPPorts = [ 9757 ];
      # };

      # environment = {
      #   pathsToLink = [ "/share/openxr" ];
      # };

      environment.systemPackages = [ pkgs.motoc ];
      services.wivrn = {
        enable = true;
        package =
          let
            # src = pkgs.wivrn;
            src = inputs.wivrn.packages.${pkgs.stdenv.hostPlatform.system}.default;
          in
          (src.overrideAttrs (prevAttrs: {
            preFixup = (builtins.elemAt prevAttrs.preFixup 0) + ''
              wrapProgram "$out/bin/wivrn-server" \
                --prefix LD_LIBRARY_PATH : ${
                  lib.makeLibraryPath [
                    pkgs.sdl2-compat
                    pkgs.udev
                  ]
                }
            '';
          }));
        steam = {
          enable = true;
          importOXRRuntimes = true;
        };
        openFirewall = true;
        autoStart = true;
        highPriority = true;
        config = {
          enable = true;
          json = {
            application = (
              pkgs.writeShellScriptBin "wivrn-launch-script" ''
                sleep 1
                (${lib.getExe pkgs.motoc} continue && ${lib.getExe pkgs.libnotify} "motoc calibration loaded") || ${lib.getExe pkgs.libnotify} -u critical "Failed to load motoc calibration!"
                sleep 1
                wayvr
              ''
            );
            bit-depth = 10;
            tcp-only = true;
            encoder = {
              codec = "av1";
              encoder = "vaapi";
            };
            openvr-compat-path =
              let
                pkg = pkgs.xrizer.overrideAttrs (
                  finalAttrs: previousAttrs: {
                    postInstall = previousAttrs.postInstall + ''
                      touch $out/lib/xrizer/bin/version.txt
                    '';
                  }
                );
              in
              "${pkg}/lib/xrizer";
            scale = 1;
            use-steamvr-lh = true;
          };
        };
      };
    };
}
