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
      wayland.windowManager.hyprland = {
        settings = {
          bind = [
            {
              _args = [
                "SUPER + V"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"cliphist list | rofi -dmenu | cliphist decode | wl-copy\")")
              ];
            }
          ];
          on = [
            {
              _args = [
                "hyprland.start"
                (lib.generators.mkLuaInline ''function() hl.exec_cmd(\"cliphist wipe\") end'')
              ];
            }
          ];
        };
      };
      # programs.niri.settings.binds."Mod+V".action.spawn = [
      #   "sh"
      #   "-c"
      #   "cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      # ];
    };
}
