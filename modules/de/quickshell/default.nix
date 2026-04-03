{
  home =
    { inputs, pkgs, ... }:
    {
      programs.quickshell = {
        enable = true;
        package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
        activeConfig = "bar";
        configs = {
          bar = ./bar;
        };
      };
      wayland.windowManager.hyprland.settings = {
        layerrule = [
          "blur on, match:namespace quickshell"
          "ignore_alpha 0, match:namespace quickshell"
          "blur_popups on, match:namespace quickshell"
        ];
        exec-once = [ "qs -c bar" ];
      };
    };
  deps =
    modules: with modules; [
      progs.utils.nmgui
      progs.utils.libnotify
    ];
}
