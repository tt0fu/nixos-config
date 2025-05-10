{ inputs, pkgs, systemSettings, userSettings, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  security.pam.services.hyprlock = {};
  home-manager.users.${userSettings.username} = { pkgs, ... }: {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
	  disable_loading_bar = true;
	  hide_cursor = true;
	  no_fade_in = false;
        };
        background = [
          {
	    path = "screenshot";
	    blur_passes = 3;
	    blur_size = 10;
	    noise = 0.0;
	    contrast = 1.0;
	    brightness = 0.7;
	    vibrancy = 0.0;
	    vibrancy_darkness = 0.0;
	  }
        ];
        input-field = [
          {
	    size = "200, 50";
	    fade_on_empty = false;
	    font_color = "rgb(255, 255, 255)";
	    font_family = "JetBrainsMono Nerd Font";
	    inner_color = "rgba(0, 0, 0, 0)";
	    outer_color = "rgb(255, 255, 255)";
	    outline_thickness = 1;
	    placeholder_text = "<i>Password...</i>";
	    check_color = "rgb(255, 255, 100)";
	    fail_color = "rgb(255, 100, 100)";
	    fail_text = "<i>Incorrect password</i>";
          }  
        ];
	label = [
	  {
	    position = "0, 100";
	    text = "cmd[update:1000] echo \"<b>$(date '+%H:%M:%S')</b>\"";
	    color = "rgb(255, 255, 255)";
	    font_size = 50;
	    font_family = "JetBrainsMono Nerd Font";
	  }
	];
      };
    };
    wayland.windowManager.hyprland.settings = {
      bind = [ "$mod, L, exec, hyprlock --immediate" ];
    };
  };
}

