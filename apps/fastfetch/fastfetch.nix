{
  inputs,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      programs.fastfetch = {
        enable = true;
        settings = {
          logo = {
            source = "${./logo.txt}";
            type = "file";
            color = {
              "1" = "#F3A2BB";
              "2" = "#EEAE7B";
              "3" = "#B5C77D";
              "4" = "#6DD3C0";
              "5" = "#80C6F8";
              "6" = "#C7AFF5";
            };
          };
          modules = [
            "title"
            "separator"
            "os"
            "host"
            "kernel"
            "uptime"
            "packages"
            "shell"
            "display"
            "de"
            "wm"
            "terminal"
            "cpu"
            "gpu"
            "memory"
            "disk"
            "break"
            "colors"
          ];
        };
      };
    };
}
