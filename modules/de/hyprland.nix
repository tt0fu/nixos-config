{
  os =
    { ... }:
    {
      hardware.graphics.enable = true;
      programs.hyprland.enable = true;
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
    };
  home =
    {
      inputs,
      lib,
      systemSettings,
      style,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        glib
        hyprshot
        brightnessctl
        playerctl
      ];
      wayland.windowManager.hyprland = {
        enable = true;
        # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
        # portalPackage =
        # inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        plugins = [
          # pkgs.hyprlandPlugins.hypr-dynamic-cursors
          # inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
        ];
        settings = {
          config = {
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
                vibrancy = 0.0;
                popups = true;
                popups_ignorealpha = 0.2;
              };
              shadow.enabled = false;
            };
            input = {
              kb_layout = "us, ru";
              kb_options = "grp:alt_shift_toggle";
            };
            binds = {
              scroll_event_delay = 100;
            };
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
            scrolling = {
              column_width = 0.5;
              fullscreen_on_one_column = true;
            };
            master = {
              allow_small_split = true;
            };
            ecosystem = {
              no_donation_nag = true;
              no_update_news = true;
            };
          };
          monitor = with systemSettings.monitor; {
            output = name;
            mode = "${toString width}x${toString height}@${toString framerate}";
            position = "${toString x}x${toString y}";
            inherit scale;
          };
          bind = [
            {
              _args = [
                "SUPER + ESCAPE"
                (lib.generators.mkLuaInline "hl.dsp.window.close()")
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + ESCAPE"
                (lib.generators.mkLuaInline "hl.dsp.window.kill()")
              ];
            }
            {
              _args = [
                "SUPER + mouse:274"
                (lib.generators.mkLuaInline "hl.dsp.window.close()")
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + mouse:274"
                (lib.generators.mkLuaInline "hl.dsp.window.kill()")
              ];
            }
            {
              _args = [
                "SUPER + SPACE"
                (lib.generators.mkLuaInline "hl.dsp.window.float()")
              ];
            }
            {
              _args = [
                "SUPER + RETURN"
                (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
              ];
            }
            {
              _args = [
                "SUPER + TAB"
                (lib.generators.mkLuaInline "hl.dsp.window.cycle_next()")
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + TAB"
                (lib.generators.mkLuaInline "hl.dsp.window.cycle_next({ next = false })")
              ];
            }
            {
              _args = [
                "SUPER + CTRL + SHIFT + P"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"shutdown now\")")
              ];
            }
            {
              _args = [
                "SUPER + CTRL + SHIFT + L"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"reboot\")")
              ];
            }
            {
              _args = [
                "SUPER + CTRL + SHIFT + ESCAPE"
                (lib.generators.mkLuaInline "hl.dsp.exit()")
              ];
            }
            {
              _args = [
                "SUPER + Up"
                (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"up\" })")
              ];
            }
            {
              _args = [
                "SUPER + Down"
                (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"down\" })")
              ];
            }
            {
              _args = [
                "SUPER + Left"
                (lib.generators.mkLuaInline "hl.dsp.layout(\"focus l\")")
              ];
            }
            {
              _args = [
                "SUPER + Right"
                (lib.generators.mkLuaInline "hl.dsp.layout(\"focus r\")")
              ];
            }
            {
              _args = [
                "SUPER + mouse_down"
                (lib.generators.mkLuaInline "hl.dsp.layout(\"focus l\")")
              ];
            }
            {
              _args = [
                "SUPER + mouse_up"
                (lib.generators.mkLuaInline "hl.dsp.layout(\"focus r\")")
              ];
            }
            {
              _args = [
                "SUPER + mouse:276"
                (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"e-1\" })")
              ];
            }
            {
              _args = [
                "SUPER + mouse:275"
                (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"e+1\" })")
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + Up"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"up\" })")
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + Down"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"down\" })")
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + Left"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"left\" })")
              ];
            }
            {
              _args = [
                "SUPER + SHIFT + Right"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"right\" })")
              ];
            }
            {
              _args = [
                "XF86AudioLowerVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
              ];
            }
            {
              _args = [
                "XF86AudioRaiseVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.5\")")
              ];
            }
            {
              _args = [
                "XF86AudioMute"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
              ];
            }
            {
              _args = [
                "XF86AudioMicMute"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
              ];
            }
            {
              _args = [
                "XF86AudioPlay"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
              ];
            }
            {
              _args = [
                "XF86AudioStop"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl stop\")")
              ];
            }
            {
              _args = [
                "XF86AudioPrev"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")")
              ];
            }
            {
              _args = [
                "XF86AudioNext"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")")
              ];
            }
            {
              _args = [
                "XF86MonBrightnessDown"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl s 10%-\")")
              ];
            }
            {
              _args = [
                "XF86MonBrightnessUp"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl s +10%\")")
              ];
            }
            {
              _args = [
                "SUPER + mouse:272"
                (lib.generators.mkLuaInline "hl.dsp.window.drag()")
                { mouse = true; }
              ];
            }
            {
              _args = [
                "SUPER + mouse:273"
                (lib.generators.mkLuaInline "hl.dsp.window.resize()")
                { mouse = true; }
              ];
            }
          ]
          ++ (builtins.concatLists (
            builtins.genList (i: [
              {
                _args = [
                  "SUPER + ${toString (i + 1)}"
                  (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${toString (i + 1)} })")
                ];
              }
              {
                _args = [
                  "SUPER + SHIFT + ${toString (i + 1)}"
                  (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = ${toString (i + 1)} })")
                ];
              }
            ]) 9
          ));
          gesture = [
            {
              fingers = 3;
              direction = "horizontal";
              action = "scroll_move";
            }
            {
              fingers = 4;
              direction = "horizontal";
              action = "workspace";
            }
          ];
          animation = [
            {
              leaf = "global";
              enabled = true;
              speed = 1;
              bezier = "easeInOutQuad";
            }
          ];
          curve = [
            {
              _args = [
                "easeInOutQuad"
                (lib.generators.mkLuaInline ''{ type = "bezier", points = { {0.45, 0}, {0.55, 1} } }'')
              ];
            }
          ];
          # plugin = {
          #   dynamic-cursors = {
          #     mode = "stretch";
          #     stretch = {
          #       limit = 15000;
          #     };
          #     shake = {
          #       threshold = 7.5;
          #       effects = true;
          #       timeout = 1500;
          #     };
          #     hyprcursor = {
          #       nearest = false;
          #     };
          #   };
          # };
        };
      };
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
