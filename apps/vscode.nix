{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
  ];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      programs.vscode.enable = true;
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, V, exec, code"
      ];
      programs.waybar.settings."hyprland/workspaces".window-rewrite."class<.*code.*>" = "󰨞";
    };
}
