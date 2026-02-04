{
  home =
    { pkgs, style, ... }:
    {
      home.packages = with pkgs; [
        libnotify
        nmgui
      ];
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings =
          let
            hyprToggle =
              { command, class }:
              "hyprctl dispatch closewindow class:${class} | grep -q ok || \
              (hyprctl dispatch exec '[float; size 750, 750; move 100%-w-5, 65] ${command}' && \
              sleep 1.0 && hyprctl dispatch movewindow u && hyprctl dispatch movewindow r)";
          in
          {
            mainBar = {
              layer = "top";
              position = "top";
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
                "wireplumber#source"
                "bluetooth"
                "battery"
                "network"
                "clock"
              ];

              "hyprland/language" = {
                format-en = "EN";
                format-ru = "RU";
                on-click = "hyprctl switchxkblayout main next";
              };
              "custom/vpn" = {
                format = "󰖂 {}";
                exec = "(ip link show config >/dev/null 2>&1 && echo ) || echo ";
                on-click = "pkexec bash -c 'wg-quick down config || wg-quick up config'";
                return-type = "text";
                interval = 1;
              };
              privacy = {
                icon-spacing = 5;
                icon-size = style.font.size;
              };
              tray = {
                icon-size = style.font.size;
                spacing = 10;
                show-passive-items = true;
              };
              "hyprland/workspaces" = {
                format = "{icon} {windows}";
                format-window-separator = " ";
                window-rewrite-default = "";
                window-rewrite = {
                  "class<zen.*>" = "󰺕";
                  "class<thunderbird>" = "";
                  "class<code>" = "󰨞";
                  "class<vlc>" = "󰕼";
                  "class<org.telegram.desktop>" = "";
                  "class<steam>" = "";
                  "class<.blueman-manager-wrapped>" = "󰂯";
                  "class<org.pulseaudio.pavucontrol>" = "";
                  "class<org.pulsemeeter.pulsemeeter>" = "󱡫";
                  "class<org.pipewire.Helvum>" = "󱡫";
                  "class<org.rncbc.qpwgraph>" = "󱡫";
                  "class<discord>" = "";
                  "class<org.mixxx.Mixxx>" = "";
                  "class<dev.zed.Zed>" = "󰰶";
                  "class<com.obsproject.Studio>" = "";
                  "class<WinBox>" = "󱂇";
                  "class<nvim>" = "";
                  "class<yazi>" = "";
                  "class<org.gnome.Nautilus>" = "";
                  "class<btop>" = "";
                  "class<io.missioncenter.MissionCenter>" = "";
                  "class<com.network.manager>" = "󰖟";
                  "class<kitty>" = "";
                  "class<org.kde.kdeconnect.app>" = "";
                  "class<Unity>" = "";
                  "class<unityhub>" = "";
                  "class<Godot>" = "";
                  "class<org.ttofu.lava>" = "󰥛";
                  "class<amplitude_soundboard>" = "";
                  "class<com.github.xournalpp.xournalpp>" = "";
                  "class<winboat>" = "";
                  "class<xfreerdp>" = "";
                };
              };
              "hyprland/window" = {
                format = "{title:.30}";
                icon = true;
                icon-size = style.font.size;
              };
              wireplumber = {
                format = "{icon} {volume}%";
                format-muted = "";
                on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                max-volume = 150;
                scroll-step = 5;
                reverse-scrolling = true;
                format-icons = [
                  ""
                  ""
                  ""
                ];
              };
              "wireplumber#source" = {
                node-type = "Audio/Source";
                format = "󰍬 {volume}%";
                format-muted = "󰍭";
                on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                max-volume = 150;
                scroll-step = 5;
              };
              bluetooth = {
                format-disabled = "";
                format-no-controller = "";
                format-off = "󰂲";
                format-on = "󰂯";
                format-connected = "󰂱";
                format-connected-battery = "󰂱  {device_battery_percentage}%";
                on-click = hyprToggle {
                  class = ".blueman-manager-wrapped";
                  command = "blueman-manager";
                };
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
                on-click = hyprToggle {
                  class = "com.network.manager";
                  command = "nmgui";
                };
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
                      font-family: ${toString style.font.name};
                    	font-size: ${toString style.font.size}px;
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
                    #custom-vpn,
                    #tray,
                    #language,
                    #wireplumber,
                    #bluetooth,
          					#battery,
                    #network,
                    #clock {
                      border: ${toString style.border.thickness}px solid white;
                      border-radius: ${toString style.border.radius}px;
                    }

                    button,
                    #privacy,
                    #workspaces,
                    #taskbar,
                    #window,
                    #custom-vpn,
                    #tray,
                    #language,
                    #wireplumber,
                    #bluetooth,
          					#battery,
                    #network,
                    #clock {
                      margin: ${toString (style.spacing / 2.0)}px;
                    }

                    .modules-left,
                    .modules-center,
                    .modules-right,
                    #workspaces,
                    #privacy {
                      padding: ${toString (style.spacing / 2.0)}px;
                    }

                    menu,
                    tooltip,
                    button,
                    #privacy-item,
                    #window,
                    #custom-vpn,
                    #tray,
                    #language,
                    #wireplumber,
                    #bluetooth,
          					#battery,
                    #network,
                    #clock {
                      padding: ${toString (style.spacing / 2.0)}px ${toString (style.spacing)}px;
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
                   	  border: ${toString style.border.thickness}px solid white;
                    }

                    window#waybar.empty #window {
                      border-style: none;
                    }
        '';
      };
      wayland.windowManager.hyprland.settings = {
        layerrule = [
          "blur on, match:namespace waybar"
          "ignore_alpha 0, match:namespace waybar"
          "blur_popups on, match:namespace waybar"
        ];
      };
    };
}
