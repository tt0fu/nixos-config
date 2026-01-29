{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.vrcx ];
      wayland.windowManager.hyprland.settings.exec-once = [
        "vrcx --startup"
      ];
      xdg.desktopEntries = {
        vrchat = {
          name = "VRChat";
          comment = "Play this game on Steam";
          genericName = "Social VR game";
          exec = "steam steam://rungameid/438100";
          icon = "steam_icon_438100";
          terminal = false;
          type = "Application";
          categories = [
            "Game"
          ];
        };
      };
    };
}
