{
  userSettings,
  color,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      programs.fastfetch = {
        enable = true;
        settings = {
          logo = {
            source = "${./logo.txt}";
            type = "file";
            color =
              let
                palette = map color.toHex (color.palette 6 0.8 0.1);
              in
              builtins.listToAttrs (
                builtins.genList (i: {
                  name = builtins.toString (i + 1);
                  value = builtins.elemAt palette i;
                }) 6
              );
            # {
            #   "1" = "#F3A2BB";
            #   "2" = "#EEAE7B";
            #   "3" = "#B5C77D";
            #   "4" = "#6DD3C0";
            #   "5" = "#80C6F8";
            #   "6" = "#C7AFF5";
            # };
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
