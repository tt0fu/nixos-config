{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        godot
        godot-export-templates-bin
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<Godot>" = "";
    };
}
