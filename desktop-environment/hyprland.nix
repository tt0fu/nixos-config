{
  systemSettings,
  userSettings,
  style,
  ...
}:

{
  hardware.graphics.enable = true;
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        glib
        hyprshot
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
        plugins = [
          pkgs.hyprlandPlugins.hyprscrolling
        ];
        settings = {
          input = [
            {
              kb_layout = "us, ru";
              kb_options = "grp:alt_shift_toggle";
              touchpad.natural_scroll = true;
            }
          ];
          monitor = [
            "${systemSettings.monitor.name}, ${systemSettings.monitor.settings}"
          ];
          bind = [
            "SUPER, ESCAPE, killactive"
            "SUPER, SPACE, togglefloating"
            "SUPER, RETURN, fullscreen"
            "SUPER, TAB, cyclenext"
            "SUPER, TAB, bringactivetotop"
            "SUPER SHIFT, TAB, cyclenext, prev"
            "SUPER SHIFT, TAB, bringactivetotop"

            "SUPER, Up, movefocus, u"
            "SUPER, Down, movefocus, d"
            # "SUPER, Left, movefocus, l"
            # "SUPER, Right, movefocus, r"
            # "SUPER, mouse_down, movefocus, l"
            # "SUPER, mouse_up, movefocus, r"
            "SUPER, Left, layoutmsg, move -col"
            "SUPER, Right, layoutmsg, move +col"
            "SUPER, mouse_down, layoutmsg, move -col"
            "SUPER, mouse_up, layoutmsg, move +col"

            # "SUPER SHIFT, Up, movewindow, u"
            # "SUPER SHIFT, Down, movewindow, d"
            # "SUPER SHIFT, Left, movewindow, l"
            # "SUPER SHIFT, Right, movewindow, r"

            "SUPER SHIFT, Up, layoutmsg, movewindowto u"
            "SUPER SHIFT, Down, layoutmsg, movewindowto d"
            "SUPER SHIFT, Left, layoutmsg, movewindowto l"
            "SUPER SHIFT, Right, layoutmsg, movewindowto r"
            "SUPER SHIFT, mouse_down, layoutmsg, movewindowto l"
            "SUPER SHIFT, mouse_up, layoutmsg, movewindowto r"

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
            builtins.genList (i: [
              "SUPER, code:1${toString i}, workspace, ${toString (i + 1)}"
              "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString (i + 1)}"
            ]) 9
          ));
          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
          gesture = [
            "3, up, dispatcher, movefocus, d"
            "3, down, dispatcher, movefocus, u"
            "3, left, dispatcher, movefocus, r"
            "3, right, dispatcher, movefocus, l"
            "4, horizontal, workspace"
          ];
          binds = {
            scroll_event_delay = 50;
          };
          general = {
            layout = "scrolling";
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
          plugin = {
            hyprscrolling = {
              column_width = 0.9;
              fullscreen_on_one_column = true;
              # follow_focus = false;
              # focus_fit_method = 1;
            };
          };
        };
      };
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
