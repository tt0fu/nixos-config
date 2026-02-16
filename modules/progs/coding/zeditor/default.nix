{
  home =
    {
      style,
      color,
      ...
    }:
    {
      programs.zed-editor = {
        enable = true;
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
          project_panel.auto_fold_dirs = false;
          preview_tabs.enabled = false;
          agent.enabled = false;
          disable_ai = true;
          collaboration_panel = {
            button = false;
          };
          title_bar = {
            show_sign_in = false;
            show_menus = true;
          };
          show_edit_predictions = false;
        };
        userKeymaps = import ./keybinds.nix;
        themes.Rainbow = import ./theme.nix color;
      };
      xdg.mimeApps.defaultApplications = {
        "text/*" = "dev.zed.Zed.desktop";
      };
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, W, exec, zeditor"
      ];
      programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite."class<dev.zed.Zed>" = "󰰶";
    };
}
