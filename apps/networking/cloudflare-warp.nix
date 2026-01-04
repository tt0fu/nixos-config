{ userSettings, ... }:

{
  services.cloudflare-warp = {
    enable = true;
    openFirewall = true;
  };
  # home-manager.users.${userSettings.username} =
  #   { pkgs, ... }:
  #   {
  #     home.packages = [ pkgs.qpwgraph ];
  #     wayland.windowManager.hyprland.settings.exec-once = [
  #       "Throne"
  #     ];
  #   };

}
