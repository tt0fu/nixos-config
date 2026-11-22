{
  inputs = {
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
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
        # package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
        activeConfig = "shell";
        configs = {
          shell = ./shell;
        };
        systemd = {
          enable = true;
          target = "hyprland-session.target";
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
