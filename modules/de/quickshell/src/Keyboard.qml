import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

Rectangle {
    id: keyboard
    implicitWidth: keyboardText.implicitWidth + root.gap * 2
    implicitHeight: keyboardText.implicitHeight + root.gap * 2

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius

    property string layout: "EN"

    Component.onCompleted: {
        Hyprland.rawEvent.connect(event => {
            if (event.name === "activelayout") {
                keyboard.layout = event.data.split(",")[1].trim().substr(0, 2).toUpperCase();
            }
        });
    }

    Process {
        id: keyboardSwitchProc
        command: ["hyprctl", "switchxkblayout", "main", "next"]
        running: false
    }
    MouseArea {
        anchors.fill: parent
        onClicked: keyboardSwitchProc.running = true
    }

    Text {
        id: keyboardText
        color: root.colFg
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
        }
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: keyboard.layout
    }
}
