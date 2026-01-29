{
  home =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.element-desktop ];
      # wayland.windowManager.hyprland.settings.bind = [
      # "SUPER, T, exec, Telegram"
      # ];
      # programs.niri.settings.binds."Mod+T".action.spawn = [ "Telegram" ];
    };
}
