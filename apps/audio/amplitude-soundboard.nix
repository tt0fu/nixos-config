{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.appimageTools.wrapType2 rec {
          pname = "amplitude-soundboard";
          version = "2.11.0";

          src = pkgs.fetchurl {
            url = "https://github.com/dan0v/AmplitudeSoundboard/releases/download/${version}/Amplitude_Soundboard-x86_64.AppImage";
            sha256 = "sha256-va6QIDI9pXgYvjAQaBHm2kfrUeIEm1x+IudauqXgph0=";
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

          meta = with pkgs.lib; {
            description = "A sleek, flexible, free and open source soundboard";
            homepage = "https://github.com/dan0v/AmplitudeSoundboard";
            license = licenses.gpl3;
            platforms = platforms.linux;
            mainProgram = "amplitude-soundboard";
          };
        })
      ];
    };
}
