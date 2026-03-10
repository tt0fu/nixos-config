import QtQuick

Rectangle {
    id: clock

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius

    implicitWidth: clockText.implicitWidth + root.gap * 2
    implicitHeight: clockText.implicitHeight + root.gap * 2

    Text {
        id: clockText
        color: root.colFg
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
        }
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: Qt.formatDateTime(new Date(), "HH:mm:ss")

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
        }
    }
}
