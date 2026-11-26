pragma Singleton

import QtQuick
import Quickshell
import "EnvStyle.js" as EnvStyle

Singleton {
    property real borderWidth: EnvStyle.real(Quickshell.env("QS_STYLE_BORDER_WIDTH"), 2)
    property real borderRadius: EnvStyle.real(Quickshell.env("QS_STYLE_BORDER_RADIUS"), 10)
    property real gap: EnvStyle.real(Quickshell.env("QS_STYLE_SPACING"), 6)

    property real iconSize: EnvStyle.real(Quickshell.env("QS_STYLE_ICONSIZE"), 20)

    function radiusFor(level) {
        return borderRadius - level * gap;
    }
}
