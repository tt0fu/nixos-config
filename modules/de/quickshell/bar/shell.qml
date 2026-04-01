import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

ShellRoot {
    PanelWindow {
        id: root

        property color colBg: "#01000000"
        property color colFg: "white"
        property color colBorder: "white"
        property color colMuted: "#808080"

        property color colActive: "white"
        property color colInactive: "#808080"
        property color colHover: "#b0b0b0"
        property color colUrgent: "#ff6060"

        property int borderWidth: 2
        property int borderRadius: 10
        property int gap: 5

        property string fontFamily: "JetBrainsMono Nerd Font Propo"
        property int fontSize: 15

        property int iconSize: 20

        property int animationDuration: 100

        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: barLayout.implicitHeight
        color: "transparent"

        Rectangle {
            id: windowRect
            color: root.colBg
            border.color: root.colBorder
            border.width: root.borderWidth
            radius: root.borderRadius

            anchors.fill: parent

            Item {
                id: barLayout
                anchors.fill: parent
                anchors.margins: root.gap
                implicitHeight: Math.max(leftRow.implicitHeight, workspaces.implicitHeight, rightRow.implicitHeight) + root.gap * 2

                RowLayout {
                    id: leftRow
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: root.gap

                    Keyboard {}

                    Vpn {}

                    Tray {}

                    // Test {}
                }

                Workspaces {
                    id: workspaces
                    anchors.centerIn: parent
                }

                RowLayout {
                    id: rightRow
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: root.gap

                    AudioSink {}

                    AudioSource {}

                    Network {}

                    Power {}

                    Clock {}
                }
            }
        }
    }
}
