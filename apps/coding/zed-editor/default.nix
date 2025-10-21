{
  inputs,
  systemSettings,
  userSettings,
  style,
  color,
  ...
}:

{
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        extraPackages = with pkgs; [
          nil
          nixd
          clang-tools
          texlab
          package-version-server
        ];
        extensions = [
          "nix"
          "glsl"
          "json"
          "latex"
          "qml"
        ];
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
        };
        userKeymaps = import ./keybinds.nix;
        themes.Rainbow = import ./theme.nix { color = color; };
      };
      wayland.windowManager.hyprland.settings = {
        bind = [
          "SUPER, W, exec, zeditor"
        ];
      };
    };
}
