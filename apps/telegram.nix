{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    telegram-desktop
  ];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, T, exec, Telegram"
      ];
    };
}
