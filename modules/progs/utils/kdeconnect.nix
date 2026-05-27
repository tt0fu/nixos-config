{
  os =
    { ... }:
    {
      networking.firewall = rec {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
    };
  home =
    { lib, ... }:
    {
      services.kdeconnect.enable = true;
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "SUPER + C"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"kdeconnect-app\")")
          ];
        }
      ];
    };
}
