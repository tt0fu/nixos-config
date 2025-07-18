{
  inputs,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  hardware.graphics.enable = true;
  environment.systemPackages = with pkgs; [
    pipewire
    wireplumber
    glib
    hyprshot
    hyprpolkitagent
  ];
  services.pipewire.enable = true;
  services.pipewire.wireplumber.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
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
          bind =
            [
              "SUPER, ESCAPE, killactive"
              "SUPER, F12, exit"
              "SUPER, SPACE, togglefloating"
              "SUPER, TAB, cyclenext"
              "SUPER, TAB, bringactivetotop"
              "SUPER&SHIFT, TAB, cyclenext, prev"
              "SUPER&SHIFT, TAB, bringactivetotop"
              "SUPER, Up, movefocus, u"
              "SUPER, Down, movefocus, d"
              "SUPER, Left, movefocus, l"
              "SUPER, Right, movefocus, r"
              "SUPER, RETURN, fullscreen"
              "SUPER, P, exec, shutdown now"
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
    };
}
