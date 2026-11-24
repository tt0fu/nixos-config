pragma Singleton

import QtQuick
import Quickshell
import "EnvStyle.js" as EnvStyle

Singleton {
    property string family: EnvStyle.string(Quickshell.env("QS_STYLE_FONT_FAMILY"), "JetBrainsMono Nerd Font Propo")
    property real size: EnvStyle.real(Quickshell.env("QS_STYLE_FONT_SIZE"), 15)
}
