{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.blender ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<blender>" = "";
    };
}
