{
  inputs,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
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
              # "wlr/taskbar"
              "hyprland/window"
            ];
            modules-right = [
              "tray"
              # "custom/vpn"
              "hyprland/language"
              "pulseaudio"
              "battery"
              "network"
              "clock"
            ];

            "hyprland/workspaces" = {
              format = "{icon} {windows} ";
              format-window-separator = " ";
              window-rewrite-default = "";
              window-rewrite = {
                "class<.*zen.*>" = "󰺕";
                "class<.*code.*>" = "󰨞";
                "class<.*vlc.*>" = "󰕼";
                "class<.*telegram.*>" = "";
                "class<.*steam.*>" = "";
                "class<.*pavucontrol.*>" = "";
                "class<.*discord.*>" = "";
                "class<kitty> title<.*nvim.*>" = "";
                "class<kitty> title<.*yazi.*>" = "";
                "class<kitty> title<.*btop.*>" = "";
                "class<kitty>" = "";
              };
            };
            # "wlr/taskbar" = {
            #   format = "{icon} {title:.10}";
            #   icon-size = 20;
            #   markup = true;
            #   tooltip-format = "{name}\n<small>{app_id}</small>";
            #   on-click = "minimize-raise";
            #   on-click-middle = "close";
            # };
            "hyprland/window" = {
              format = "{title:.20}";
              icon = true;
              icon-size = 20;
            };
            tray = {
              icon-size = 20;
              spacing = 10;
              show-passive-items = true;
            };
            # "custom/vpn" = {
            #   format = "󰖂 {}";
            #   exec = "${../vpn-status.sh}";
            #   on-click = "${../vpn-toggle.sh}";
            #   return-type = "json";
            #   interval = 5;
            # };
            "hyprland/language" = {
              format-en = "EN";
              format-ru = "RU";
            };
            pulseaudio = {
              format = " {volume}%";
              on-click = "pavucontrol";
            };
            battery.format = " {capacity}%";
            network = {
              format-wifi = " {signalStrength}%";
              format-ethernet = "";
              format-disconnected = "󱞐";
              tooltip-format-wifi = " {essid}  {bandwidthUpBits}  {bandwidthDownBits}";
              tooltip-format-ethernet = " {ifname}  {bandwidthUpBits}  {bandwidthDownBits}";
              tooltip-format-disconnected = "Disconnected";
              on-click = "kitty nmtui";
            };
            clock = {
              interval = 1;
              format = "{:%H:%M:%S}";
              tooltip = true;
              tooltip-format = "{:%Y %b %d %H:%M:%S}";
            };
          };
        };
        style = ''
                    * {
                      border: none;
                      font-family: JetBrainsMono Nerd Font Propo;
                    	font-size: 15px;
                    	color: white;
                    }
                    window#waybar,
                    #tray menu,
                    tooltip {
                      background: rgba(0, 0, 0, 0.01);
                    	border: 1px solid white;
                      border-radius: 5px;
                    	padding: 5px;
                    }
                    #workspaces,
                    #taskbar,
                    #window,
                    #tray,
                    #custom-vpn,
                    #language,
                    #pulseaudio,
          					#battery,
                    #network,
                    #clock {
                      border: 1px solid white;
                      border-radius: 5px;
                  	  background: rgba(0, 0, 0, 0);
                    	margin: 5px 2.5px;
                    	padding: 0px 5px;
                    }
                    #workspaces, 
                    #taskbar {
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
                    window#waybar.empty #window {
                      border-style: none;
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
