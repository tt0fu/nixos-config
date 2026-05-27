{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.mission-center ];
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "SUPER + M"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"missioncenter\")")
          ];
        }
      ];
    };
}
