{
  home =
    { self, pkgs, ... }:
    {
      home.packages = [
        (pkgs.callPackage self.package { })
      ];
    };
  package =
    {
      clangStdenv,
      fetchFromGitHub,
      nodejs,
      autoPatchelfHook,
      wrapGAppsHook3,
      git,
      pkg-config,
      gtk3,
      pango,
      cairo,
      gdk-pixbuf,
      atk,
      glib,
      harfbuzz,
      alsa-lib,
      vulkan-loader,
      libXi,
      libXrandr,
      libXcursor,
      openssl,
      makeWrapper,
      runtimeShell,
    }:
    clangStdenv.mkDerivation {
      pname = "armorpaint";
      version = "0.9";

      src = fetchFromGitHub {
        owner = "armory3d";
        repo = "armorpaint";
        rev = "5f974b598b215ed388d2c4e3a5dfd49ae949e515";
        sha256 = "sha256-xYTW3K8EpQunjJLyNVql4AQE1FdMw0fnA+S2ERFQeAg=";
        fetchSubmodules = true;
        leaveDotGit = true;
      };

      nativeBuildInputs = [
        autoPatchelfHook
        wrapGAppsHook3
        pkg-config
        git
        makeWrapper
        nodejs
      ];

      buildInputs = [
        nodejs
        gtk3
        gdk-pixbuf
        pango
        cairo
        atk
        glib
        harfbuzz
        alsa-lib
        vulkan-loader
        libXi
        libXrandr
        libXcursor
        openssl
      ];

      # Patch the physical-cpu-count module for deterministic builds
      # patchPhase = ''
      #   cat > base/tools/amake/node_modules/physical-cpu-count/index.js << EOF
      #   'use strict'
      #   let amount = $NIX_BUILD_CORES
      #   module.exports = amount
      #   EOF
      # '';

      # Build the project
      buildPhase = ''
        runHook preBuild

        # Navigate to the paint directory and run the build script
        cd paint
        bash ../base/make --compile

        runHook postBuild
      '';

      # Install the built files
      installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,opt/Deployment,opt/build,share/icons/hicolor/256x256/apps}

        # Copy the built application and data files
        cp -r ../base/Deployment/* $out/opt/Deployment/
        cp -r build/* $out/opt/build

        # Create a wrapper script to launch ArmorPaint
        cat > $out/bin/armorpaint <<EOF
        #!${runtimeShell} -e
        $out/opt/Deployment/Krom $out/opt/build/krom/ "\$@"
        EOF
        chmod +x $out/bin/armorpaint

        # Copy the application icon
        cp ../base/icon.png $out/share/icons/hicolor/256x256/apps/armorpaint.png

        runHook postInstall
      '';
    };

}
