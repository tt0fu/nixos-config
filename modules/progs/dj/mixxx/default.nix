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
            source = ./LateNight32;
          };
        };
      };
    };
}
