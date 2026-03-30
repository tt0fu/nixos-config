import QtQuick

PaddedRect {
    id: test

    MouseArea {
        id: testMouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    child: CenterText {
        id: testText
        text: "test"
        color: testMouseArea.containsMouse ? "green" : "red"

        Behavior on color {
            ColorAnimation {
                duration: root.animationDuration
            }
        }
    }
}
