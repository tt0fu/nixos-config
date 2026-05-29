{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.signal-desktop ];
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "SUPER + F"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"element-desktop\")")
          ];
        }
      ];
    };
}
