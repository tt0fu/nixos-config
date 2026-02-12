{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.xournalpp ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<com.github.xournalpp.xournalpp>" =
        "";
    };
}
