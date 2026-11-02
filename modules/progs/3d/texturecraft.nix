{
  enable = true;
  home =
    { self, pkgs, ... }:
    {
      home.packages = [
        (pkgs.callPackage self.package { })
      ];
    };
  package =
    {
      lib,
      fetchFromGitHub,
      rustPlatform,
      makeWrapper,
      nix-update-script,
      vulkan-loader,
      libGL,
      wayland,
      libxkbcommon,
      libX11,
      libxcb,
      libXcursor,
      libXi,
      libXrandr,
    }:
    let
      buildDate = "2026-11-01";

      runtimeLibs = lib.makeLibraryPath [
        vulkan-loader
        libGL
        wayland
        libxkbcommon
        libX11
        libxcb
        libXcursor
        libXi
        libXrandr
      ];
    in
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "texturecraft";
      version = "0.2.0";

      src = fetchFromGitHub {
        owner = "storytold";
        repo = "texturecraft";
        rev = "e01dac2c35c44e201cf9dc43965887e29f1b15d6"; # v0.2.0
        hash = "sha256-9twziHLPD76jxFdv39nMEljtSxJEZVZMePZEhFDb4Gc=";
      };

      cargoHash = "sha256-Pxuzs3Y1Jot2EnSmTFK8UaJqmbfwknVLyt9K3CzTPL0=";
      useFetchCargoVendor = true;

      cargoBuildFlags = [
        "-p"
        "texturecraft"
        "-p"
        "texturecraft-cli"
      ];

      doCheck = false;

      env = {
        TEXTURECRAFT_BUILD_SHA = finalAttrs.src.rev;
        TEXTURECRAFT_BUILD_DATE = buildDate;
      };

      nativeBuildInputs = [ makeWrapper ];

      postInstall = ''
        APP_ID=ai.storyteller.texturecraft

        install -Dm644 packaging/linux/$APP_ID.desktop \
          $out/share/applications/$APP_ID.desktop
        install -Dm644 packaging/linux/$APP_ID.mime.xml \
          $out/share/mime/packages/$APP_ID.xml
        sed -e "s/@VERSION@/${finalAttrs.version}/g" -e "s/@DATE@/${buildDate}/g" \
          packaging/linux/$APP_ID.metainfo.xml.in \
          > $APP_ID.metainfo.xml
        install -Dm644 $APP_ID.metainfo.xml $out/share/metainfo/$APP_ID.metainfo.xml

        cp -r assets/app-icon/hicolor $out/share/icons/
        install -Dm644 assets/app-icon/hicolor/256x256/apps/$APP_ID.png \
          $out/share/pixmaps/$APP_ID.png

        mkdir -p $out/share/doc/texturecraft
        cp README.md LICENSE-MIT LICENSE-APACHE NOTICE ATTRIBUTION.md \
          $out/share/doc/texturecraft/

        for prog in texturecraft texturecraft-cli; do
          wrapProgram $out/bin/$prog \
            --prefix LD_LIBRARY_PATH : ${runtimeLibs}:/run/opengl-driver/lib
        done
      '';

      passthru.updateScript = nix-update-script { };

      meta = {
        description = "Native 3D texture painter that paints PBR materials straight onto meshes";
        longDescription = ''
          TextureCraft paints PBR texture sets directly on glTF, FBX, COLLADA, USD, Alembic, OBJ,
          PLY and STL meshes with layers, masks, fills and smart materials, bakes mesh maps on the
          GPU and exports textures for game engines. Ships texturecraft-cli, the headless
          converter, baker, renderer and MCP server.
        '';
        homepage = "https://github.com/storytold/texturecraft";
        changelog = "https://github.com/storytold/texturecraft/releases/tag/v${finalAttrs.version}";
        license = with lib.licenses; [
          mit
          asl20
        ];
        sourceProvenance = [ lib.sourceTypes.fromSource ];
        platforms = lib.platforms.linux;
        mainProgram = "texturecraft";
      };
    });
}
