{
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.hyprshot ];
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          bind = [
            "SUPER, S, exec, hyprshot -z -o ~/Images/screenshots -m region"
          ];
        };
      };
    };
}
