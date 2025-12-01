{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.hyprshot ];
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, S, exec, hyprshot -z -o ~/Images/screenshots -m region"
      ];
      programs.niri.settings.binds."Mod+S".action.spawn = [
        "hyprshot"
        "-z"
        "-o"
        "~/Images/screenshots"
        "-m"
        "region"
      ];
    };
}
