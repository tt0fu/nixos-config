{ inputs, pkgs, systemSettings, userSettings, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  environment.systemPackages = with pkgs; [
    glpaper
  ];
  home-manager.users.${userSettings.username} = { pkgs, ... }: {
    wayland.windowManager.hyprland.settings.exec-once = [
	  "glpaper ${systemSettings.monitor} ${./wallpaper.frag} --fork"
    ];
  };
}

