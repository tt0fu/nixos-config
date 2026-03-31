import QtQuick
import Quickshell.Io

PaddedRect {
    id: network

    property string statusText: "󱞐"

    Process {
        id: networkStatusProc
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE dev | grep -q '^ethernet:connected' && echo \"\" || { s=$(nmcli -t -f IN-USE,SIGNAL dev wifi | awk -F: '$1==\"*\"{print $2}'); [ -n \"$s\" ] && echo \" $s%\" || echo \"󱞐\"; }"]
        stdout: SplitParser {
            onRead: data => statusText = data
        }
        running: true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: networkStatusProc.running = true
    }

    Process {
        id: nmguiProc
        command: ["nmgui"]
        running: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: nmguiProc.running = true
    }

    child: CenterText {
        id: statusDisplay
        text: statusText
    }
}
