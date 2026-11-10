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
        installRemoteServer = true;
        mutableUserSettings = false;
        userSettings = {
          agent_servers.pi-acp = {
            favorite_config_option_values = {
              thought_level = [
                "high"
              ];
              model = [
                "coreinfra/deepseek-flash"
              ];
            };
            default_config_options = {
              model = "coreinfra/deepseek-flash";
            };
            type = "registry";
          };
          agent = {
            threads_sidebar.position = "right";
            dock = "right";
            enabled = true;
          };
          base_keymap = "None";
          buffer_font_family = style.font.name;
          buffer_font_features.calt = false;
          buffer_font_size = style.font.size;
          buffer_line_height = "standard";
          cli_default_open_behavior = "new_window";
          collaboration_panel.button = false;
          default_open_behavior = "new_window";
          diagnostics.inline.enabled = true;
          disable_ai = false;
          ensure_final_newline_on_save = false;
          format_on_save = "off";
          git_panel = {
            dock = "left";
            group_by = "none";
            tree_view = true;
          };
          minimap = {
            display_in = "all_editors";
            show = "always";
            thumb_border = "none";
          };
          outline_panel.dock = "left";
          preview_tabs.enabled = false;
          project_panel = {
            auto_fold_dirs = false;
            dock = "left";
          };
          remove_trailing_whitespace_on_save = false;
          show_edit_predictions = false;
          telemetry = {
            metrics = false;
            diagnostics = false;
          };
          terminal = {
            cursor_shape = "bar";
            font_family = style.font.name;
            line_height = "standard";
          };
          theme = "Rainbow Dark";
          title_bar = {
            show_menus = true;
            show_sign_in = false;
          };
          ui_font_size = style.font.size;
          vim_mode = false;
          session.restore_unsaved_buffers = false;
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
