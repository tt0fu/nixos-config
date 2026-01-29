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
  xorg,
  ...
}:

stdenv.mkDerivation {
  pname = "metashape";
  version = "2.2.2";

  src = fetchurl {
    url = "https://download.agisoft.com/metashape_2_2_2_amd64.tar.gz";
    sha256 = "sha256-wC6QgvNlC4INjfsKTblK8VYjix1Lk8BCVPdh+x/kzy0=";
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
    xorg.libxcb
    xorg.libX11
    xorg.libXext
    xorg.libSM
    xorg.libICE
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.libXi
    xorg.libXrender
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
}
