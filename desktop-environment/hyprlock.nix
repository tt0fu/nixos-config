{
  userSettings,
  ...
}:

{
  security.pam.services.hyprlock = { };
  home-manager.users.${userSettings.username} =
    { ... }:
    {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            hide_cursor = false;
            no_fade_in = false;
          };
          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 10;
              noise = 0.0;
              contrast = 1.0;
              brightness = 0.7;
              vibrancy = 0.0;
              vibrancy_darkness = 0.0;
            }
          ];
          input-field = [
            {
              size = "200, 50";
              fade_on_empty = false;
              font_color = "rgb(255, 255, 255)";
              font_family = "JetBrainsMono Nerd Font Propo";
              inner_color = "rgba(0, 0, 0, 0)";
              outer_color = "rgb(255, 255, 255)";
              outline_thickness = 1;
              placeholder_text = "<i>Password...</i>";
              check_color = "rgb(255, 255, 100)";
              fail_color = "rgb(255, 100, 100)";
              fail_text = "<i>Incorrect password</i>";
            }
          ];
          label = [
            {
              position = "0, 100";
              text = "cmd[update:1000] echo \"<b>$(date '+%H:%M:%S')</b>\"";
              color = "rgb(255, 255, 255)";
              font_size = 50;
              font_family = "JetBrainsMono Nerd Font Propo";
            }
            {
              position = "-100, -100";
              text = "⏻";
              color = "rgb(255, 255, 255)";
              font_size = 30;
              font_family = "JetBrainsMono Nerd Font Propo";
              onclick = "shutdown now";
            }
            {
              position = "0, -100";
              text = "";
              color = "rgb(255, 255, 255)";
              font_size = 30;
              font_family = "JetBrainsMono Nerd Font Propo";
              onclick = "reboot";
            }
            {
              position = "100, -100";
              text = "󰈆";
              color = "rgb(255, 255, 255)";
              font_size = 30;
              font_family = "JetBrainsMono Nerd Font Propo";
              onclick = "hyprctl dispatch exit";
            }
          ];
        };
      };
      wayland.windowManager.hyprland.settings = {
        bind = [ "SUPER, L, exec, hyprlock" ];
        exec-once = [ "sleep 0.5; hyprlock" ];
      };
    };
}
