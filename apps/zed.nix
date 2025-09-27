{
  userSettings,
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
          base_keymap = "JetBrains";
          vim_mode = false;
          ui_font_size = 14;
          buffer_font_size = 14;
          buffer_font_family = "JetBrainsMono Nerd Font Propo";
          buffer_line_height = "standard";
          terminal = {
            font_family = "JetBrainsMono Nerd Font Propo";
            line_height = "standard";
            cursor_shape = "bar";
          };
          diagnostics.inline.enabled = true;
          minimap = {
            show = "always";
            display_in = "all_editors";
            thumb_border = "none";
          };
          theme = "Rainbow Dark";
        };
        themes.Rainbow = {
          "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
          name = "Rainbow";
          author = "ttofu";
          themes = [
            {
              name = "Rainbow Dark";
              appearance = "dark";
              style =
                let
                  transparent = "#00000000";
                  mainBg = "#000000a0";
                  white = "#ffffff";
                  white01 = "#ffffff01";
                  white02 = "#ffffff02";
                  white04 = "#ffffff04";
                  white08 = "#ffffff08";
                  white10 = "#ffffff10";
                  white20 = "#ffffff20";
                  white40 = "#ffffff40";
                  white80 = "#ffffff80";
                  black = "#000000";
                  substituteBg = "#1c1c1c";

                  inactive = "#303030";
                  active = "#606060";
                  hover = "#808080";
                  selected = "#404040";
                  disabled = "#202020";
                  colors = [
                    "#d2849c"
                    "#d28a69"
                    "#b79c50"
                    "#83ad6c"
                    "#4bb3a1"
                    "#4fabcd"
                    "#869bdd"
                    "#b68bc9"
                  ];
                  accents = [
                    "#f3a3bb"
                    "#f4a988"
                    "#d7bb70"
                    "#a2cd8b"
                    "#6dd3c0"
                    "#70ccee"
                    "#a5bbff"
                    "#d6aaea"
                  ];
                in
                {
                  inherit accents;
                  "background.appearance" = "blurred";

                  background = mainBg;
                  "status_bar.background" = mainBg;
                  "title_bar.background" = mainBg;
                  "title_bar.inactive_background" = mainBg;

                  border = white;
                  "border.disabled" = white;
                  "border.focused" = white;
                  "border.selected" = white;
                  "border.transparent" = white;
                  "border.variant" = white;

                  "elevated_surface.background" = substituteBg;
                  "surface.background" = substituteBg;
                  "element.background" = substituteBg;
                  "drop_target.background" = substituteBg;
                  "panel.overlay_background" = substituteBg;
                  "editor.subheader.background" = substituteBg;

                  "element.hover" = hover;
                  "element.active" = transparent;
                  "element.selected" = selected;
                  "element.disabled" = disabled;

                  "ghost_element.background" = transparent;
                  "ghost_element.hover" = hover;
                  "ghost_element.active" = transparent;
                  "ghost_element.selected" = selected;
                  "ghost_element.disabled" = disabled;
                  text = white;
                  "text.muted" = white80;
                  "text.placeholder" = inactive;
                  "text.disabled" = disabled;
                  "text.accent" = white;
                  icon = white;
                  "icon.muted" = white80;
                  "icon.disabled" = disabled;
                  "icon.placeholder" = inactive;
                  "icon.accent" = white;
                  "toolbar.background" = transparent;
                  "tab_bar.background" = transparent;
                  "tab.inactive_background" = transparent;
                  "tab.active_background" = white04;
                  "search.match_background" = white20;
                  "panel.background" = transparent;
                  "panel.focused_border" = white;
                  "panel.indent_guide" = inactive;
                  "panel.indent_guide_active" = active;
                  "panel.indent_guide_hover" = hover;

                  "pane.focused_border" = white;
                  "pane_group.border" = white;
                  "scrollbar.thumb.background" = white10;
                  "scrollbar.thumb.hover_background" = white20;
                  "scrollbar.thumb.border" = white;
                  "scrollbar.track.background" = transparent;
                  "scrollbar.track.border" = transparent;
                  "editor.foreground" = white;
                  "editor.background" = transparent;
                  "editor.gutter.background" = transparent;
                  "editor.active_line.background" = transparent;
                  "editor.highlighted_line.background" = white20;
                  "editor.line_number" = white20;
                  "editor.active_line_number" = white;
                  "editor.invisible" = white20;
                  "editor.wrap_guide" = inactive;
                  "editor.active_wrap_guide" = active;
                  "editor.document_highlight.bracket_background" = white10;
                  "editor.document_highlight.read_background" = white20;
                  "editor.document_highlight.write_background" = white20;
                  "editor.indent_guide" = inactive;
                  "editor.indent_guide_active" = active;

                  "terminal.background" = transparent;
                  "terminal.ansi.background" = "#1e1e2e";
                  "terminal.foreground" = white;
                  "terminal.dim_foreground" = "#808080";
                  "terminal.bright_foreground" = white;
                  "terminal.ansi.black" = black;
                  "terminal.ansi.red" = "#d00000";
                  "terminal.ansi.green" = "#00d000";
                  "terminal.ansi.yellow" = "#d0d000";
                  "terminal.ansi.blue" = "#0000d0";
                  "terminal.ansi.magenta" = "#d000d0";
                  "terminal.ansi.cyan" = "#00d0d0";
                  "terminal.ansi.white" = "#d0d0d0";
                  "terminal.ansi.bright_black" = black;
                  "terminal.ansi.bright_red" = "#f00000";
                  "terminal.ansi.bright_green" = "#00f000";
                  "terminal.ansi.bright_yellow" = "#f0f000";
                  "terminal.ansi.bright_blue" = "#0000f0";
                  "terminal.ansi.bright_magenta" = "#f000f0";
                  "terminal.ansi.bright_cyan" = "#00f0f0";
                  "terminal.ansi.bright_white" = "f0f0f0";
                  "terminal.ansi.dim_black" = black;
                  "terminal.ansi.dim_red" = "#b00000";
                  "terminal.ansi.dim_green" = "#00b000";
                  "terminal.ansi.dim_yellow" = "#b0b000";
                  "terminal.ansi.dim_blue" = "#0000b0";
                  "terminal.ansi.dim_magenta" = "#b000b0";
                  "terminal.ansi.dim_cyan" = "#00b0b0";
                  "terminal.ansi.dim_white" = "#b0b0b0";
                  "link_text.hover" = "#89dceb";
                  conflict = "#fab387";
                  "conflict.border" = "#fab387";
                  "conflict.background" = "#fab38726";
                  created = "#a6e3a1";
                  "created.border" = "#a6e3a1";
                  "created.background" = "#a6e3a126";
                  deleted = "#f38ba8";
                  "deleted.border" = "#f38ba8";
                  "deleted.background" = "#f38ba826";
                  hidden = "#6c7086";
                  "hidden.border" = "#6c7086";
                  "hidden.background" = "#181825";
                  hint = "#7c7f98";
                  "hint.border" = "#585b70";
                  "hint.background" = "#313244c0";
                  ignored = "#6c7086";
                  "ignored.border" = "#6c7086";
                  "ignored.background" = "#6c708626";
                  modified = "#f9e2af";
                  "modified.border" = "#f9e2af";
                  "modified.background" = "#f9e2af26";
                  predictive = "#6c7086";
                  "predictive.border" = "#b4befe";
                  "predictive.background" = "#181825";
                  renamed = "#74c7ec";
                  "renamed.border" = "#74c7ec";
                  "renamed.background" = "#74c7ec26";
                  info = "#94e2d5";
                  "info.border" = "#94e2d5";
                  "info.background" = "#1c2d33";
                  warning = "#f9e2af";
                  "warning.border" = "#f9e2af";
                  "warning.background" = "#342a1e";
                  error = "#f38ba8";
                  "error.border" = "#f38ba8";
                  "error.background" = "#3b2022";
                  success = "#a6e3a1";
                  "success.border" = "#a6e3a1";
                  "success.background" = "#213023";
                  unreachable = "#f38ba8";
                  "unreachable.border" = "#f38ba8";
                  "unreachable.background" = "#f38ba81f";
                  players = [
                    {
                      cursor = "#f5e0dc";
                      selection = "#585b7080";
                      background = "#f5e0dc";
                    }
                    {
                      cursor = "#cbb0f7";
                      selection = "#cbb0f733";
                      background = "#cbb0f7";
                    }
                    {
                      cursor = "#b9c3fc";
                      selection = "#b9c3fc33";
                      background = "#b9c3fc";
                    }
                    {
                      cursor = "#86caee";
                      selection = "#86caee33";
                      background = "#86caee";
                    }
                    {
                      cursor = "#aee1b2";
                      selection = "#aee1b233";
                      background = "#aee1b2";
                    }
                    {
                      cursor = "#f0e0bd";
                      selection = "#f0e0bd33";
                      background = "#f0e0bd";
                    }
                    {
                      cursor = "#f1ba9d";
                      selection = "#f1ba9d33";
                      background = "#f1ba9d";
                    }
                    {
                      cursor = "#eb9ab7";
                      selection = "#eb9ab733";
                      background = "#eb9ab7";
                    }
                  ];
                  "version_control.added" = "#a6e3a1";
                  "version_control.added_background" = "#a6e3a126";
                  "version_control.deleted" = "#f38ba8";
                  "version_control.deleted_background" = "#f38ba826";
                  "version_control.modified" = "#f9e2af";
                  "version_control.modified_background" = "#f9e2af26";
                  "version_control.renamed" = "#74c7ec";
                  "version_control.conflict" = "#fab387";
                  "version_control.conflict_background" = "#fab38726";
                  "version_control.ignored" = "#6c7086";
                  syntax = {
                    variable = {
                      color = "#cdd6f4";
                      font_style = null;
                      font_weight = null;
                    };
                    "variable.builtin" = {
                      color = "#f38ba8";
                      font_style = null;
                      font_weight = null;
                    };
                    "variable.parameter" = {
                      color = "#eba0ac";
                      font_style = null;
                      font_weight = null;
                    };
                    "variable.member" = {
                      color = "#89b4fa";
                      font_style = null;
                      font_weight = null;
                    };
                    "variable.special" = {
                      color = "#f38ba8";
                      font_style = "italic";
                      font_weight = null;
                    };
                    constant = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    "constant.builtin" = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    "constant.macro" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    module = {
                      color = "#f9e2af";
                      font_style = "italic";
                      font_weight = null;
                    };
                    label = {
                      color = "#74c7ec";
                      font_style = null;
                      font_weight = null;
                    };
                    string = {
                      color = "#a6e3a1";
                      font_style = null;
                      font_weight = null;
                    };
                    "string.documentation" = {
                      color = "#94e2d5";
                      font_style = null;
                      font_weight = null;
                    };
                    "string.regexp" = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    "string.escape" = {
                      color = "#f5c2e7";
                      font_style = null;
                      font_weight = null;
                    };
                    "string.special" = {
                      color = "#f5c2e7";
                      font_style = null;
                      font_weight = null;
                    };
                    "string.special.path" = {
                      color = "#f5c2e7";
                      font_style = null;
                      font_weight = null;
                    };
                    "string.special.symbol" = {
                      color = "#f2cdcd";
                      font_style = null;
                      font_weight = null;
                    };
                    "string.special.url" = {
                      color = "#f5e0dc";
                      font_style = "italic";
                      font_weight = null;
                    };
                    character = {
                      color = "#94e2d5";
                      font_style = null;
                      font_weight = null;
                    };
                    "character.special" = {
                      color = "#f5c2e7";
                      font_style = null;
                      font_weight = null;
                    };
                    boolean = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    number = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    "number.float" = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    type = {
                      color = "#f9e2af";
                      font_style = null;
                      font_weight = null;
                    };
                    "type.builtin" = {
                      color = "#cba6f7";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "type.definition" = {
                      color = "#f9e2af";
                      font_style = null;
                      font_weight = null;
                    };
                    "type.interface" = {
                      color = "#f9e2af";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "type.super" = {
                      color = "#f9e2af";
                      font_style = "italic";
                      font_weight = null;
                    };
                    attribute = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    property = {
                      color = "#89b4fa";
                      font_style = null;
                      font_weight = null;
                    };
                    function = {
                      color = "#89b4fa";
                      font_style = null;
                      font_weight = null;
                    };
                    "function.builtin" = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    "function.call" = {
                      color = "#89b4fa";
                      font_style = null;
                      font_weight = null;
                    };
                    "function.macro" = {
                      color = "#94e2d5";
                      font_style = null;
                      font_weight = null;
                    };
                    "function.method" = {
                      color = "#89b4fa";
                      font_style = null;
                      font_weight = null;
                    };
                    "function.method.call" = {
                      color = "#89b4fa";
                      font_style = null;
                      font_weight = null;
                    };
                    constructor = {
                      color = "#f2cdcd";
                      font_style = null;
                      font_weight = null;
                    };
                    operator = {
                      color = "#89dceb";
                      font_style = null;
                      font_weight = null;
                    };
                    keyword = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.modifier" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.type" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.coroutine" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.function" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.operator" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.import" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.repeat" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.return" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.debug" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.exception" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.conditional" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.conditional.ternary" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.directive" = {
                      color = "#f5c2e7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.directive.define" = {
                      color = "#f5c2e7";
                      font_style = null;
                      font_weight = null;
                    };
                    "keyword.export" = {
                      color = "#89dceb";
                      font_style = null;
                      font_weight = null;
                    };
                    punctuation = {
                      color = "#9399b2";
                      font_style = null;
                      font_weight = null;
                    };
                    "punctuation.delimiter" = {
                      color = "#9399b2";
                      font_style = null;
                      font_weight = null;
                    };
                    "punctuation.bracket" = {
                      color = "#9399b2";
                      font_style = null;
                      font_weight = null;
                    };
                    "punctuation.special" = {
                      color = "#f5c2e7";
                      font_style = null;
                      font_weight = null;
                    };
                    "punctuation.special.symbol" = {
                      color = "#f2cdcd";
                      font_style = null;
                      font_weight = null;
                    };
                    "punctuation.list_marker" = {
                      color = "#94e2d5";
                      font_style = null;
                      font_weight = null;
                    };
                    comment = {
                      color = "#9399b2";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "comment.doc" = {
                      color = "#9399b2";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "comment.documentation" = {
                      color = "#9399b2";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "comment.error" = {
                      color = "#f38ba8";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "comment.warning" = {
                      color = "#f9e2af";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "comment.hint" = {
                      color = "#89b4fa";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "comment.todo" = {
                      color = "#f2cdcd";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "comment.note" = {
                      color = "#f5e0dc";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "diff.plus" = {
                      color = "#a6e3a1";
                      font_style = null;
                      font_weight = null;
                    };
                    "diff.minus" = {
                      color = "#f38ba8";
                      font_style = null;
                      font_weight = null;
                    };
                    tag = {
                      color = "#89b4fa";
                      font_style = null;
                      font_weight = null;
                    };
                    "tag.attribute" = {
                      color = "#f9e2af";
                      font_style = "italic";
                      font_weight = null;
                    };
                    "tag.delimiter" = {
                      color = "#94e2d5";
                      font_style = null;
                      font_weight = null;
                    };
                    parameter = {
                      color = "#eba0ac";
                      font_style = null;
                      font_weight = null;
                    };
                    field = {
                      color = "#b4befe";
                      font_style = null;
                      font_weight = null;
                    };
                    namespace = {
                      color = "#f9e2af";
                      font_style = "italic";
                      font_weight = null;
                    };
                    float = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    symbol = {
                      color = "#f5c2e7";
                      font_style = null;
                      font_weight = null;
                    };
                    "string.regex" = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    text = {
                      color = "#cdd6f4";
                      font_style = null;
                      font_weight = null;
                    };
                    "emphasis.strong" = {
                      color = "#eba0ac";
                      font_style = null;
                      font_weight = 700;
                    };
                    emphasis = {
                      color = "#eba0ac";
                      font_style = "italic";
                      font_weight = null;
                    };
                    embedded = {
                      color = "#eba0ac";
                      font_style = null;
                      font_weight = null;
                    };
                    "text.literal" = {
                      color = "#a6e3a1";
                      font_style = null;
                      font_weight = null;
                    };
                    concept = {
                      color = "#74c7ec";
                      font_style = null;
                      font_weight = null;
                    };
                    enum = {
                      color = "#94e2d5";
                      font_style = null;
                      font_weight = 700;
                    };
                    "function.decorator" = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    "type.class.definition" = {
                      color = "#f9e2af";
                      font_style = null;
                      font_weight = 700;
                    };
                    hint = {
                      color = "#585b70";
                      font_style = "italic";
                      font_weight = null;
                    };
                    link_text = {
                      color = "#b4befe";
                      font_style = null;
                      font_weight = null;
                    };
                    link_uri = {
                      color = "#89b4fa";
                      font_style = "italic";
                      font_weight = null;
                    };
                    parent = {
                      color = "#fab387";
                      font_style = null;
                      font_weight = null;
                    };
                    predictive = {
                      color = "#6c7086";
                      font_style = null;
                      font_weight = null;
                    };
                    predoc = {
                      color = "#f38ba8";
                      font_style = null;
                      font_weight = null;
                    };
                    primary = {
                      color = "#eba0ac";
                      font_style = null;
                      font_weight = null;
                    };
                    "tag.doctype" = {
                      color = "#cba6f7";
                      font_style = null;
                      font_weight = null;
                    };
                    "string.doc" = {
                      color = "#94e2d5";
                      font_style = "italic";
                      font_weight = null;
                    };
                    title = {
                      color = "#cdd6f4";
                      font_style = null;
                      font_weight = 800;
                    };
                    variant = {
                      color = "#f38ba8";
                      font_style = null;
                      font_weight = null;
                    };
                  };
                };
            }
          ];
        };
      };
      wayland.windowManager.hyprland.settings = {
        bind = [
          "SUPER, W, exec, zeditor"
        ];
        layerrule = [
          "blur, zeditor"
          "blurpopups, zeditor"
        ];
      };
    };
}
