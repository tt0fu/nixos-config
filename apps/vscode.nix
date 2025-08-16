{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nixfmt-rfc-style ];
      programs.vscode.enable = true;
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, V, exec, code"
      ];
      programs.waybar.settings."hyprland/workspaces".window-rewrite."class<.*code.*>" = "󰨞";
    };
}
