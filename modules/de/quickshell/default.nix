{
  home =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      programs.quickshell = {
        enable = true;
        package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
        activeConfig = "shell";
        configs = {
          shell = ./shell;
        };
      };
      wayland.windowManager.hyprland.settings = {
        layer_rule = [
          {
            match = {
              namespace = "quickshell";
            };
            blur = true;
            blur_popups = true;
            ignore_alpha = 0.0;
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
        ];
        on = [
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''function() hl.exec_cmd("setpriv --ambient-caps -all quickshell -c shell") end'')
            ];
          }
        ];
      };
    };
  deps =
    modules: with modules; [
      progs.utils.nmgui
      progs.utils.libnotify
      progs.utils.cliphist
    ];
}
