{ inputs, pkgs, userSettings, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  environment.systemPackages = with pkgs; [
    telegram-desktop
  ];
  home-manager.users.${userSettings.username} = { pkgs, ... }: {
    wayland.windowManager.hyprland.settings.bind = [
      "SUPER, T, exec, telegram-desktop"
    ];
  };
}

