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
        keymap = {
          mgr.prepend_keymap = [
            {
              on = "T";
              run = "shell --orphan --confirm kitty";
              desc = "Open terminal at current dir";
            }
          ];
        };
      };
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, E, exec, kitty --class yazi yazi"
      ];
    };
}
