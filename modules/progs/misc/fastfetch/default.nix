{
  home =
    { color, ... }:
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
                  name = toString (i + 1);
                  value = builtins.elemAt palette i;
                }) 6
              );
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
      programs.bash.bashrcExtra = "fastfetch";
    };
}
