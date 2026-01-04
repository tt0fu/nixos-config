{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        libnotify
        helvum
        nmgui
        qt6.qt5compat
        kdePackages.full
      ];
      programs.quickshell = {
        # enable = true;
        systemd.enable = true;
        configs.default = "${./quickshell-config}";
      };
      wayland.windowManager.hyprland.settings = {
        layerrule = [
          "blur on, match:namespace quickshell"
          "ignore_alpha 0, match:namespace quickshell"
          "blur_popups on, match:namespace quickshell"
        ];
        # exec-once = [
        #   "qs"
        # ];
      };
    };
}
