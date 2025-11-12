{
  pkgs,
  lib,
  userSettings,
  ...
}:

{
  services.wivrn = {
    enable = true;
    openFirewall = true;
    defaultRuntime = true;
    autoStart = true;
    config = {
      enable = true;
      json = {
        scale = 1.0;
        bitrate = 200000000;
        encoders = [
          {
            encoder = "vaapi";
            codec = "h265";
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
        application = [
          (pkgs.writeShellScriptBin "wivrn-launch-script" ''
            sleep 5
            (${pkgs.motoc}/bin/motoc continue && notify-send "motoc calibration loaded") || notify-send -u critical "Failed to load motoc calibration!"
            sleep 1
            ${pkgs.wlx-overlay-s}/bin/wlx-overlay-s
          '')
        ];
        use-steamvr-lh = true;
        openvr-compat-path = "${pkgs.opencomposite}/lib/opencomposite";
      };
    };
    package = pkgs.wivrn.overrideAttrs (oldAttrs: {
      preFixup = oldAttrs.preFixup + ''
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
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        motoc
      ];
    };
}
