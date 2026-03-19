import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

PaddedRect {
    id: keyboard
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

    child: CenterText {
        id: keyboardText
        text: keyboard.layout
    }
}
