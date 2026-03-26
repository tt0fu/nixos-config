{
  home =
    {
      self,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        vrc-get
        alcom
        (pkgs.callPackage self.vpm-cli { })
        yt-dlp
        ffmpeg
      ];
    };
  deps =
    modules: with modules; [
      progs."3d".unity
    ];
  vpm-cli =
    {
      buildDotnetGlobalTool,
      lib,
    }:

    buildDotnetGlobalTool {
      pname = "vrchat-vpm-cli";
      version = "0.1.28";

      nugetName = "VRChat.VPM.CLI";
      nugetSha256 = "sha256-Pz8KBpjmpzx+6gD4nqGVBEp5z4UX6hFqZHGy8hJCD4k=";

      executables = [ "vpm" ];

      meta = with lib; {
        description = "VRChat Package Manager CLI";
        homepage = "https://vcc.docs.vrchat.com/vpm/cli/";
        license = licenses.unfree;
        platforms = platforms.linux;
      };
    };
}
