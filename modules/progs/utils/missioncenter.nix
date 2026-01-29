{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.mission-center ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, M, exec, missioncenter"
      ];
      # programs.niri.settings.binds."Mod+M".action.spawn = [ "missioncenter" ];
    };
}
