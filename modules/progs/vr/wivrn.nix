{
  os =
    {
      ...
    }:
    {
      services.avahi = {
        enable = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };

      networking.firewall = {
        allowedTCPPorts = [ 9757 ];
        allowedUDPPorts = [ 9757 ];
      };

      environment = {
        pathsToLink = [ "/share/openxr" ];
      };
    };
  home =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    {
      home = {
        packages =
          let
            # src = pkgs.wivrn;
            src = inputs.wivrn.packages.${pkgs.stdenv.hostPlatform.system}.default;
          in
          [
            pkgs.motoc
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
            }))
          ];
        file.".config/wivrn/config.json".text = pkgs.lib.generators.toJSON { } {
          application = lib.getExe (
            pkgs.writeShellScriptBin "wivrn-launch-script" ''
              sleep 1
              (${lib.getExe pkgs.motoc} continue && ${lib.getExe pkgs.libnotify} "motoc calibration loaded") || ${lib.getExe pkgs.libnotify} -u critical "Failed to load motoc calibration!"
              sleep 1
              ${lib.getExe pkgs.wayvr} &
              sleep 1
              DISPLAY= WAYLAND_DISPLAY=wayland-''$(cat ''$XDG_RUNTIME_DIR/wayvr.disp) ${lib.getExe inputs.gridboard.packages.${pkgs.stdenv.system}.default}
            ''
          );
          bitrate = 200000000;
          encoders = [
            {
              codec = "av1";
              encoder = "vaapi";
              height = 1;
              offset_x = 0;
              offset_y = 0;
              width = 1;
            }
          ];
          openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
          scale = 1;
          use-steamvr-lh = true;
        };
        sessionVariables.PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = "1";
      };
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("wivrn-server -f ~/.config/wivrn/config.json") end'')
          ];
        }
      ];
    };
}
