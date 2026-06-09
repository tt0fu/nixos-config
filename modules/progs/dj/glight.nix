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
      stdenv,
      lib,
      fetchFromGitHub,
      cmake,
      pkg-config,
      gtkmm3,
      aubio,
      flac,
      alsa-lib,
      ola,
      protobuf,
      boost,
    }:

    stdenv.mkDerivation rec {
      pname = "glight";
      version = "0.9.3";

      src = fetchFromGitHub {
        owner = "aroffringa";
        repo = "glight";
        rev = "v${version}";
        sha256 = "sha256-b5GO692NJ5AIRhA4v168DDYoFEVwNETrYyPBv+zuZFY=";
      };

      nativeBuildInputs = [
        cmake
        pkg-config
      ];

      buildInputs = [
        gtkmm3
        aubio
        flac
        alsa-lib
        ola
        protobuf
        boost
      ];

      meta = {
        description = "Live stage lighting control software using OLA and GTK";
        homepage = "https://glight.readthedocs.io/";
        license = lib.licenses.gpl3Plus;
        maintainers = [ ];
        platforms = lib.platforms.linux;
      };
    };
}
