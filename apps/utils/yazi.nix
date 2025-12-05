{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          opener = {
            play = [
              {
                run = "vlc \"$@\"";
                orphan = true;
                for = "unix";
              }
            ];
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
          ];
        };
      };
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, E, exec, kitty --class yazi yazi"
      ];
      # program1s.niri.settings.binds."Mod+E".action.spawn = [
      #   "kitty"
      #   "--class"
      #   "yazi"
      #   "yazi"
      # ];
    };
}
