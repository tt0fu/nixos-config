{
  home =
    {
      pkgs,
      self,
      lib,
      ...
    }:
    {
      home.packages = [ (pkgs.callPackage self.package { }) ];
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("pulsemeeter", { tag = "do_not_close" }) end'')
          ];
        }
      ];
    };
  package =
    {
      lib,
      python3Packages,
      fetchFromGitHub,
      libappindicator,
      gobject-introspection,
      wrapGAppsHook4,
      callPackage,
      bash,
      pipewire,
      gtk4,
    }:
    python3Packages.buildPythonApplication (finalAttrs: {
      pname = "pulsemeeter";
      version = "2.2.0-fix";
      pyproject = true;

      src = fetchFromGitHub {
        owner = "theRealCarneiro";
        repo = "pulsemeeter";
        rev = "d6f02564669a03da9654fc3eb2eab92f1b18d4e2";
        hash = "sha256-x1ps9uUpUdIJl2M4fwhQIA8gDPbp04gzT2dRHfHjZRo=";
      };

      build-system = with python3Packages; [
        setuptools
        babel
      ];

      dependencies = with python3Packages; [
        pygobject3
        pydantic
        pulsectl
        pulsectl-asyncio
      ];

      nativeBuildInputs = [
        wrapGAppsHook4
        gobject-introspection
      ];

      buildInputs = [
        libappindicator
        pipewire
        bash
        gtk4
      ];

      makeWrapperArgs = [
        "\${gappsWrapperArgs[@]}"
      ];

      dontWrapGApps = true;

      pythonImportsCheck = [ "pulsemeeter" ];

      passthru.tests.version = callPackage ./version-test.nix { inherit (finalAttrs) version; };

      meta = {
        description = "Pulseaudio and pipewire audio mixer inspired by voicemeeter";
        license = lib.licenses.mit;
        homepage = "https://github.com/theRealCarneiro/pulsemeeter";
        maintainers = with lib.maintainers; [
          therobot2105
        ];
        mainProgram = "pulsemeeter";
        platforms = lib.platforms.linux;
      };
    });
}
