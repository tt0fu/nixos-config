{ inputs, pkgs, systemSettings, userSettings, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager.users.${userSettings.username} = { pkgs, ... }: { 
    services.dunst = {
      enable = true;
      settings = {
        global = {
	  offset = "(10, 10)";
	  origin = "bottom-right";
	  frame_width = 1;
	  frame_color = "#ffffff";
	  background = "#00000088";
	  font = "JetBrainsMono Nerd Font";
	  corner_radius = 5;
	};
      };
    };
    wayland.windowManager.hyprland.settings.exec-once = [ 
      "dunst"
    ];
  };
}

