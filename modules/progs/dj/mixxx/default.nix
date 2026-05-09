{
  home =
    { pkgs, ... }:
    {
      home = {
        packages = [
          pkgs.mixxx
        ];
        file.".mixxx/skins/Deere-redo" = {
          source = ./Deere-redo;
          recursive = true;
        };
      };
    };
}
