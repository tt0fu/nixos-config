{
  home =
    { pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.mixxx
        ];
        file = {
          ".mixxx/skins/Deere-24" = {
            source = ./Deere-24;
            recursive = true;
          };
          ".mixxx/skins/LateNight-32" = {
            source = ./LateNight-32;
            recursive = true;
          };
        };
      };
    };
}
