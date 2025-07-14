{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, A, exec, pavucontrol"
      ];
    };
}
