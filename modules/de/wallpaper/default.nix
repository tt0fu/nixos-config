{
  home =
    {
      pkgs,
      lib,
      ...
    }:

    {
      home.packages = with pkgs; [
        shaderbg
      ];
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.dispatch(hl.dsp.exec_cmd("shaderbg \"*\" ${./fbm.frag}")) end'')
          ];
        }
      ];
    };
}
