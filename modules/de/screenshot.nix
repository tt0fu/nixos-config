{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        grim
        slurp
        hyprpicker
        wl-clipboard
        jq
        libnotify
        grimblast
      ];
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "Print"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grimblast -nf copysave area \"$HOME/Pictures/Screenshots/$(date +\"%Y-%m-%d_%H-%M-%S\").png\"")'')
          ];
        }
        {
          _args = [
            "SHIFT + Print"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grimblast -nf copysave screen \"$HOME/Pictures/Screenshots/$(date +\"%Y-%m-%d_%H-%M-%S\").png\"")'')
          ];
        }
        {
          _args = [
            "SUPER + S"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grimblast -nf copysave area \"$HOME/Pictures/Screenshots/$(date +\"%Y-%m-%d_%H-%M-%S\").png\"")'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + S"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grimblast -nf copysave screen \"$HOME/Pictures/Screenshots/$(date +\"%Y-%m-%d_%H-%M-%S\").png\"")'')
          ];
        }
      ];
    };
}
