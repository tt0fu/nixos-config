{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.rocmPackages.rocm-smi ];
      programs.btop = {
        enable = true;
      };
      wayland.windowManager.hyprland.settings.bind = [
        "CTRL_SHIFT, ESCAPE, exec, kitty --class btop btop"
      ];
    };
}
