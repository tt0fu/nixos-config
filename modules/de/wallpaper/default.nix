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
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("shaderbg \"*\" ${./fbm.frag}") end'')
          ];
        }
      ];
    };
}
