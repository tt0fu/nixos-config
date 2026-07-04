{
  os =
    { self, pkgs, ... }:
    {
      programs.steam.extraCompatPackages = [ (pkgs.callPackage self.package { }) ];
    };

  package =
    {
      stdenvNoCC,
      fetchzip,
    }:
    stdenvNoCC.mkDerivation rec {
      pname = "proton-rtsp-bin";
      version = "proton-rtsp-11.0-20260609-1";

      src = fetchzip {
        url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${version}/${version}.tar.gz";
        hash = "sha256-/YrUjR/Ynb0clNpXSaSlfpnqJ76ZfTYP9LR/WHHCMgk=";
      };

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      outputs = [
        "out"
        "steamcompattool"
      ];

      installPhase = ''
        runHook preInstall

        echo "${pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

        mkdir $steamcompattool
        ln -s $src/* $steamcompattool
        rm $steamcompattool/compatibilitytool.vdf
        cp $src/compatibilitytool.vdf $steamcompattool

        ls -la 
        runHook postInstall
      '';
    };
}
