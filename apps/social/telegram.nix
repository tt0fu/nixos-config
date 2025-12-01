{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.telegram-desktop ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, T, exec, Telegram"
      ];
      programs.niri.settings.binds."Mod+T".action.spawn = [ "Telegram" ];
    };
}
