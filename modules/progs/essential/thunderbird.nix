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
    };
}
