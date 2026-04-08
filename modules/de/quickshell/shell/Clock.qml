import "stylized"
import QtQuick
import Quickshell

StylizedPaddedRectangle {
    id: clock
    level: 1

    SystemClock {
        id: systemClock
        precision: SystemClock.Seconds
    }

    child: StylizedCenterText {
        anchors.fill: parent
        id: clockText
        text: Qt.formatDateTime(systemClock.date, "HH:mm:ss")
    }

    Behavior on implicitWidth {
        StylizedNumberAnimation {}
    }
}
