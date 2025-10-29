{ pkgs }:
{
  width = 0.115;
  size = [
    400
    200
  ];
  elements = [
    {
      type = "Panel";
      rect = [
        0
        30
        400
        130
      ];
      corner_radius = 20;
      bg_color = "#24273a";
    }
    {
      type = "Button";
      rect = [
        2
        162
        26
        36
      ];
      corner_radius = 4;
      font_size = 15;
      bg_color = "#c6a0f6";
      fg_color = "#24273a";
      text = "C";
      click_up = [
        {
          type = "Window";
          target = "settings";
          action = "ShowUi";
        }
        {
          type = "Window";
          target = "settings";
          action = "Destroy";
        }
      ];
    }
    {
      type = "Button";
      rect = [
        32
        162
        48
        36
      ];
      corner_radius = 4;
      font_size = 15;
      bg_color = "#2288FF";
      fg_color = "#24273a";
      text = "Cal";
      click_up = [
        {
          type = "Exec";
          command = [
            "${pkgs.kitty}/bin/kitty"
            "--class"
            "motoc"
            "--"
            "${pkgs.motoc}/bin/motoc"
            "calibrate"
            "--src"
            "WiVRn right controller"
            "--dst"
            "LHR-B8E3267C"
          ];
        }
      ];
    }
    {
      type = "Button";
      rect = [
        84
        162
        48
        36
      ];
      corner_radius = 4;
      font_size = 15;
      fg_color = "#24273a";
      bg_color = "#a6da95";
      text = "Kbd";
      click_up = [
        {
          type = "Overlay";
          target = "kbd";
          action = "ToggleVisible";
        }
      ];
      long_click_up = [
        {
          type = "Overlay";
          target = "kbd";
          action = "Reset";
        }
      ];
      right_up = [
        {
          type = "Overlay";
          target = "kbd";
          action = "ToggleImmovable";
        }
      ];
      middle_up = [
        {
          type = "Overlay";
          target = "kbd";
          action = "ToggleInteraction";
        }
      ];
      scroll_up = [
        {
          type = "Overlay";
          target = "kbd";
          action = {
            Opacity = {
              delta = 0.025;
            };
          };
        }
      ];
      scroll_down = [
        {
          type = "Overlay";
          target = "kbd";
          action = {
            Opacity = {
              delta = -0.025;
            };
          };
        }
      ];
    }
    {
      type = "OverlayList";
      rect = [
        134
        160
        266
        40
      ];
      corner_radius = 4;
      font_size = 15;
      fg_color = "#cad3f5";
      bg_color = "#1e2030";
      layout = "Horizontal";
      click_up = "ToggleVisible";
      long_click_up = "Reset";
      right_up = "ToggleImmovable";
      middle_up = "ToggleInteraction";
      scroll_up = {
        Opacity = {
          delta = 0.025;
        };
      };
      scroll_down = {
        Opacity = {
          delta = -0.025;
        };
      };
    }
    {
      type = "Label";
      rect = [
        19
        90
        200
        50
      ];
      corner_radius = 4;
      font_size = 46;
      fg_color = "#cad3f5";
      source = "Clock";
      format = "%H:%M";
    }
    {
      type = "Label";
      rect = [
        20
        117
        200
        20
      ];
      corner_radius = 4;
      font_size = 14;
      fg_color = "#cad3f5";
      source = "Clock";
      format = "%x";
    }
    {
      type = "Label";
      rect = [
        20
        137
        200
        50
      ];
      corner_radius = 4;
      font_size = 14;
      fg_color = "#cad3f5";
      source = "Clock";
      format = "%A";
    }
    {
      type = "Label";
      rect = [
        210
        90
        200
        50
      ];
      corner_radius = 4;
      font_size = 24;
      fg_color = "#8bd5ca";
      source = "Clock";
      timezone = 0;
      format = "%H:%M";
    }
    {
      type = "Label";
      rect = [
        210
        60
        200
        50
      ];
      corner_radius = 4;
      font_size = 14;
      fg_color = "#8bd5ca";
      source = "Timezone";
      timezone = 0;
    }
    {
      type = "Label";
      rect = [
        210
        150
        200
        50
      ];
      corner_radius = 4;
      font_size = 24;
      fg_color = "#b7bdf8";
      source = "Clock";
      timezone = 1;
      format = "%H:%M";
    }
    {
      type = "Label";
      rect = [
        210
        120
        200
        50
      ];
      corner_radius = 4;
      font_size = 14;
      fg_color = "#b7bdf8";
      source = "Timezone";
      timezone = 1;
    }
    {
      type = "BatteryList";
      rect = [
        0
        5
        400
        30
      ];
      corner_radius = 4;
      font_size = 16;
      fg_color = "#8bd5ca";
      fg_color_low = "#B06060";
      fg_color_charging = "#6080A0";
      num_devices = 9;
      layout = "Horizontal";
      low_threshold = 33;
    }
    {
      type = "Button";
      rect = [
        315
        52
        70
        32
      ];
      corner_radius = 4;
      font_size = 13;
      fg_color = "#cad3f5";
      bg_color = "#5b6078";
      text = "Vol +";
      click_down = [
        {
          type = "Exec";
          command = [
            "pactl"
            "set-sink-volume"
            "@DEFAULT_SINK@"
            "+5%"
          ];
        }
      ];
    }
    {
      type = "Button";
      rect = [
        315
        116
        70
        32
      ];
      corner_radius = 4;
      font_size = 13;
      fg_color = "#cad3f5";
      bg_color = "#5b6078";
      text = "Vol -";
      click_down = [
        {
          type = "Exec";
          command = [
            "pactl"
            "set-sink-volume"
            "@DEFAULT_SINK@"
            "-5%"
          ];
        }
      ];
    }
  ];
}
