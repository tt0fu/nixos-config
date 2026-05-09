{
  home =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.symlinkJoin {
          name = "mixxx-custom-skin";
          paths = [
            pkgs.mixxx
            (pkgs.runCommand "deere-redo-skin" { } ''
              mkdir -p $out/share/mixxx/skins
              cp -r ${./Deere-redo} $out/share/mixxx/skins/Deere-redo
            '')
          ];
        })
      ];
    };
}
