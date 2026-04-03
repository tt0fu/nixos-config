pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

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
        property int borderRadius: 15
        property int gap: 6
        property real edgeWidth: 10

        property string fontFamily: "JetBrainsMono Nerd Font Propo"
        property int fontSize: 15

        property int iconSize: 20

        property int animationDuration: 100
        property var easingType: Easing.InOutQuad

        implicitWidth: screen.width
        implicitHeight: screen.height
        exclusiveZone: bar.height

        mask: Region {
            item: bar
        }
        color: "transparent"

        anchors.top: true

        // BackgroundEffect.blurRegion: Region {
        //     item: bar
        // }

        Rectangle {
            color: root.colBg
            anchors.fill: parent

            layer.enabled: true

            layer.effect: MultiEffect {
                maskEnabled: true
                maskInverted: true

                maskSource: mask

                maskThresholdMin: 0.5
                maskSpreadAtMin: 1
            }

            Item {
                id: mask

                layer.enabled: true
                visible: false

                anchors.fill: parent

                Rectangle {
                    id: maskRect
                    radius: root.borderRadius

                    anchors.fill: parent
                    anchors.margins: root.edgeWidth
                    anchors.topMargin: bar.height
                }
            }
        }

        MyRect {
            x: maskRect.x
            y: maskRect.y
            width: maskRect.width
            height: maskRect.height
            antialiasing: false
        }

        Item {
            id: bar
            anchors {
                left: parent.left
                right: parent.right
                rightMargin: root.gap
                leftMargin: root.gap
            }
            implicitHeight: Math.max(leftRow.implicitHeight, workspaces.implicitHeight, rightRow.implicitHeight) + root.gap * 2

            RowLayout {
                id: leftRow
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
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
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: root.gap

                AudioSink {}

                AudioSource {}

                Network {}

                Power {}

                Clock {}
            }
        }
    }

    Scope {
        Exclusion {
            anchors.left: true
        }
        Exclusion {
            anchors.right: true
        }
        Exclusion {
            anchors.bottom: true
        }
    }

    component Exclusion: PanelWindow {
        implicitWidth: 0
        implicitHeight: 0
        exclusiveZone: root.edgeWidth
    }
}
