{
  os =
    { ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    };
  home =
    { pkgs, lib, ... }:
    {
      # home.packages = [ pkgs.steam ];
      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("setpriv --ambient-caps -all steam -silent") end'')
          ];
        }
      ];
    };
}
