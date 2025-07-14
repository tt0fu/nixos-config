{
  inputs,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
	environment.systemPackages = with pkgs; [
		killall
	];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      programs.wofi = {
        enable = true;
        settings = {
          show = "run";
          allow_images = true;
          allow_markup = true;
          location = "bottom";
          yoffset = -5;
          width = 400;
        };
        style = ''
                  * {
          	  font-family: JetBrainsMono Nerd Font;
          	  font-size: 15px;
          	  color: white;
          	  border: 1px none white;
          	}
          	#window {
          	  background: rgba(0, 0, 0, 0);
          	}
          	#outer-box,
          	#input,
          	#entry {
          	  border-radius: 5px;
          	}
          	#outer-box,
          	#input,
          	#entry:selected {
          	  border: 1px solid white;
          	}
          	#outer-box {
          	  background: rgba(0, 0, 0, 0.01);
          	}
          	#input,
          	#entry {
          	  background: rgba(0, 0, 0, 0);
          	}
          	#input {
          	  margin: 5px;
          	}
          	#entry {
          	  margin: 2.5px;
          	}
          	
          	#inner-box {
          	  padding: 2.5px;
          	}
          	'';
      };
      wayland.windowManager.hyprland.settings = {
        bindr = [ "SUPER, SUPER_L, exec, killall .wofi-wrapped || wofi" ];
        layerrule = [
          "blur, wofi"
          "ignorezero, wofi"
        ];
      };
    };
}
