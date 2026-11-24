import qs
import "stylized"
import QtQuick
import Quickshell

StylizedPaddedRectangle {
    id: clock
    level: 0

    SystemClock {
        id: systemClock
        precision: SystemClock.Seconds
    }

    child: StylizedCenterText {
        anchors.fill: parent
        id: clockText
        text: Qt.formatDateTime(systemClock.date, "HH:mm:ss")
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: GlobalState.clockDateShown = true
        onExited: GlobalState.clockDateShown = false
    }

    Behavior on implicitWidth {
        StylizedNumberAnimation {}
    }
}
