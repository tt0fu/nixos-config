import QtQuick
import Quickshell.Io

Rectangle {
    id: vpn
    implicitWidth: vpnText.implicitWidth + root.gap * 2
    implicitHeight: vpnText.implicitHeight + root.gap * 2

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius

    property bool enabled: false

    Process {
        id: vpnSwitchProc
        command: ["pkexec", "sh", "-c", "wg-quick down config || wg-quick up config"]
        stdout: SplitParser {
            onRead: data => {
                vpnDisplayProc.running = true;
            }
        }
        running: false
    }
    Process {
        id: vpnDisplayProc
        command: ["sh", "-c", "ip link show config > /dev/null 2> /dev/null; echo $?"]
        stdout: SplitParser {
            onRead: data => {
                vpn.enabled = parseInt(data) === 0;
            }
        }

        running: true
    }
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            vpnDisplayProc.running = true;
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            vpnSwitchProc.running = true;
            vpnDisplayProc.running = true;
        }
    }

    Text {
        id: vpnText
        color: root.colFg
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
        }
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "󰖂 " + (vpn.enabled ? "" : "")
    }
}
