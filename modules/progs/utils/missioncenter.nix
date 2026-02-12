{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.mission-center ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, M, exec, missioncenter"
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<io.missioncenter.MissionCenter>" =
        "";
      # programs.niri.settings.binds."Mod+M".action.spawn = [ "missioncenter" ];
    };
}
