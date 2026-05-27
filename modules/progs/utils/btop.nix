{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.btop ];
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "SUPER + SHIFT + M"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"kitty --class btop btop\")")
          ];
        }
      ];
    };
}
