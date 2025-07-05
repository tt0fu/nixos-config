{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  environment.systemPackages = with pkgs; [
    helvum
  ];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, A, exec, helvum"
      ];
    };
}
