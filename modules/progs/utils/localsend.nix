{
  os =
    { ... }:
    {
      networking.firewall = {
        allowedTCPPorts = [ 53317 ];
        allowedUDPPorts = [ 53317 ];
      };
    };
  home =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.localsend ];
      # wayland.windowManager.hyprland.settings.bind = [
      #   {
      #     _args = [
      #       "SUPER + C"
      #       (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"kdeconnect-app\")")
      #     ];
      #   }
      # ];
    };
}
