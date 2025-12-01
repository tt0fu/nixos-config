{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.wl-clipboard
      ];
      services.cliphist = {
        enable = true;
        allowImages = true;
      };
      wayland.windowManager.hyprland.settings = {
        bind = [ "SUPER, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy" ];
      };
      programs.niri.settings.binds."Mod+V".action.spawn = [
        "sh"
        "-c"
        "cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      ];
    };
}
