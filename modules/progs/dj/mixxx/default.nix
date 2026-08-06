{
  home =
    { config, pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.mixxx
        ];
        file = {
          ".mixxx/skins/Deere-24" = {
            source = config.lib.file.mkOutOfStoreSymlink ./Deere-24;
          };
          ".mixxx/skins/LateNight-32" = {
            source = config.lib.file.mkOutOfStoreSymlink ./LateNight-32;
          };
        };
      };
    };
}
