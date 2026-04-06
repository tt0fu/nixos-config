import QtQuick
import Quickshell.Io

PaddedRect {
    id: vpn
    level: 1

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

    child: CenterText {
        id: vpnText
        text: "󰖂 " + (vpn.enabled ? "" : "")
    }

    Behavior on implicitWidth {
        MyNumberAnimation {}
    }
}
