{
  os =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:

    {
      services.wivrn = {
        enable = true;
        openFirewall = true;
        defaultRuntime = true;
        autoStart = true;
        steam.importOXRRuntimes = true;
        config = {
          enable = true;
          json = {
            scale = 1.0;
            bitrate = 200000000;
            encoders = [
              {
                encoder = "vaapi";
                codec = "av1";
                width = 1.0;
                height = 1.0;
                offset_x = 0.0;
                offset_y = 0.0;
              }
            ];
            application = [
              (pkgs.writeShellScriptBin "wivrn-launch-script" ''
                sleep 5
                (${pkgs.motoc}/bin/motoc continue && ${pkgs.libnotify}/bin/notify-send "motoc calibration loaded") || ${pkgs.libnotify}/bin/notify-send -u critical "Failed to load motoc calibration!"
                sleep 1
                ${pkgs.wayvr}/bin/wayvr
              '')
            ];
            use-steamvr-lh = true;
            openvr-compat-path = "${pkgs.opencomposite}/lib/opencomposite";
          };
        };
        package =
          let
            src = pkgs.wivrn;
            # src = inputs.wivrn.packages.${pkgs.stdenv.hostPlatform.system}.default;
          in
          src.overrideAttrs (prevAttrs: {
            preFixup = prevAttrs.preFixup + ''
              wrapProgram "$out/bin/wivrn-server" \
                --prefix LD_LIBRARY_PATH : ${
                  lib.makeLibraryPath [
                    pkgs.sdl2-compat
                    pkgs.udev
                  ]
                }
            '';
          });
      };
    };
  home =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.motoc
      ];
    };
}
