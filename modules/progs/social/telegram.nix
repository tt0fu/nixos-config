{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.telegram-desktop ];
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "SUPER + T"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"Telegram\")")
          ];
        }
      ];
    };
}
