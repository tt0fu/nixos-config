{
  inputs,
  systemSettings,
  userSettings,
  style,
  ...
}:

{
  hardware.graphics.enable = true;
  home-manager.users.${userSettings.username} =
    { config, ... }:
    {
      # imports = [ inputs.niri.homeModules.niri ];
      # programs.niri = {
      #   enable = false; # true;
      #   settings = {
      #     binds = with config.lib.niri.actions; {
      #       "Mod+1".action = focus-workspace 1;
      #       "Mod+2".action = focus-workspace 2;
      #       "Mod+3".action = focus-workspace 3;
      #       "Mod+4".action = focus-workspace 4;
      #       "Mod+5".action = focus-workspace 5;
      #       "Mod+6".action = focus-workspace 6;
      #       "Mod+7".action = focus-workspace 7;
      #       "Mod+8".action = focus-workspace 8;
      #       "Mod+9".action = focus-workspace 9;

      #       "Mod+Escape".action = close-window;
      #       "Mod+Space".action = toggle-window-floating;
      #       "Mod+Return".action = fullscreen-window;

      #       "Mod+Tab".action = focus-window-down-or-column-right;
      #       "Mod+Shift+Tab".action = focus-window-up-or-column-left;

      #       "Mod+Up".action = focus-window-up;
      #       "Mod+Down".action = focus-window-down;
      #       "Mod+Left".action = focus-column-left-or-last;
      #       "Mod+Right".action = focus-column-right-or-first;
      #       "Mod+WheelScrollDown" = {
      #         action = focus-column-right-or-first;
      #         cooldown-ms = 150;
      #       };
      #       "Mod+WheelScrollUp" = {
      #         action = focus-column-left-or-last;
      #         cooldown-ms = 150;
      #       };

      #       "Mod+Shift+Up".action = move-window-up;
      #       "Mod+Shift+Down".action = move-window-down;
      #       "Mod+Shift+Left".action = move-column-left;
      #       "Mod+Shift+Right".action = move-column-right;
      #       "Mod+Shift+WheelScrollDown" = {
      #         action = move-column-right;
      #         cooldown-ms = 150;
      #       };
      #       "Mod+Shift+WheelScrollUp" = {
      #         action = move-column-left;
      #         cooldown-ms = 150;
      #       };

      #       "Mod+Ctrl+Shift+S".action = spawn "shutdown" "now";
      #       "Mod+Ctrl+Shift+R".action = spawn "reboot";
      #       "Mod+Ctrl+Shift+Escape".action = quit { skip-confirmation = true; };

      #       "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
      #       "XF86AudioRaiseVolume".action =
      #         spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+" "--limit"
      #           "1.5";
      #       "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      #       "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@ " "toggle";
      #       "XF86MonBrightnessDown".action = spawn "brightnessctl" "s" "10%-";
      #       "XF86MonBrightnessUp".action = spawn "brightnessctl" "s" "+10%";
      #     };
      #     layout = {
      #       center-focused-column = "always";
      #       gaps = style.spacing;
      #       # shadow = {
      #       #   enable = true;
      #       #   color = "#00000080";
      #       # };
      #     };
      #     prefer-no-csd = true;
      #     overview.workspace-shadow.enable = false;
      #     layout = {
      #       border = {
      #         enable = true;
      #         width = style.border.thickness;
      #         active.color = "ffffff";
      #         inactive.color = "808080";
      #         urgent.color = "ff6060";
      #       };
      #       focus-ring.enable = false;
      #     };
      #     window-rules = [
      #       {
      #         geometry-corner-radius = {
      #           bottom-left = style.border.radius + 0.0;
      #           bottom-right = style.border.radius + 0.0;
      #           top-left = style.border.radius + 0.0;
      #           top-right = style.border.radius + 0.0;
      #         };
      #         clip-to-geometry = true;
      #         draw-border-with-background = false;
      #       }
      #     ];
      #   };
      # };
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
