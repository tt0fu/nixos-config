{
  home =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.stoat-desktop
      ];
      # wayland.windowManager.hyprland.settings.bind = [
      #   {
      #     _args = [
      #       "SUPER + F"
      #       (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"stoat-desktop\")")
      #     ];
      #   }
      # ];
    };
}
