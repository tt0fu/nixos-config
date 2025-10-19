{
  systemSettings,
  userSettings,
  style,
  ...
}:

{
  hardware.graphics.enable = true;
  programs.dconf.enable = true;
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        glib
        hyprshot
        hyprpolkitagent
        pulseaudio
        brightnessctl
      ];
      xdg = {
        mimeApps.enable = true;
        portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-wlr
            pkgs.xdg-desktop-portal-xapp
          ];
          config.common.default = "*";
        };
      };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          input = [
            {
              kb_layout = "us, ru";
              kb_options = "grp:alt_shift_toggle";
              touchpad = {
                natural_scroll = true;
              };
            }
          ];
          monitor = [
            "${systemSettings.monitor.name}, ${systemSettings.monitor.settings}"
          ];
          bind = [
            "SUPER, ESCAPE, killactive"
            "SUPER, SPACE, togglefloating"
            "SUPER, TAB, cyclenext"
            "SUPER, TAB, bringactivetotop"
            "SUPER SHIFT, TAB, cyclenext, prev"
            "SUPER SHIFT, TAB, bringactivetotop"
            "SUPER, Up, movefocus, u"
            "SUPER, Down, movefocus, d"
            "SUPER, Left, movefocus, l"
            "SUPER, Right, movefocus, r"
            "SUPER SHIFT, Up, movewindow, u"
            "SUPER SHIFT, Down, movewindow, d"
            "SUPER SHIFT, Left, movewindow, l"
            "SUPER SHIFT, Right, movewindow, r"
            "SUPER, RETURN, fullscreen"
            "SUPER CTRL SHIFT, S, exec, shutdown now"
            "SUPER CTRL SHIFT, R, exec, reboot"
            "SUPER CTRL SHIFT, ESCAPE, exit"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.5"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
            ",XF86MonBrightnessUp, exec, brightnessctl s +10%"
          ]
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "SUPER, code:1${toString i}, workspace, ${toString ws}"
                "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          ));
          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
          general = {
            border_size = style.border.thickness;
            gaps_in = style.spacing / 2;
            gaps_out = style.spacing;
            resize_on_border = true;
            "col.inactive_border" = "0xff808080";
            "col.active_border" = "0xffffffff";
          };
          decoration = {
            rounding = style.border.radius;
            blur = {
              size = 10;
              passes = 2;
              noise = 0.1;
              contrast = 1.0;
              brightness = 0.3;
            };
            shadow.enabled = false;
          };
          animation = [ "global, 1, 1, default" ];
          exec-once = [
            "systemctl --user start hyprpolkitagent"
          ];
          env = [ "QT_QPA_PLATFORMTHEME,qt6ct" ];
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            font_family = style.font.name;
            # enable_anr_dialog = false;
            anr_missed_pings = 10;
            middle_click_paste = false;
          };
          dwindle = {
            smart_split = true;
          };
          ecosystem = {
            no_donation_nag = true;
            no_update_news = true;
          };
        };
      };
      home.sessionVariables.NIXOS_OZONE_WL = "1";
      gtk = {
        enable = true;
        theme = {
          package = pkgs.flat-remix-gtk;
          name = "Flat-Remix-GTK-Grey-Darkest";
        };
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
      };
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          icon-theme = "Adwaita";
        };
      };
    };
}
