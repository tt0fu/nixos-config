{
  home =
    { userSettings, ... }:
    {
      programs.thunderbird = {
        enable = true;
        profiles.${userSettings.username} = {
          isDefault = true;
        };
      };
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, X, exec, thunderbird"
      ];
            programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<thunderbird>" = "";
      # programs.niri.settings.binds."Mod+X".action.spawn = [ "thunderbird" ];
    };
}
