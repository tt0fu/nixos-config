{
  home =
    { ... }:
    {
      programs.obs-studio.enable = true;
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<com.obsproject.Studio>" =
        "";
    };
}
