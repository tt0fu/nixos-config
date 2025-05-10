{ inputs, pkgs, userSettings, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  environment.systemPackages = with pkgs; [
    legcord
  ];
  home-manager.users.${userSettings.username} = { pkgs, ... }: {
    wayland.windowManager.hyprland.settings.bind = [
      "$mod, D, exec, legcord"
    ];
  };
}

