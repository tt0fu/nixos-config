{
  home =
    { config, pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.mixxx
        ];
        file = {
          ".mixxx/skins/LateNight32" = {
            source = config.lib.file.mkOutOfStoreSymlink ./LateNight32;
          };
        };
      };
    };
}
