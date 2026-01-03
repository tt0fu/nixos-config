{
  inputs,
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = [ inputs.sonusmix.defaultPackage.${pkgs.stdenv.hostPlatform.system} ];
      wayland.windowManager.hyprland.settings.exec-once = [
        "sonusmix"
      ];
    };
}
