{
  home =
    { pkgs, allModules, ... }:
    {
      home.packages = with pkgs; [
        vrc-get
        alcom
        (pkgs.callPackage allModules.progs."3d".vpm-cli.package { })
        yt-dlp
        ffmpeg
      ];
    };
  deps =
    modules: with modules; [
      progs."3d".unity
    ];
}
