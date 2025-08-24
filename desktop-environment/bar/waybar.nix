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
            position = "top";
            output = systemSettings.monitor;
            height = 30;
            modules-left = [
              "hyprland/language"
              "custom/vpn"
              "tray"
              "privacy"
            ];
            modules-center = [
              "hyprland/workspaces"
            ];
            modules-right = [
              "wireplumber"
              "bluetooth"
              "battery"
              "network"
              "clock"
            ];

            "hyprland/language" = {
              format-en = "EN";
              format-ru = "RU";
              # keyboard-name = "at-translated-set-2-keyboard";
            };
            "custom/vpn" = {
              format = "󰖂 {}";
              exec = "(ip link show ${systemSettings.vpnName} >/dev/null 2>&1 && echo ) || echo ";
              on-click = "pkexec bash -c 'wg-quick down ${systemSettings.vpnName} || wg-quick up ${systemSettings.vpnName}'";
              return-type = "text";
              interval = 1;
            };
            privacy = {
              icon-spacing = 5;
              icon-size = 15;
            };
            tray = {
              icon-size = 15;
              spacing = 10;
              show-passive-items = true;
            };
            "hyprland/workspaces" = {
              format = "{icon} {windows} ";
              format-window-separator = " ";
              window-rewrite-default = "";
              window-rewrite = {
                "class<zen.*>" = "󰺕";
                "class<thunderbird>" = "";
                "class<code>" = "󰨞";
                "class<vlc>" = "󰕼";
                "class<org.telegram.desktop>" = "";
                "class<steam>" = "";
                "class<org.pulseaudio.pavucontrol>" = "";
                "class<org.pipewire.Helvum>" = "󱡫";
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
            "hyprland/window" = {
              format = "{title:.30}";
              icon = true;
              icon-size = 15;
            };
            wireplumber = {
              format = "{icon} {volume}%";
              format-muted = " {volume}%";
              on-click = "killall .helvum-wrapped || hyprctl dispatch exec '[float; size 500, 500; move 100%-w-5, 55]' helvum";
              max-volume = 150;
              scroll-step = 1;
              reverse-scrolling = true;
              format-icons = [
                ""
                ""
                ""
              ];
            };
            bluetooth = {
              format-disabled = "";
              format-no-controller = "";
              format-off = "󰂲";
              format-on = "󰂯";
              format-connected = "󰂱";
              format-connected-battery = "󰂱  {device_battery_percentage}%";
              on-click = "(killall .blueman-manage; killall .blueman-applet; killall .blueman-tray-w) || hyprctl dispatch exec '[float; size 500, 500; move 100%-w-5, 55]' blueman-manager";
              tooltip = true;
              tooltip-format-connected = "{device_alias}";
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
                on-charging = "notify-send -u normal 'Battery is now charging'";
                on-discharging = "notify-send -u normal 'Battery is no longer charging'";
                on-discharging-warning = "notify-send -u normal 'Battery is low'";
                on-discharging-critical = "notify-send -u critical 'Battery is very low'";
                on-charging-100 = "notify-send -u normal 'Battery is full'";
              };
            };
            network = {
              format-wifi = " {signalStrength}%";
              format-ethernet = "";
              format-disconnected = "󱞐";
              tooltip-format-wifi = " {essid}  {bandwidthDownBits}  {bandwidthUpBits}";
              tooltip-format-ethernet = " {ifname}  {bandwidthDownBits}  {bandwidthUpBits}";
              tooltip-format-disconnected = "Disconnected";
              on-click = "killall nmtui || hyprctl dispatch exec '[float; size 500, 500; move 100%-w-5, 55]' 'kitty --override font_size=10 --class nmtui nmtui'";
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
                      background: transparent;
                    	color: white;
                      margin: 0px;
                      padding: 0px;
                      box-shadow: none;
                   	  text-shadow: none;
                    }

                    window#waybar,
                    menu,
                    tooltip {
                      background: rgba(0, 0, 0, 0.01);
                    }

                    window#waybar,
                    menu,
                    tooltip,
                    button,
                    #privacy,
                    #workspaces,
                    #taskbar,
                    #window,
                    #tray,
                    #custom-vpn,
                    #language,
                    #wireplumber,
                    #bluetooth,
          					#battery,
                    #network,
                    #clock {
                      border: 1px solid white;
                      border-radius: 5px;
                    }

                    button,
                    #privacy,
                    #workspaces,
                    #taskbar,
                    #window,
                    #tray,
                    #custom-vpn,
                    #language,
                    #wireplumber,
                    #bluetooth,
          					#battery,
                    #network,
                    #clock {
                      margin: 2.5px;
                    }

                    .modules-left,
                    .modules-center,
                    .modules-right,
                    #workspaces,
                    #privacy {
                      padding: 2.5px;
                    }

                    menu,
                    tooltip,
                    button,
                    #privacy-item,
                    #window,
                    #tray,
                    #custom-vpn,
                    #language,
                    #wireplumber,
                    #bluetooth,
          					#battery,
                    #network,
                    #clock {
                      padding: 0px 5px;
                    }

                   	button {
                   	  border-color: #808080;
                   	}

                   	button.active {
                   	  border-color: white;
                   	}

                   	button.urgent {
                   	  border-color: #ff6060;
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
