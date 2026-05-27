{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.qpwgraph ];
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("qpwgraph -m") end'')
          ];
        }
      ];
    };
}
