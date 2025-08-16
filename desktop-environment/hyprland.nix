{
  pkgs,
  userSettings,
  ...
}:

{
  hardware.graphics.enable = true;
  environment.systemPackages = with pkgs; [
    # wireplumber
    glib
    hyprshot
    hyprpolkitagent
    pulseaudio
    brightnessctl
  ];
  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
  programs.dconf.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          input = [
            {
              kb_layout = "us, ru";
              kb_options = "grp:alt_shift_toggle";
              # sensitivity = -0.8;
              touchpad = {
                natural_scroll = true;
              };
            }
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
            gaps_in = 2;
            gaps_out = 2;
            resize_on_border = true;
            "col.inactive_border" = "0x00000000";
            "col.active_border" = "0xffffffff";
          };
          decoration = {
            rounding = 5;
            blur = {
              size = 10;
              passes = 3;
              noise = 0.0;
              contrast = 1.0;
              brightness = 0.5;
            };
            shadow = {
              enabled = false;
            };
          };
          animation = [ "global, 1, 1, default" ];
          exec-once = [
            "systemctl --user start hyprpolkitagent"
          ];
          env = [ "QT_QPA_PLATFORMTHEME,qt6ct" ];
          misc = {
            disable_hyprland_logo = true;
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
          package = pkgs.pkgs.flat-remix-gtk;
          name = "Flat-Remix-GTK-Grey-Darkest";
        };
      };
      dconf.settings = {
        "org/gnome/mutter" = {
          check-alive-timeout = 60000;
        };
      };
    };
}
