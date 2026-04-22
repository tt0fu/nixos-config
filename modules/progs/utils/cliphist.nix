{
  home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wl-clipboard
      ];
      services.cliphist = {
        enable = true;
        allowImages = true;
      };
      wayland.windowManager.hyprland.settings.exec-once = [ "cliphist wipe" ];
    };
}
