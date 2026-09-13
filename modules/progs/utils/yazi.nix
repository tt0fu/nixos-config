{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.zip ];
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          opener = {
            open = [
              {
                run = "xdg-open \"$@\"";
                desc = "Open";
              }
            ];
          };
        };
        keymap = {
          mgr.prepend_keymap = [
            {
              on = "t";
              run = "shell --orphan --confirm kitty";
              desc = "Open terminal at current dir";
            }
            {
              on = [
                "g"
                "m"
              ];
              run = "cd /media";
              desc = "Go /media";
            }
            {
              on = [
                "g"
                "l"
              ];
              run = "cd ~/.local";
              desc = "Go /media";
            }
          ];
        };
      };
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "SUPER + SHIFT + E"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"kitty --class yazi yazi\")")
          ];
        }
      ];
    };
}
