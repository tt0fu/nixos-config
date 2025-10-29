{
  name = "en-us_full";
  row_size = 23;
  key_sizes = [
    [
      1.5
      0.5
      1
      1
      1
      1
      0.5
      1
      1
      1
      1
      0.5
      1
      1
      1
      1
      0.5
      1
      1
      1
      0.5
      1
      1
      1
      1
    ]
    [
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      2
      0.5
      1
      1
      1
      0.5
      1
      1
      1
      1
    ]
    [
      1.5
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1.5
      0.5
      1
      1
      1
      0.5
      1
      1
      1
      1
    ]
    [
      1.75
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      2.25
      4
      1
      1
      1
      1
    ]
    [
      1.25
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      1
      2.75
      1.5
      1
      1.5
      1
      1
      1
      1
    ]
    [
      1.25
      1.25
      1.25
      6.25
      1.25
      1.25
      1.25
      1.25
      0.5
      1
      1
      1
      0.5
      2
      1
      1
    ]
  ];
  main_layout = [
    [
      "Escape"
      "~"
      "F1"
      "F2"
      "F3"
      "F4"
      "~"
      "F5"
      "F6"
      "F7"
      "F8"
      "~"
      "F9"
      "F10"
      "F11"
      "F12"
      "~"
      "Print"
      "Scroll"
      "Pause"
      "~"
      "COPY"
      "PASTE"
      "~"
      "KILL"
    ]
    [
      "Oem3"
      "N1"
      "N2"
      "N3"
      "N4"
      "N5"
      "N6"
      "N7"
      "N8"
      "N9"
      "N0"
      "Minus"
      "Plus"
      "BackSpace"
      "~"
      "Insert"
      "Home"
      "Prior"
      "~"
      "NumLock"
      "KP_Divide"
      "KP_Multiply"
      "KP_Subtract"
    ]
    [
      "Tab"
      "Q"
      "W"
      "E"
      "R"
      "T"
      "Y"
      "U"
      "I"
      "O"
      "P"
      "Oem4"
      "Oem6"
      "Oem5"
      "~"
      "Delete"
      "End"
      "Next"
      "~"
      "KP_7"
      "KP_8"
      "KP_9"
      "KP_Add"
    ]
    [
      "XF86Favorites"
      "A"
      "S"
      "D"
      "F"
      "G"
      "H"
      "J"
      "K"
      "L"
      "Oem1"
      "Oem7"
      "Return"
      "~"
      "KP_4"
      "KP_5"
      "KP_6"
      "~"
    ]
    [
      "LShift"
      "Oem102"
      "Z"
      "X"
      "C"
      "V"
      "B"
      "N"
      "M"
      "Comma"
      "Period"
      "Oem2"
      "RShift"
      "~"
      "Up"
      "~"
      "KP_1"
      "KP_2"
      "KP_3"
      "KP_Enter"
    ]
    [
      "LCtrl"
      "LSuper"
      "LAlt"
      "Space"
      "Meta"
      "RSuper"
      "Menu"
      "RCtrl"
      "~"
      "Left"
      "Down"
      "Right"
      "~"
      "KP_0"
      "KP_Decimal"
      "~"
    ]
  ];
  alt_modifier = "None";
  exec_commands = {
    STT = [
      "whisper_stt"
      "--lang"
      "en"
    ];
  };
  macros = {
    KILL = [
      "LSuper DOWN"
      "Escape"
      "LCtrl UP"
      "LSuper UP"
    ];
    COPY = [
      "LCtrl DOWN"
      "C"
      "LCtrl UP"
    ];
    PASTE = [
      "LCtrl DOWN"
      "V"
      "LCtrl UP"
    ];
  };
  labels = {
    Escape = [
      "Esc"
    ];
    Prior = [
      "PgUp"
    ];
    Next = [
      "PgDn"
    ];
    NumLock = [
      "Num"
    ];
    Space = [

    ];
    LAlt = [
      "Alt"
    ];
    LCtrl = [
      "Ctrl"
    ];
    RCtrl = [
      "Ctrl"
    ];
    LSuper = [
      "Super"
    ];
    RSuper = [
      "Super"
    ];
    LShift = [
      "Shift"
    ];
    RShift = [
      "Shift"
    ];
    Insert = [
      "Ins"
    ];
    Delete = [
      "Del"
    ];
    BackSpace = [
      "<<"
    ];
    KP_Divide = [
      " /"
    ];
    KP_Add = [
      " +"
    ];
    KP_Multiply = [
      " *"
    ];
    KP_Decimal = [
      " ."
    ];
    KP_Subtract = [
      " -"
    ];
    KP_Enter = [
      "Ent"
    ];
    Print = [
      "Prn"
    ];
    Scroll = [
      "Scr"
    ];
    Pause = [
      "Brk"
    ];
    XF86Favorites = [
      "Menu"
    ];
    N1 = [
      "1"
      "!"
    ];
    N2 = [
      "2"
      "@"
    ];
    N3 = [
      "3"
      "#"
    ];
    N4 = [
      "4"
      "$"
    ];
    N5 = [
      "5"
      "%"
    ];
    N6 = [
      "6"
      "^"
    ];
    N7 = [
      "7"
      "&"
    ];
    N8 = [
      "8"
      "*"
    ];
    N9 = [
      "9"
      "("
    ];
    N0 = [
      "0"
      ")"
    ];
    Minus = [
      "-"
      "_"
    ];
    Plus = [
      "="
      "+"
    ];
    Comma = [
      " ,"
      "<"
    ];
    Period = [
      " ."
      ">"
    ];
    Oem1 = [
      " ;"
      ":"
    ];
    Oem2 = [
      " /"
      "?"
    ];
    Oem3 = [
      "`"
      "~"
    ];
    Oem4 = [
      " ["
      "{"
    ];
    Oem5 = [
      " \\"
      "|"
    ];
    Oem6 = [
      " ]"
      "}"
    ];
    Oem7 = [
      " '"
      "\""
    ];
    Oem102 = [
      " \\"
      "|"
    ];
  };
}
