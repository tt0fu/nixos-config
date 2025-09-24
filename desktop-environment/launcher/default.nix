{
  pkgs,
  userSettings,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    killall
  ];
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      programs.rofi = {
        enable = true;
        font = "JetBrainsMono Nerd Font Propo 15";
        modes = [
          "window"
          "drun"
          "run"
          "filebrowser"
        ];
        terminal = "${pkgs.kitty}/bin/kitty";
        theme = "${./rofi-theme.rasi}";
      };
      wayland.windowManager.hyprland.settings = {
        bindr = [
          "SUPER, SUPER_L, exec, killall rofi || rofi -show combi -show-icons -modes combi -combi-modes \"run,drun,filebrowser,recursivebrowser\""
        ];
        layerrule = [
          "blur, rofi"
          "ignorezero, rofi"
        ];
      };
    };
}
