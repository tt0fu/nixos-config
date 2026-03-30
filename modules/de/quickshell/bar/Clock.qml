import QtQuick
import "Oklab.js" as Oklab

PaddedRect {
    id: clock

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
    }

    child: CenterText {
        id: clockText
        text: Qt.formatDateTime(new Date(), "HH:mm:ss")
    }
}
