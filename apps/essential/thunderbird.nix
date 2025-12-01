{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { ... }:
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
      programs.niri.settings.binds."Mod+X".action.spawn = [ "thunderbird" ];
    };
}
