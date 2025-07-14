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
          "$mod" = "SUPER";
          input = [
            {
              kb_layout = "us, ru";
              kb_options = "grp:alt_shift_toggle";
              # sensitivity = -0.8;
            }
          ];
          bind =
            [
              "SUPER, ESCAPE, killactive"
              "SUPER, F12, exit"
              "SUPER, SPACE, togglefloating"
              "SUPER, S, exec, hyprshot -o ~/Images/screenshots -m region"
              "SUPER, TAB, cyclenext"
              "SUPER, TAB, bringactivetotop"
              "SUPER&SHIFT, TAB, cyclenext, prev"
              "SUPER&SHIFT, TAB, bringactivetotop"
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
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            ));
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
          monitor = [ "${systemSettings.monitor}, 1366x768@60.00Hz, 0x0, 1" ];
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
              brightness = 1.0;
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
