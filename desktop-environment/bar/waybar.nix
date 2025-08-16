{
  systemSettings,
  userSettings,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        libnotify
        helvum
      ];
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
              "hyprland/language"
              # "pulseaudio"
              "wireplumber"
              "battery"
              "network"
              "custom/vpn"
              "clock"
            ];

            "hyprland/workspaces" = {
              format = "{icon} {windows} ";
              format-window-separator = " ";
              window-rewrite-default = "";
              window-rewrite = {
                "class<zen.*>" = "󰺕";
                "class<code>" = "󰨞";
                "class<vlc>" = "󰕼";
                "class<org.telegram.desktop>" = "";
                "class<steam>" = "";
                "class<org.pulseaudio.pavucontrol>" = "";
                "class<vesktop>" = "";
                "class<org.mixxx.Mixxx>" = "";
                "class<dev.zed.Zed>" = "󰰶";
                "class<WinBox>" = "󱂇";
                "class<nvim>" = "";
                "class<yazi>" = "";
                "class<btop>" = "";
                "class<nmtui>" = "󰖟";
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
              format = "{title:.30}";
              icon = true;
              icon-size = 20;
            };
            tray = {
              icon-size = 20;
              spacing = 10;
              show-passive-items = true;
            };
            "hyprland/language" = {
              format-en = "EN";
              format-ru = "RU";
              keyboard-name = "at-translated-set-2-keyboard";
            };
            # pulseaudio = {
            #   format = " {volume}%";
            #   format-muted = " {volume}%";
            #   on-click = "pavucontrol";
            #   reverse-scrolling = true;
            # };
            wireplumber = {
              format = "{icon} {volume}%";
              format-muted = " {volume}%";
              on-click = "killall .helvum-wrapped || hyprctl dispatch exec '[float; size 500, 500; move 100%-w-5, 100%-w-50]' helvum";
              max-volume = 150;
              scroll-step = 1;
              reverse-scrolling = true;
              format-icons = [
                ""
                ""
                ""
              ];
            };
            battery = {
              interval = 10;
              states = {
                warning = 20;
                critical = 10;
              };
              format = "{icon} {capacity}%";
              format-discharging-warning = "<span color='orange'>{icon} {capacity}%</span>";
              format-discharging-critical = "<span color='red'>{icon} {capacity}%</span>";
              format-charging = " {capacity}%";
              format-charging-full = " {capacity}%";
              format-full = "{icon} {capacity}%";
              format-alt = "{icon} {capacity}%";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
              events = {
                on-charging = "notify-send -u normal 'Battery Is Now Charging'";
                on-discharging = "notify-send -u normal 'Battery Is No Longer Charging'";
                on-discharging-warning = "notify-send -u normal 'Low Battery'";
                on-discharging-critical = "notify-send -u critical 'Very Low Battery'";
                on-charging-100 = "notify-send -u normal 'Battery Full!'";
              };
            };
            network = {
              format-wifi = " {signalStrength}%";
              format-ethernet = "";
              format-disconnected = "󱞐";
              tooltip-format-wifi = " {essid}  {bandwidthDownBits}  {bandwidthUpBits}";
              tooltip-format-ethernet = " {ifname}  {bandwidthDownBits}  {bandwidthUpBits}";
              tooltip-format-disconnected = "Disconnected";
              on-click = "killall nmtui || hyprctl dispatch exec '[float; size 500, 500; move 100%-w-5, 100%-w-50]' 'kitty --override font_size=10 --class nmtui nmtui'";
            };
            "custom/vpn" = {
              format = "󰖂 {}";
              exec = "(ip link show ${systemSettings.vpnName} >/dev/null 2>&1 && echo ) || echo ";
              on-click = "pkexec bash -c 'wg-quick down ${systemSettings.vpnName} || wg-quick up ${systemSettings.vpnName}'";
              return-type = "text";
              interval = 1;
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
                    #wireplumber,
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
