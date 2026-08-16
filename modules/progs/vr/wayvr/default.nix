{
  home =
    {
      self,
      pkgs,
      ...
    }:
    {
      home = {
        packages = [
          # pkgs.wayvr
          (pkgs.callPackage self.package { })
        ];
        file =
          let
            toYAML = pkgs.lib.generators.toYAML { };
            toJSON = pkgs.lib.generators.toJSON { };
          in
          {
            ".config/wayvr/openxr_actions.json5".text = toJSON (import ./actions.nix);
            ".config/wayvr/keyboard.yaml".text = toYAML (import ./keyboard.nix);
            ".config/wayvr/conf.d/layouts.yaml".text = toYAML (import ./layouts.nix);
            ".config/wayvr/conf.d/theme.yaml".text = toYAML (import ./theme.nix);
            ".config/wayvr/conf.d/clock.yaml".text = toYAML (import ./clock.nix);
            ".config/wayvr/theme/gui/watch.xml".source = ./watch.xml;
          };
      };
    };

  package =
    {
      alsa-lib,
      dav1d,
      dbus,
      fetchFromGitHub,
      lib,
      libinput,
      libx11,
      libxext,
      libxrandr,
      libxcb,
      libxkbcommon,
      nix-update-script,
      openssl,
      openvr,
      openxr-loader,
      pipewire,
      pkg-config,
      procps,
      pulseaudio,
      rustPlatform,
      shaderc,
      stdenv,
      testers,
      udev,
      wayvr,
      withOpenVR ? !stdenv.hostPlatform.isAarch64,
    }:
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "wayvr";
      version = "test-passthru-windows";

      src = fetchFromGitHub {
        owner = "wlx-team";
        repo = "wayvr";
        rev = "6e29846711b3efb4230e8410bfeab842f149f478";
        hash = "sha256-wQ7B+SUjtryWnb6efGTaMCk/OUszbPwh3+n3uyxwuv4=";
      };

      cargoHash = "sha256-nYI9sGx7F4Jxrt1Rtdi6sia6IqGXsU2Ugx4COk8mGSk=";

      nativeBuildInputs = [
        pkg-config
        rustPlatform.bindgenHook
      ];

      buildInputs = [
        alsa-lib
        dav1d
        dbus
        libinput
        libx11
        libxext
        libxrandr
        libxcb
        libxkbcommon
        openssl
        openxr-loader
        pipewire
        udev
      ]
      ++ lib.optionals withOpenVR [ openvr ];

      env.SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

      postPatch = ''
        substituteAllInPlace dash-frontend/src/util/pactl_wrapper.rs \
          --replace-fail '"pactl"' '"${lib.getExe' pulseaudio "pactl"}"'

        # steam_utils also calls xdg-open as well as steam. Those should probably be pulled from the environment
        substituteInPlace dash-frontend/src/util/steam_utils.rs \
          --replace-fail '"pkill"' '"${lib.getExe' procps "pkill"}"'
      '';

      buildNoDefaultFeatures = true;
      buildFeatures = [
        "openxr"
        "osc"
        "x11"
        "wayland"
      ]
      ++ lib.optionals withOpenVR [ "openvr" ];

      postInstall = ''
        install -D wayvr/wayvr.desktop -t $out/share/applications
        install -D wayvr/wayvr.svg -t $out/share/icons/hicolor/scalable/apps

        rm $out/bin/prost_build
      '';

      passthru = {
        tests.testVersion = testers.testVersion { package = wayvr; };

        updateScript = nix-update-script { };
      };

      meta = {
        description = "Your way to enjoy VR on Linux! Access your Wayland/X11 desktop from SteamVR/Monado (OpenVR+OpenXR support)";
        homepage = "https://github.com/wlx-team/wayvr";
        license = with lib.licenses; [
          gpl3Only
          mit # wayvr-ipc
        ];
        maintainers = with lib.maintainers; [ Scrumplex ];
        platforms = lib.platforms.linux;
        broken = stdenv.hostPlatform.isAarch64 && withOpenVR;
        mainProgram = "wayvr";
      };
    });
}
