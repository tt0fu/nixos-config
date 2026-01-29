{
  os =
    { ... }:

    {
      programs.throne = {
        enable = true;
        tunMode.enable = true;
      };
      services.resolved.enable = true;
    };
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.qpwgraph ];
      wayland.windowManager.hyprland.settings.exec-once = [
        "Throne"
      ];
    };

}
