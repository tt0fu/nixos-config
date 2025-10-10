{ color, ... }:
{
  "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
  name = "Rainbow";
  author = "ttofu";
  themes = [
    {
      name = "Rainbow Dark";
      appearance = "dark";
      style =
        let
          grayTransparent = value: transparency: color.toHex (color.grayTransparent value transparency);

          blackTransparent = grayTransparent 0;
          whiteTransparent = grayTransparent 1.0;
          transparent = blackTransparent 0;
          gray = value: color.toHex (color.gray value);

          white = gray 1.0;
          black = gray 0;

          # lch = lch: color.toHex (color.lrgbToSrgb (color.oklabToLrgb (color.lchToOklab lch)));
          palette =
            n: lightness: chroma:
            map color.toHex (color.palette n lightness chroma);
          paletteTransparent =
            n: lightness: chroma: transparency:
            map color.toHex (color.paletteTransparent n lightness chroma transparency);

          mainBg = blackTransparent 0.8; # blackTransparent 0.01;
          substituteBg = gray 0.06;

          background = paletteTransparent 8 0.5 0.1 0.5;
          regular = palette 8 0.7 0.1;
          accent = palette 8 0.8 0.1;

          syntax = builtins.elemAt (palette 16 0.8 0.1);

          getColor = ind: list: builtins.elemAt list ind;

          red = getColor 0;
          orange = getColor 1;
          yellow = getColor 2;
          green = getColor 3;
          mint = getColor 4;
          blue = getColor 5;
          lavender = getColor 6;
          purple = getColor 7;

          inactive = gray 0.125;
          active = gray 0.25;
          hover = gray 0.3;
          selected = gray 0.2;
          disabled = gray 0.2;
          muted = gray 0.5;
        in
        {
          accents = accent;
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
          "text.muted" = muted;
          "text.placeholder" = inactive;
          "text.disabled" = disabled;
          "text.accent" = white;
          icon = white;
          "icon.muted" = muted;
          "icon.disabled" = disabled;
          "icon.placeholder" = inactive;
          "icon.accent" = white;
          "toolbar.background" = transparent;
          "tab_bar.background" = transparent;
          "tab.inactive_background" = transparent;
          "tab.active_background" = whiteTransparent 0.125;
          "search.match_background" = whiteTransparent 0.2;
          "panel.background" = transparent;
          "panel.focused_border" = white;
          "panel.indent_guide" = inactive;
          "panel.indent_guide_active" = active;
          "panel.indent_guide_hover" = hover;

          "pane.focused_border" = white;
          "pane_group.border" = white;
          "scrollbar.thumb.background" = whiteTransparent 0.05;
          "scrollbar.thumb.hover_background" = whiteTransparent 0.125;
          "scrollbar.thumb.border" = white;
          "scrollbar.track.background" = transparent;
          "scrollbar.track.border" = transparent;
          "editor.foreground" = white;
          "editor.background" = transparent;
          "editor.gutter.background" = transparent;
          "editor.active_line.background" = transparent;
          "editor.highlighted_line.background" = whiteTransparent 0.125;
          "editor.line_number" = whiteTransparent 0.125;
          "editor.active_line_number" = white;
          "editor.invisible" = whiteTransparent 0.125;
          "editor.wrap_guide" = inactive;
          "editor.active_wrap_guide" = active;
          "editor.document_highlight.bracket_background" = whiteTransparent 0.06;
          "editor.document_highlight.read_background" = whiteTransparent 0.125;
          "editor.document_highlight.write_background" = whiteTransparent 0.125;
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

          "link_text.hover" = mint regular;
          conflict = red regular;
          "conflict.border" = red accent;
          "conflict.background" = red background;
          created = green regular;
          "created.border" = green accent;
          "created.background" = green background;
          deleted = purple regular;
          "deleted.border" = purple accent;
          "deleted.background" = purple background;
          hidden = gray 0.5;
          "hidden.border" = gray 0.8;
          "hidden.background" = gray 0.2;
          hint = yellow regular;
          "hint.border" = yellow accent;
          "hint.background" = yellow background;
          ignored = gray 0.3;
          "ignored.border" = gray 0.5;
          "ignored.background" = gray 0.15;
          modified = yellow regular;
          "modified.border" = yellow accent;
          "modified.background" = yellow background;
          predictive = gray 0.5;
          "predictive.border" = gray 0.8;
          "predictive.background" = gray 0.2;
          renamed = blue regular;
          "renamed.border" = blue accent;
          "renamed.background" = blue background;
          info = mint regular;
          "info.border" = mint accent;
          "info.background" = mint background;
          warning = orange regular;
          "warning.border" = orange accent;
          "warning.background" = orange background;
          error = red regular;
          "error.border" = red accent;
          "error.background" = red background;
          success = green regular;
          "success.border" = green accent;
          "success.background" = green background;
          unreachable = red regular;
          "unreachable.border" = red accent;
          "unreachable.background" = red background;
          players = builtins.genList (i: {
            cursor = builtins.elemAt accent i;
            selection = builtins.elemAt background i;
            background = builtins.elemAt background i;
          }) (builtins.length regular);

          "version_control.added" = green regular;
          "version_control.added_background" = green background;
          "version_control.deleted" = purple regular;
          "version_control.deleted_background" = purple background;
          "version_control.modified" = yellow regular;
          "version_control.modified_background" = yellow background;
          "version_control.renamed" = blue regular;
          "version_control.conflict" = red regular;
          "version_control.conflict_background" = red background;
          "version_control.ignored" = gray 0.5;
          syntax = {
            variable.color = syntax 3;
            "variable.builtin".color = "#f38ba8";
            "variable.parameter".color = "#eba0ac";
            "variable.member".color = "#89b4fa";
            "variable.special".color = "#f38ba8";
            constant.color = "#fab387";
            "constant.builtin".color = "#fab387";
            "constant.macro".color = "#cba6f7";
            module.color = "#f9e2af";
            label.color = "#74c7ec";
            string.color = "#a6e3a1";
            "string.documentation".color = "#94e2d5";
            "string.regexp".color = "#fab387";
            "string.escape".color = "#f5c2e7";
            "string.special".color = "#f5c2e7";
            "string.special.path".color = "#f5c2e7";
            "string.special.symbol".color = "#f2cdcd";
            "string.special.url".color = "#f5e0dc";
            character.color = "#94e2d5";
            "character.special".color = "#f5c2e7";
            boolean.color = "#fab387";
            number.color = "#fab387";
            "number.float".color = "#fab387";
            type.color = "#f9e2af";
            "type.builtin".color = "#cba6f7";
            "type.definition".color = "#f9e2af";
            "type.interface".color = "#f9e2af";
            "type.super".color = "#f9e2af";
            attribute.color = "#fab387";
            property.color = "#89b4fa";
            function.color = "#89b4fa";
            "function.builtin".color = "#fab387";
            "function.call".color = "#89b4fa";
            "function.macro".color = "#94e2d5";
            "function.method".color = "#89b4fa";
            "function.method.call".color = "#89b4fa";
            constructor.color = "#f2cdcd";
            operator.color = "#89dceb";
            keyword.color = "#cba6f7";
            "keyword.modifier".color = "#cba6f7";
            "keyword.type".color = "#cba6f7";
            "keyword.coroutine".color = "#cba6f7";
            "keyword.function".color = "#cba6f7";
            "keyword.operator".color = "#cba6f7";
            "keyword.import".color = "#cba6f7";
            "keyword.repeat".color = "#cba6f7";
            "keyword.return".color = "#cba6f7";
            "keyword.debug".color = "#cba6f7";
            "keyword.exception".color = "#cba6f7";
            "keyword.conditional".color = "#cba6f7";
            "keyword.conditional.ternary".color = "#cba6f7";
            "keyword.directive".color = "#f5c2e7";
            "keyword.directive.define".color = "#f5c2e7";
            "keyword.export".color = "#89dceb";
            punctuation.color = "#9399b2";
            "punctuation.delimiter".color = "#9399b2";
            "punctuation.bracket".color = "#9399b2";
            "punctuation.special".color = "#f5c2e7";
            "punctuation.special.symbol".color = "#f2cdcd";
            "punctuation.list_marker".color = "#94e2d5";
            comment.color = "#9399b2";
            "comment.doc".color = "#9399b2";
            "comment.documentation".color = "#9399b2";
            "comment.error".color = "#f38ba8";
            "comment.warning".color = "#f9e2af";
            "comment.hint".color = "#89b4fa";
            "comment.todo".color = "#f2cdcd";
            "comment.note".color = "#f5e0dc";
            "diff.plus".color = "#a6e3a1";
            "diff.minus".color = "#f38ba8";
            tag.color = "#89b4fa";
            "tag.attribute".color = "#f9e2af";
            "tag.delimiter".color = "#94e2d5";
            parameter.color = "#eba0ac";
            field.color = "#b4befe";
            namespace.color = "#f9e2af";
            float.color = "#fab387";
            symbol.color = "#f5c2e7";
            "string.regex".color = "#fab387";
            text.color = "#cdd6f4";
            "emphasis.strong".color = "#eba0ac";
            emphasis.color = "#eba0ac";
            embedded.color = "#eba0ac";
            "text.literal".color = "#a6e3a1";
            concept.color = "#74c7ec";
            enum.color = "#94e2d5";
            "function.decorator".color = "#fab387";
            "type.class.definition".color = "#f9e2af";
            hint.color = "#585b70";
            link_text.color = "#b4befe";
            link_uri.color = "#89b4fa";
            parent.color = "#fab387";
            predictive.color = "#6c7086";
            predoc.color = "#f38ba8";
            primary.color = "#eba0ac";
            "tag.doctype".color = "#cba6f7";
            "string.doc".color = "#94e2d5";
            title.color = "#cdd6f4";
            variant.color = "#f38ba8";
          };
        };
    }
  ];
}
