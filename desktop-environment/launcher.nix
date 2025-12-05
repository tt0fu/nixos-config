{
  userSettings,
  style,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { config, pkgs, ... }:
    {
      home.packages = [ pkgs.killall ];
      programs.rofi = {
        enable = true;
        font = "${style.font.name} ${builtins.toString style.font.size}";
        modes = [
          "window"
          "drun"
          "run"
          "filebrowser"
          "combi"
          "recursivebrowser"
        ];
        terminal = "${pkgs.kitty}/bin/kitty";
        theme =
          let
            # Use `mkLiteral` for string-like values that should show without
            # quotes, e.g.:
            # {
            #   foo = "abc"; => foo: "abc";
            #   bar = mkLiteral "abc"; => bar: abc;
            # };
            inherit (config.lib.formats.rasi) mkLiteral;
          in
          {
            "*" = {
              background-color = mkLiteral "transparent";
              text-color = mkLiteral "#ffffff";
              padding = 0;
              margin = 0;
              spacing = 0;
            };

            window = {
              width = 1000;
              background-color = mkLiteral "#00000001";
            };

            listview = {
              lines = 10;
            };

            "inputbar, window, element selected, message, prompt" = {
              border = style.border.thickness;
              border-color = mkLiteral "#ffffff";
              border-radius = style.border.radius;
            };

            mainbox = {
              padding = style.spacing;
            };

            "mainbox, listview" = {
              spacing = style.spacing;
            };

            "element, inputbar, prompt, entry, element-text" = {
              padding = mkLiteral "${builtins.toString (style.spacing / 2.0)}px";
            };

            "element-icon, element-text, prompt, entry, fr, ns, ci" = {
              margin = mkLiteral "${builtins.toString (style.spacing / 2.0)}px";
            };

            element-icon = {
              size = style.font.size * 2;
            };
          };
      };
      wayland.windowManager.hyprland.settings = {
        bind = [
          "SUPER, A, exec, killall rofi || rofi -show-icons -show combi -modes combi -combi-modes \"window,drun,run,filebrowser,recursivebrowser\""
        ];
        layerrule = [
          "blur, rofi"
          "ignorezero, rofi"
        ];
      };
      # programs.niri.settings.binds."Mod+A".action.spawn = [
      #   "sh"
      #   "-c"
      #   "killall rofi || rofi -show-icons -show combi -modes combi -combi-modes \"window,drun,run,filebrowser,recursivebrowser\""
      # ];
    };
}
