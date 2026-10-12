{
  inputs = {
    rbxport = {
      url = "github:tt0fu/rbxport/feat-nix-packaging";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  home =
    {
      # self,
      inputs,
      pkgs,
      ...
    }:
    {
      home.packages = [
        inputs.rbxport.packages.${pkgs.stdenv.hostPlatform.system}.default
        # (pkgs.callPackage self.package { })
      ];
    };
  package =
    {
      stdenv,
      lib,
      fetchurl,
      dpkg,
      autoPatchelfHook,
      makeWrapper,
      wrapGAppsHook3,
      alsa-lib,
      cairo,
      dbus,
      gdk-pixbuf,
      glib,
      gtk3,
      gsettings-desktop-schemas,
      libsoup_3,
      pango,
      webkitgtk_4_1,
      ...
    }:

    stdenv.mkDerivation rec {
      pname = "rbxport";
      version = "1.0.0-rc.14";

      src = fetchurl {
        url = "https://download.rbxport.com/${pname}-${version}-linux-x86_64.deb";
        hash = "sha256-uISeDHQiMtwhUBbtU1f8mtLufkb+C/AU1aw4iqnwcwM=";
      };

      nativeBuildInputs = [
        dpkg
        autoPatchelfHook
        wrapGAppsHook3
        makeWrapper
      ];

      buildInputs = [
        alsa-lib
        cairo
        dbus
        gdk-pixbuf
        glib
        gtk3
        gsettings-desktop-schemas
        libsoup_3
        pango
        webkitgtk_4_1
        stdenv.cc.cc.lib
      ];

      dontBuild = true;

      unpackPhase = ''
        runHook preUnpack

        dpkg-deb -x $src .

        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r usr/* $out/

        runHook postInstall
      '';

      meta = {
        description = "A faster, lighter library manager for DJs who play from USB sticks";
        homepage = "https://rbxport.com/";
        platforms = lib.platforms.linux;
        mainProgram = "rbxport";
      };
    };
}
