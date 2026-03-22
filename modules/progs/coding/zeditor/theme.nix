color: {
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

          palette =
            n: lightness: chroma:
            map color.toHex (color.palette n lightness chroma);
          paletteTransparent =
            n: lightness: chroma: transparency:
            map color.toHex (color.paletteTransparent n lightness chroma transparency);

          mainBg = blackTransparent 0.0; # blackTransparent 0.8;
          substituteBg = gray 0.06;

          background = paletteTransparent 8 0.5 0.1 0.5;
          regular = palette 8 0.75 0.1;
          accent = palette 8 0.9 0.1;
          syntax = palette 8 0.75 0.15;

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
          "background.appearance" = "transparent";

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

            # <div foo="bar">
            #      ^^^
            attribute.color = yellow syntax;

            # bool flag = true;
            #             ^^^^
            boolean.color = mint syntax;

            # foo = bar; // comment
            #            ^^^^^^^^^^
            comment.color = gray 0.5;

            # /**
            #  * Some documentation
            #  */
            # ^^^^^^^^^^^^^^^^^^^^^
            comment.doc.color = gray 0.75;

            # Const int FOO = 42;
            #           ^^^
            constant.color = blue syntax;

            # String foo = null;
            #              ^^^^
            constant.builtin.color = blue syntax;

            # Foo foo = new Foo();
            #               ^^^
            constructor.color = orange syntax;

            # <script>alert('hello')</script>
            #         ^^^^^^^^^^^^^^
            embedded.color = gray 0.8;

            # this text is *italic*
            #              ^^^^^^^^
            emphasis = {
              color = gray 0.8;
              font_style = "italic";
            };

            # this text is *bold*
            #              ^^^^^^
            emphasis.strong = {
              color = gray 0.8;
              font_weight = 700;
            };

            # enum Foo { BAR, BAZ };
            #      ^^^
            enum.color = orange syntax;

            # void foo() { ... }
            #      ^^^
            function.color = orange syntax;

            # /*@__PURE__*/ foo();
            # ^^^^^^^^^^^^^
            hint.color = lavender syntax;

            # if (foo == bar) { ... }
            # ^^
            keyword.color = red syntax;

            # start: goto start;
            # ^^^^^
            label.color = orange syntax;

            # [example](https://example.com)
            #  ^^^^^^^
            link_text.color = gray 0.8;

            # [example](https://example.com)
            #           ^^^^^^^^^^^^^^^^^^^
            link_uri.color = lavender syntax;

            # int foo = 42;
            #           ^^
            number.color = mint syntax;

            # int foo = bar + baz;
            #         ^     ^
            operator.color = red syntax;

            # # @predictive
            #   ^^^^^^^^^^^
            predictive.color = lavender syntax;

            # #include<iostream>
            # ^^^^^^^^^^^^^^^^^^
            preproc.color = lavender syntax;

            # int a = b + c
            #         ^
            primary.color = mint syntax;

            # foo.bar = 42;
            #     ^^^
            property.color = yellow syntax;

            # int foo = 42;
            #             ^
            punctuation.color = red syntax;

            # if (foo == bar) { ... }
            #    ^          ^ ^     ^
            punctuation.bracket.color = red syntax;

            # int arr[] = {1, 2, 3};
            #               ^  ^
            punctuation.delimiter.color = red syntax;

            # foo
            # - bar
            # - baz
            # ^
            punctuation.list_marker.color = red syntax;

            # `code`
            # ^    ^
            punctuation.special.color = red syntax;

            # String foo = "bar"
            #              ^^^^^
            string.color = green syntax;

            # print("hello \n world")
            #              ^^
            string.escape.color = mint syntax;

            # foo.match(/.*d*/)
            #           ^^^^^^
            string.regex.color = green syntax;

            # f"Hello {name}"
            # ^^^^^^^^^^^^^^^
            string.special.color = mint syntax;

            # :symbol
            # ^^^^^^^
            string.special.symbol.color = mint syntax;

            # <div foo="bar">
            #  ^^^
            tag.color = orange syntax;

            # <!DOCTYPE html>
            # ^^^^^^^^^^^^^^^
            tag.doctype.color = orange syntax;

            # This is regular text.
            # ^^^^^^^^^^^^^^^^^^^^^
            text.literal.color = gray 0.8;

            # # Title
            #   ^^^^^
            title.color = mint syntax;

            # MyType foo = new MyType();
            # ^^^^^^
            type.color = orange syntax;

            # int foo = 42
            # ^^^
            type.builtin.color = orange syntax;

            # int foo = 42;
            #     ^^^
            variable.color = yellow syntax;

            # this.foo = 42;
            # ^^^^
            variable.special.color = orange syntax;

            # void foo(int bar)
            #              ^^^
            variable.parameter.color = yellow syntax;

            # enum Foo { Bar(int), Baz(String) };
            #            ^^^       ^^^
            variant.color = blue syntax;
          };
        };
    }
  ];
}
