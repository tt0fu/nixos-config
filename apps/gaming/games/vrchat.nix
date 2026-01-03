{ userSettings, ... }:

{
  home-manager.users.${userSettings.username} =
    { ... }:
    {
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
