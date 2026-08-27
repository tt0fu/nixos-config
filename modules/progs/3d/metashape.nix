{
  home =
    { self, pkgs, ... }:
    {
      home.packages = [
        (pkgs.callPackage self.metashape-pro-package { })
      ];
    };
  # metashape-package =
  #   {
  #     stdenv,
  #     lib,
  #     fetchurl,
  #     autoPatchelfHook,
  #     unzip,
  #     glibc,
  #     gcc,
  #     glib,
  #     gmp,
  #     gomp,
  #     libGL,
  #     libGLU,
  #     curl,
  #     libkrb5,
  #     gtk2,
  #     fontconfig,
  #     libxkbcommon,
  #     libxcb,
  #     libx11,
  #     libxext,
  #     libsm,
  #     libice,
  #     libxcb-wm,
  #     libxcb-image,
  #     libxcb-keysyms,
  #     libxcb-render-util,
  #     libxi,
  #     libxrender,
  #     libxml2,
  #     libtinfo,
  #     libdrm,
  #     libxshmfence,
  #     ...
  #   }:
  #   let
  #     major = "2";
  #     minor = "3";
  #     patch = "1";
  #   in
  #   stdenv.mkDerivation {
  #     pname = "metashape";
  #     version = "${major}.${minor}.${patch}";

  #     src = fetchurl {
  #       url = "https://download.agisoft.com/metashape_${major}_${minor}_${patch}_amd64.tar.gz";
  #       sha256 = "sha256-2gcK2N6oX3/v9m/Lro42iM2CflU+QXcvwT2j7T2JI/A=";
  #     };

  #     nativeBuildInputs = [
  #       autoPatchelfHook
  #       unzip
  #     ];

  #     buildInputs = [
  #       glibc
  #       gcc.cc.lib
  #       glib
  #       gmp
  #       gomp
  #       libGL
  #       libGLU
  #       curl
  #       libkrb5
  #       gtk2
  #       fontconfig
  #       libxkbcommon
  #       libxcb
  #       libx11
  #       libxext
  #       libsm
  #       libice
  #       libxcb-wm
  #       libxcb-image
  #       libxcb-keysyms
  #       libxcb-render-util
  #       libxi
  #       libxrender
  #       libxml2
  #       libtinfo
  #       libdrm
  #       libxshmfence
  #     ];

  #     sourceRoot = "metashape";

  #     installPhase = ''
  #       runHook preInstall

  #       mkdir -p $out

  #       cp -r . $out/

  #       chmod +x $out/metashape

  #       mkdir -p $out/bin
  #       ln -s $out/metashape $out/bin/metashape

  #       runHook postInstall
  #     '';

  #     meta = with lib; {
  #       description = "Professional photogrammetry software by Agisoft";
  #       homepage = "https://www.agisoft.com/";
  #       license = licenses.unfree;
  #       platforms = [ "x86_64-linux" ];
  #     };
  #   };

  metashape-pro-package =
    {
      stdenv,
      lib,
      fetchurl,
      autoPatchelfHook,
      makeWrapper,
      makeDesktopItem,
      unzip,
      glibc,
      gcc,
      glib,
      gmp,
      gomp,
      libGL,
      libGLU,
      curl,
      libkrb5,
      gtk2,
      fontconfig,
      libxkbcommon,
      libxcb,
      libx11,
      libxext,
      libsm,
      libice,
      libxcb-wm,
      libxcb-image,
      libxcb-keysyms,
      libxcb-render-util,
      libxi,
      libxrender,
      libxml2,
      libtinfo,
      libdrm,
      libxshmfence,
      python312,
      qt5,
      libxscrnsaver,
      libxcrypt-legacy,
      libclang,
      ocl-icd,
      vulkan-loader,
      zlib,
      ...
    }:
    let
      major = "2";
      minor = "3";
      patch = "1";
      name = "metashape";
      desktopItem = makeDesktopItem {
        inherit name;
        desktopName = name;
        exec = name;
      };
    in
    stdenv.mkDerivation {
      pname = "metashape-pro";
      version = "${major}.${minor}.${patch}";

      src = fetchurl {
        url = "https://download.agisoft.com/metashape-pro_${major}_${minor}_${patch}_amd64.tar.gz";
        sha256 = "sha256-LGpni0qqO5BRJSw7GycO6HmuWs9b9QpuFFOd1+QcHeA=";
      };

      nativeBuildInputs = [
        autoPatchelfHook
        unzip
        makeWrapper
      ];

      buildInputs = [
        glibc
        gcc.cc.lib
        glib
        gmp
        gomp
        libGL
        libGLU
        curl
        libkrb5
        gtk2
        fontconfig
        libxkbcommon
        libxcb
        libx11
        libxext
        libsm
        libice
        libxcb-wm
        libxcb-image
        libxcb-keysyms
        libxcb-render-util
        libxi
        libxrender
        libxml2
        libtinfo
        libdrm
        libxshmfence
        python312
        qt5.qtbase
        qt5.qtsvg
        qt5.qtremoteobjects
        qt5.qtx11extras
        qt5.qtxmlpatterns
        qt5.qttools
        qt5.qtmultimedia
        qt5.qtserialport
        qt5.qtnetworkauth
        libxscrnsaver
        libxcrypt-legacy
        libclang
        ocl-icd
        vulkan-loader
        zlib
      ];

      sourceRoot = "metashape-pro";

      dontWrapQtApps = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out

        cp -r . $out/

        chmod +x $out/metashape

        mkdir -p $out/bin
        ln -s $out/metashape $out/bin/metashape

        runHook postInstall
      '';

      autoPatchelfIgnoreMissingDeps = [ "libclang-8.so.1" ];

      postFixup = ''
        wrapProgram $out/metashape --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            ocl-icd
            vulkan-loader
          ]
        }:/run/opengl-driver/lib"
        ln -sf $out/metashape $out/bin/metashape
      '';

      postInstall = ''
        install -Dm444 ${desktopItem}/share/applications/*.desktop -t $out/share/applications
      '';

      passthru = {
        desktopItems = [ desktopItem ];
      };

      meta = with lib; {
        description = "Professional photogrammetry software by Agisoft";
        homepage = "https://www.agisoft.com/";
        license = licenses.unfree;
        platforms = [ "x86_64-linux" ];
      };
    };
}
