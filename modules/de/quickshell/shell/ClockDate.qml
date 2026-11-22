import "stylized"
import QtQuick
import Quickshell

StylizedText {
    anchors.fill: parent
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: Qt.formatDateTime(systemClock.date, "dddd, d MMMM, yyyy")

    SystemClock {
        id: systemClock
        precision: SystemClock.Hours
    }
}
