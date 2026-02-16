{
  home =
    { pkgs, allModules, ... }:
    {
      home.packages = [
        (pkgs.callPackage allModules.progs."3d".metashape.package { })
      ];
    };
  package =
    {
      stdenv,
      lib,
      fetchurl,
      autoPatchelfHook,
      unzip,
      glibc,
      gcc,
      glib,
      gmp,
      gomp,
      libGL,
      libGLU,
      curl,
      zlib,
      libkrb5,
      gtk2,
      fontconfig,
      freetype,
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
      ncurses5,
      ...
    }:

    stdenv.mkDerivation {
      pname = "metashape";
      version = "2.3.0";

      src = fetchurl {
        url = "https://download.agisoft.com/metashape_2_3_0_amd64.tar.gz";
        sha256 = "sha256-vuyNevBlFHCmVk8V6JFO+ZHTQyTH4NePXZmJAqzgb8Y=";
      };

      nativeBuildInputs = [
        autoPatchelfHook
        unzip
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
        zlib
        libkrb5
        gtk2
        fontconfig
        freetype
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
        ncurses5
      ];

      sourceRoot = "metashape";

      installPhase = ''
        runHook preInstall

        mkdir -p $out

        cp -r . $out/

        chmod +x $out/metashape

        mkdir -p $out/bin
        ln -s $out/metashape $out/bin/metashape

        patchelf --set-rpath "$out/lib:${stdenv.cc.cc.lib}/lib" $out/metashape

        runHook postInstall
      '';
      
      meta = with lib; {
        description = "Professional photogrammetry software by Agisoft";
        homepage = "https://www.agisoft.com/";
        license = licenses.unfree;
        platforms = [ "x86_64-linux" ];
      };
    };
}
