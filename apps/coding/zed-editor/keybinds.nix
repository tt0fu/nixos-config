[
  {
    bindings = {
      down = "menu::SelectNext";
      up = "menu::SelectPrevious";
      enter = "menu::Confirm";
      escape = "menu::Cancel";

      open = "workspace::Open";
      ctrl-o = "workspace::Open";
      ctrl-alt-o = "projects::OpenRecent";
    };
  }
  {
    context = "Editor";
    bindings = {
      escape = "editor::Cancel";
      shift-backspace = "editor::Backspace";
      backspace = "editor::Backspace";
      delete = "editor::Delete";

      shift-enter = "editor::Newline";
      enter = "editor::Newline";
      ctrl-enter = "editor::NewlineBelow";
      ctrl-shift-enter = "editor::NewlineAbove";

      find = "buffer_search::Deploy";
      ctrl-f = "buffer_search::Deploy";
      ctrl-r = "buffer_search::DeployReplace";

      tab = "editor::Tab";
      shift-tab = "editor::Backtab";

      ctrl-backspace = "editor::DeleteToPreviousWordStart";
      ctrl-delete = "editor::DeleteToNextWordEnd";

      cut = "editor::Cut";
      shift-delete = "editor::Cut";
      ctrl-x = "editor::Cut";

      copy = "editor::Copy";
      ctrl-c = "editor::Copy";

      paste = "editor::Paste";
      ctrl-v = "editor::Paste";

      undo = "editor::Undo";
      ctrl-z = "editor::Undo";

      redo = "editor::Redo";
      ctrl-shift-z = "editor::Redo";

      up = "editor::MoveUp";
      down = "editor::MoveDown";

      ctrl-up = "editor::LineUp";
      ctrl-down = "editor::LineDown";

      pageup = "editor::MovePageUp";
      pagedown = "editor::MovePageDown";

      home = "editor::MoveToBeginningOfLine";
      end = "editor::MoveToEndOfLine";

      left = "editor::MoveLeft";
      right = "editor::MoveRight";

      ctrl-left = "editor::MoveToPreviousWordStart";
      ctrl-right = "editor::MoveToNextWordEnd";

      ctrl-home = "editor::MoveToBeginning";
      ctrl-end = "editor::MoveToEnd";

      shift-up = "editor::SelectUp";
      shift-down = "editor::SelectDown";
      shift-left = "editor::SelectLeft";
      shift-right = "editor::SelectRight";

      ctrl-shift-left = "editor::SelectToPreviousWordStart";
      ctrl-shift-right = "editor::SelectToNextWordEnd";

      ctrl-shift-home = "editor::SelectToBeginning";
      ctrl-shift-end = "editor::SelectToEnd";

      shift-home = "editor::SelectToBeginningOfLine";
      shift-end = "editor::SelectToEndOfLine";

      ctrl-a = "editor::SelectAll";
      ctrl-l = "editor::SelectLine";
      ctrl-y = "editor::DeleteLine";

      ctrl-shift-i = "editor::Format";
      alt-shift-o = "editor::OrganizeImports";
    };
  }
  {
    context = "Terminal";
    bindings = {
      copy = "terminal::Copy";
      ctrl-shift-c = "terminal::Copy";

      paste = "terminal::Paste";
      ctrl-shift-v = "terminal::Paste";

      alt-b = [
        "terminal::SendText"
        "\u001bb"
      ];
      alt-f = [
        "terminal::SendText"
        "\u001bf"
      ];
      "alt-." = [
        "terminal::SendText"
        "\u001b."
      ];
      ctrl-delete = [
        "terminal::SendText"
        "\u001bd"
      ];
      ctrl-b = [
        "terminal::SendKeystroke"
        "ctrl-b"
      ];
      ctrl-c = [
        "terminal::SendKeystroke"
        "ctrl-c"
      ];
      ctrl-e = [
        "terminal::SendKeystroke"
        "ctrl-e"
      ];
      ctrl-o = [
        "terminal::SendKeystroke"
        "ctrl-o"
      ];
      ctrl-w = [
        "terminal::SendKeystroke"
        "ctrl-w"
      ];
      ctrl-backspace = [
        "terminal::SendKeystroke"
        "ctrl-w"
      ];

      ctrl-shift-a = "editor::SelectAll";

      find = "buffer_search::Deploy";
      ctrl-shift-f = "buffer_search::Deploy";

      ctrl-shift-l = "terminal::Clear";
      up = [
        "terminal::SendKeystroke"
        "up"
      ];
      pageup = [
        "terminal::SendKeystroke"
        "pageup"
      ];
      down = [
        "terminal::SendKeystroke"
        "down"
      ];
      pagedown = [
        "terminal::SendKeystroke"
        "pagedown"
      ];
      escape = [
        "terminal::SendKeystroke"
        "escape"
      ];
      enter = [
        "terminal::SendKeystroke"
        "enter"
      ];

      shift-pageup = "terminal::ScrollPageUp";
      shift-pagedown = "terminal::ScrollPageDown";

      shift-up = "terminal::ScrollLineUp";
      shift-down = "terminal::ScrollLineDown";

      shift-home = "terminal::ScrollToTop";
      shift-end = "terminal::ScrollToBottom";
    };
  }
  {
    context = "Workspace";
    bindings = {
      save = "workspace::Save";
      ctrl-s = "workspace::Save";

      shift-save = "workspace::SaveAs";
      ctrl-shift-s = "workspace::SaveAs";

      new = "workspace::NewFile";
      ctrl-n = "workspace::NewFile";

      shift-new = "workspace::NewWindow";
      ctrl-shift-n = "workspace::NewWindow";

      ctrl-alt-b = "workspace::ToggleRightDock";
      ctrl-b = "workspace::ToggleLeftDock";
      ctrl-j = "workspace::ToggleBottomDock";

      shift-find = "pane::DeploySearch";
      ctrl-shift-f = "pane::DeploySearch";
      ctrl-shift-r = [
        "pane::DeploySearch"
        {
          replace_enabled = true;
        }
      ];

      ctrl-t = "file_finder::Toggle";
      ctrl-shift-t = "pane::ReopenClosedItem";

      ctrl-tab = "tab_switcher::Toggle";
      ctrl-shift-tab = [
        "tab_switcher::Toggle"
        {
          select_last = true;
        }
      ];

      ctrl-shift-w = "editor::ToggleFocus";
      ctrl-shift-q = "terminal_panel::ToggleFocus";
      ctrl-shift-e = "project_panel::ToggleFocus";
      ctrl-shift-g = "git_panel::ToggleFocus";

      alt-save = "workspace::SaveAll";
      ctrl-alt-s = "workspace::SaveAll";
    };
  }
]
