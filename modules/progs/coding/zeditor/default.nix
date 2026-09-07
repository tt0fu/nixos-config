{
  home =
    {
      inputs,
      lib,
      pkgs,
      allModules,
      style,
      ...
    }:
    {
      programs.zed-editor = {
        enable = true;
        defaultEditor = true;
        mutableUserSettings = false;
        userSettings = {
          telemetry.metrics = false;
          vim_mode = false;
          ui_font_size = style.font.size;
          buffer_font_size = style.font.size;
          buffer_font_family = style.font.name;
          buffer_line_height = "standard";
          terminal = {
            font_family = style.font.name;
            line_height = "standard";
            cursor_shape = "bar";
          };
          diagnostics.inline.enabled = true;
          minimap = {
            show = "always";
            display_in = "all_editors";
            thumb_border = "none";
          };
          base_keymap = "None";
          theme = "Rainbow Dark";
          format_on_save = "off";
          remove_trailing_whitespace_on_save = false;
          ensure_final_newline_on_save = false;
          project_panel = {
            dock = "left";
            auto_fold_dirs = false;
          };
          outline_panel = {
            dock = "left";
          };
          preview_tabs.enabled = false;
          agent = {
            enabled = true;
            sidebar_side = "right";
            dock = "right";
          };
          disable_ai = false;
          collaboration_panel = {
            button = false;
          };
          git_panel = {
            dock = "left";
            tree_view = true;
            group_by = "none";
          };
          title_bar = {
            show_sign_in = false;
            show_menus = true;
          };
          show_edit_predictions = false;
          buffer_font_features = {
            calt = false;
          };
          default_open_behavior = "new_window";
          cli_default_open_behavior = "new_window";
        };
        mutableUserKeymaps = false;
        userKeymaps = import ./keybinds.nix;
        themes.Rainbow = import ./theme.nix (allModules.lib.color.color { inherit inputs; });
      };
      home.packages = [ pkgs.bubblewrap ];
      xdg.mimeApps.defaultApplications = {
        "text/plain" = "dev.zed.Zed.desktop";
        "text/*" = "dev.zed.Zed.desktop";
      };
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "SUPER + W"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"zeditor\")")
          ];
        }
      ];
    };
  deps = modules: with modules; [ progs.utils.nix-ld ];
}
