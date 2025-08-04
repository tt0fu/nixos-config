{
  pkgs,
  userSettings,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    hyprshot
  ];
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          bind = [
            "SUPER, S, exec, hyprshot -o ~/Images/screenshots -m region"
          ];
        };
      };
    };
}
