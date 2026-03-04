import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    // Theme
    property color colBg: "#01000000"
    property color borderCol: "white"
    property int borderWidth: 2
    property int borderRadius: 10
    property color colFg: "white"
    property color colMuted: "#808080"
    property string fontFamily: "JetBrainsMono Nerd Font Propo"
    property int fontSize: 20

    // System data
    property int cpuUsage: 0
    property int memUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    // Processes and timers here...
    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;
                memUsage = Math.round(100 * used / total);
            }
        }
        Component.onCompleted: running = true
    }
    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var p = data.trim().split(/\s+/);
                var idle = parseInt(p[4]) + parseInt(p[5]);
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                if (lastCpuTotal > 0) {
                    cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)));
                }
                lastCpuTotal = total;
                lastCpuIdle = idle;
            }
        }
        Component.onCompleted: running = true
    }

    // Update your timer to run both processes
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
        }
    }

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 50
    color: "transparent"

    Rectangle {
        // match the size of the window
        anchors.fill: parent

        radius: root.borderRadius
        color: root.colBg // your actual color
        border.color: root.borderCol
        border.width: root.borderWidth

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            // Workspaces
            Repeater {
                model: 9
                Text {
                    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    text: index + 1
                    color: isActive ? root.colFg : (ws ? root.colFg : root.colMuted)
                    font {
                        family: root.fontFamily
                        pixelSize: root.fontSize
                        bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            // CPU
            Text {
                text: "CPU: " + cpuUsage + "%"
                color: root.colFg
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                }
            }

            Rectangle {
                width: 1
                height: 16
                color: root.colMuted
            }

            // Memory
            Text {
                text: "Mem: " + memUsage + "%"
                color: root.colFg
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                }
            }

            Rectangle {
                width: 1
                height: 16
                color: root.colMuted
            }

            // Clock
            Text {
                id: clock
                // radius: 5
                // border.color: "white"
                color: root.colFg
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                }
                text: Qt.formatDateTime(new Date(), "HH:mm:ss")
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
                }
            }
        }
    }
}
