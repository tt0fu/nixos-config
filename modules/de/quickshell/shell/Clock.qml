import QtQuick
import Quickshell

PaddedRect {
    id: clock
    level: 1

    SystemClock {
        id: systemClock
        precision: SystemClock.Seconds
    }

    child: CenterText {
        id: clockText
        text: Qt.formatDateTime(systemClock.date, "HH:mm:ss")
    }

    Behavior on implicitWidth {
        MyNumberAnimation {}
    }
}
