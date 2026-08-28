{
  os =
    { ... }:

    {
      programs.amnezia-vpn = {
        enable = true;
      };
    };
  home =
    { pkgs, lib, ... }:
    {
      # wayland.windowManager.hyprland.settings.on = [
      #   {
      #     _args = [
      #       "hyprland.start"
      #       (lib.generators.mkLuaInline ''function() hl.exec_cmd("AmneziaVPN -a") end'')
      #     ];
      #   }
      # ];
    };

}
