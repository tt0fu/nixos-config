{
  home =
    { pkgs, allModules, ... }:
    {
      home.packages = [
        (pkgs.callPackage allModules.progs.audio.amplitude-soundboard.package { })
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<amplitude_soundboard>" =
        "";
    };
  package =
    {
      appimageTools,
      fetchurl,
      lib,
      ...
    }:
    appimageTools.wrapType2 rec {
      pname = "amplitude-soundboard";
      version = "2.12.0";

      src = fetchurl {
        url = "https://github.com/dan0v/AmplitudeSoundboard/releases/download/${version}/Amplitude_Soundboard-x86_64.AppImage";
        sha256 = "sha256-LJn6dFfEDltoSgc5hH+X5Pqr/uB7c1tDyD2mUKXMNwU=";
      };

      extraPkgs =
        pkgs:
        (with pkgs; [
          icu
          libglvnd
          freetype
          fontconfig
          glib
          krb5
          openssl
          zlib
          stdenv.cc.cc.lib
        ]);

      meta = with lib; {
        description = "A free and open source soundboard";
        homepage = "https://github.com/dan0v/AmplitudeSoundboard";
        license = licenses.gpl3;
        platforms = platforms.linux;
        mainProgram = "amplitude-soundboard";
      };
    };
}
