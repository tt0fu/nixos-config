{ inputs, pkgs, systemSettings, userSettings, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager.users.${userSettings.username} = { pkgs, ... }: {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
      };
      settings = {
        mainBar = {
          layer = "top";
	  position = "bottom";
	  output = systemSettings.monitor;
	  height = 30;
	  modules-left = [ 
	    "hyprland/workspaces" 
	  ];
	  modules-center = [ 
	    "wlr/taskbar" 
	  ];
	  modules-right = [ 
	    "tray" 
	    "hyprland/language" 
	    "pulseaudio" 
	    "clock" 
	  ];
	  "wlr/taskbar" = {
	    format = "{icon} {title:.20}";
	    icon-size = 20;
	    markup = true;
	    tooltip-format = "{name}\n<small>{app_id}</small>";
	    on-click = "minimize-raise";
	    on-click-middle = "close";
	  };
	  tray = {
	    icon-size = 20;
	    spacing = 10;
	    show-passive-items = true;
	  };
	  "hyprland/language" = {
	    format-en = "EN";
	    format-ru = "RU";
	  };
          clock = {
	    interval = 1;
            format = "{:%a, %d %b %H:%M:%S}";
	  };
	  pulseaudio.format = " {volume}%";
	};
      };
      style = ''
        * {
          border: none;
          font-family: JetBrainsMono Nerd Font;
	  font-size: 15px;
	  color: white;
        }
	window#waybar,
	#tray menu {
          background: rgba(0, 0, 0, 0.01);
	  border: 1px solid white;
          border-radius: 5px;
	  padding: 5px;
	}
	#workspaces,
	#taskbar,
	#tray,
	#language,
	#pulseaudio,
	#clock {
	  border: 1px solid white;
          border-radius: 5px;
	  background: rgba(0, 0, 0, 0);
	  margin: 5px 2.5px;
	  padding: 0px 5px;
	}
	#workspaces, #taskbar {
	  padding: 2.5px;
	}
	#workspaces {
	  margin-left: 5px;
	}
	#clock {
	  margin-right: 5px;
	}	
	button {
	  border: 1px solid #777777;
	  padding: 0px 5px;
	  margin: 2.5px;
	}
	button.active {
	  border-style: solid;
	  border-color: white;
	}
	#workspaces button.urgent {
	  border-style: solid;
	  border-color: #ff6666;
	}	
	button:hover {
	  box-shadow: inherit;
	  text-shadow: inherit;
	  background: inherit;
	  border: 1px solid white;
        }
	'';
    };
    wayland.windowManager.hyprland.settings.layerrule = [
      "blur, waybar"
      "ignorezero, waybar"
      "blurpopups, waybar"
    ];
  };
}

