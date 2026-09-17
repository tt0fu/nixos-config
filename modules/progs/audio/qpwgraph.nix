{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.qpwgraph ];
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.dispatch(hl.dsp.exec_cmd("qpwgraph -m")) end'')
          ];
        }
      ];
    };
}
