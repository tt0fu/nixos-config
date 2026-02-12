{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.winbox4 ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<WinBox>" = "󱂇";
    };
}
