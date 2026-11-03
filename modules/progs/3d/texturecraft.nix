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
      dbus,
      wayland,
      libxkbcommon,
      libX11,
      libxcb,
      libXcursor,
      libXi,
      libXrandr,
    }:
    let
      version = "0.2.0";
      buildDate = "2026-11-02";
      rev = "79a5c50ef685996c0e74a38da1b80fe524c4aea9";
      hash = "sha256-NJymjwr3342aU9u7gD1yiMAd1GaBO48hSz2HlkBlxpc=";
      cargoHash = "sha256-AWZJzry+5cSx/oPpJaVn5LWcqCU6m4n0jzKUURD7D+E=";
    in
    rustPlatform.buildRustPackage {
      pname = "texturecraft";
      inherit version;

      src = fetchFromGitHub {
        owner = "storytold";
        repo = "texturecraft";
        inherit rev hash;
      };

      inherit cargoHash;
      useFetchCargoVendor = true;

      cargoBuildFlags = [
        "-p"
        "texturecraft"
        "-p"
        "texturecraft-cli"
      ];

      doCheck = false;

      env = {
        TEXTURECRAFT_BUILD_SHA = rev;
        TEXTURECRAFT_BUILD_DATE = buildDate;
      };

      nativeBuildInputs = [ makeWrapper ];

      postInstall = ''
        APP_ID=ai.storyteller.texturecraft

        install -Dm644 packaging/linux/$APP_ID.desktop \
          $out/share/applications/$APP_ID.desktop
        install -Dm644 packaging/linux/$APP_ID.mime.xml \
          $out/share/mime/packages/$APP_ID.xml
        sed -e "s/@VERSION@/${version}/g" -e "s/@DATE@/${buildDate}/g" \
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
            --prefix LD_LIBRARY_PATH : ${
              lib.makeLibraryPath [
                vulkan-loader
                libGL
                dbus
                wayland
                libxkbcommon
                libX11
                libxcb
                libXcursor
                libXi
                libXrandr
              ]
            }:/run/opengl-driver/lib
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
        changelog = "https://github.com/storytold/texturecraft/releases/tag/v${version}";
        license = with lib.licenses; [
          mit
          asl20
        ];
        sourceProvenance = [ lib.sourceTypes.fromSource ];
        platforms = lib.platforms.linux;
        mainProgram = "texturecraft";
      };
    };
}
