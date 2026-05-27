{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.nautilus ];
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "SUPER + E"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"nautilus\")")
          ];
        }
      ];
    };
}
