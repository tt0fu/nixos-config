{
  home =
    {
      config,
      lib,
      style,
      ...
    }:
    let
      styleEnv = {
        QS_STYLE_FONT_FAMILY = style.font.name;
        QS_STYLE_FONT_SIZE = toString style.font.size;
        QS_STYLE_BORDER_WIDTH = toString style.border.thickness;
        QS_STYLE_BORDER_RADIUS = toString style.border.radius;
        QS_STYLE_SPACING = toString style.spacing;
        QS_STYLE_ICONSIZE = toString style.iconSize;
      };
    in
    {
      programs.quickshell = {
        enable = true;
        activeConfig = "shell";
        configs = {
          shell = ./shell;
        };
        systemd.enable = true;
      };
      home.sessionVariables = styleEnv;
      systemd.user.services.quickshell.Service.Environment = lib.mapAttrsToList (
        name: value: ''"${name}=${lib.escape [ "\\" "\"" ] value}"''
      ) styleEnv;
      systemd.user.services.quickshell.Unit.PartOf = lib.mkIf config.programs.quickshell.systemd.enable [
        "graphical-session.target"
        "wayland-wm@Hyprland.service"
      ];
      wayland.windowManager.hyprland.settings = {
        layer_rule = [
          {
            match = {
              namespace = "quickshell";
            };
            blur = true;
            blur_popups = true;
            ignore_alpha = 0.0;
            order = 10;
          }
        ];
        bind = [
          {
            _args = [
              "SUPER + A"
              (lib.generators.mkLuaInline "hl.dsp.global(\"quickshell:toggleLauncher\")")
            ];
          }
          {
            _args = [
              "SUPER + V"
              (lib.generators.mkLuaInline "hl.dsp.global(\"quickshell:toggleClipboard\")")
            ];
          }
          {
            _args = [
              "SUPER + N"
              (lib.generators.mkLuaInline "hl.dsp.global(\"quickshell:toggleNotifications\")")
            ];
          }
          {
            _args = [
              "SUPER + L"
              (lib.generators.mkLuaInline "hl.dsp.global(\"quickshell:lock\")")
            ];
          }
        ];
      };
    };
  deps =
    modules: with modules; [
      de.hyprshutdown
      progs.utils.nmgui
      progs.utils.libnotify
      progs.utils.cliphist
    ];
}
