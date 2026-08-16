{
  os =
    { ... }:

    {
      programs.throne = {
        enable = true;
        tunMode.enable = true;
      };
      services.resolved.enable = true;
    };
  home =
    { pkgs, lib, ... }:
    {
      # wayland.windowManager.hyprland.settings.on = [
      #   {
      #     _args = [
      #       "hyprland.start"
      #       (lib.generators.mkLuaInline ''function() hl.exec_cmd("Throne") end'')
      #     ];
      #   }
      # ];
    };

}
