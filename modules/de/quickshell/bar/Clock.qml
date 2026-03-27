import QtQuick

PaddedRect {
    id: clock

    child: CenterText {
        id: clockText
        text: Qt.formatDateTime(new Date(), "HH:mm:ss")

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
        }
    }
}
