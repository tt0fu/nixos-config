{
  inputs,
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
            (${pkgs.motoc}/bin/motoc continue && ${pkgs.libnotify}/bin/notify-send "motoc calibration loaded") || ${pkgs.libnotify}/bin/notify-send -u critical "Failed to load motoc calibration!"
            sleep 1
            ${pkgs.wlx-overlay-s}/bin/wlx-overlay-s
          '')
        ];
        use-steamvr-lh = true;
        openvr-compat-path = "${pkgs.opencomposite}/lib/opencomposite";
      };
    };
    # package = pkgs.wivrn.overrideAttrs (
    #   prevAttrs: finalAttrs: {
    #     src = pkgs.fetchFromGitHub {
    #       owner = "WiVRn";
    #       repo = "WiVRn";
    #       rev = "v25.11.1";
    #       sha256 = "sha256-pEKMeRdI9UhdZ+NksRBcF7yPC7Ys2haE+B4PPGQ4beE=";
    #     };
    #     monado = pkgs.applyPatches {
    #       src = pkgs.fetchFromGitLab {
    #         domain = "gitlab.freedesktop.org";
    #         owner = "monado";
    #         repo = "monado";
    #         rev = "06e62fc7d9c5cbcbc43405bb86dfde3bf01ce043";
    #         sha256 = "sha256-0ALB9eLY4NAUqNOYZMwpvYnLxVpHsQDJc1er8Txdezs=";
    #       };
    #       postPatch = ''
    #         ${finalAttrs.src}/patches/apply.sh ${finalAttrs.src}/patches/monado/*
    #       '';
    #     };
    # };
    package = inputs.wivrn.packages.${pkgs.system}.default.overrideAttrs (prevAttrs: {
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
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        motoc
      ];
    };
}
