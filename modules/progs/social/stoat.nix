{
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [
        (pkgs.stoat-desktop.override {
          electron_38 = pkgs.electron;
        })
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
