{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        wl-clipboard
      ];
      services.cliphist = {
        enable = true;
        allowImages = true;
      };
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.shutdown"
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("cliphist wipe") end'')
          ];
        }
      ];
    };
}
