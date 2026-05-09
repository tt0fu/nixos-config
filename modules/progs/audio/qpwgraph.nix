{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.qpwgraph ];
      wayland.windowManager.hyprland.settings.exec-once = [
        "qpwgraph -m"
      ];
    };
}
