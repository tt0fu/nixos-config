{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
      };
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, E, exec, kitty yazi"
      ];
      programs.waybar.settings."hyprland/workspaces".window-rewrite."class<kitty> title<.*Yazi.*>" = "";
    };
}
