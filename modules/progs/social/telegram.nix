{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.telegram-desktop ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, T, exec, Telegram"
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<org.telegram.desktop>" =
        "";
    };
}
