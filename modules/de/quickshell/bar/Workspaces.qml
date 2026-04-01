import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PaddedRect {
    id: workspaces

    child: RowLayout {
        id: workspacesLayout
        anchors.fill: parent
        anchors.margins: root.gap
        spacing: root.gap

        Repeater {
            id: workspacesRepeater
            model: 9

            PaddedRect {
                id: workspaceRect
                required property int index
                property HyprlandWorkspace workspace: Hyprland.workspaces.values.find(w => w.id === index + 1) ?? null
                property bool isUrgent: workspace ? workspace.urgent : false
                property var topLevels: workspace ? workspace.toplevels : []

                border.color: isUrgent ? root.colUrgent : (workspaceMouseArea.containsMouse ? root.colHover : root.colInactive)

                z: 0

                MouseArea {
                    id: workspaceMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.AllButtons
                    onPressed: event => {
                        if (event.buttons & Qt.LeftButton) {
                            Hyprland.dispatch("workspace " + (index + 1))
                        }
                        if (event.buttons & Qt.RightButton) {
                            Hyprland.dispatch("movetoworkspace " + (index + 1))
                        }
                    }
                }

                child: RowLayout {
                    id: workspaceLayout
                    anchors.fill: parent
                    anchors.margins: root.gap
                    spacing: root.gap

                    CenterText {
                        id: workspaceText
                        anchors.fill: null
                        text: index + 1
                    }

                    Repeater {
                        model: topLevels

                        Image {
                            required property HyprlandToplevel modelData
                            property string path: Quickshell.iconPath(DesktopEntries.heuristicLookup(modelData.wayland?.appId ?? "")?.icon ?? "", true)

                            source: path === "" ? Qt.resolvedUrl("fallback-icon.svg") : path
                            sourceSize.width: root.iconSize
                            sourceSize.height: root.iconSize
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: selectionRect
        z: 1
        color: "transparent"
        border.color: Hyprland.focusedWorkspace.urgent ? root.colUrgent : root.colBorder
        border.width: root.borderWidth
        radius: root.borderRadius

        property Item targetItem: workspacesRepeater.itemAt(Hyprland.focusedWorkspace.id - 1) ?? workspaces
        property rect targetRect: targetItem.mapToItem(workspaces, 0, 0, targetItem.width, targetItem.height)

        x: targetRect.x
        y: targetRect.y
        width: targetRect.width
        height: targetRect.height

        Behavior on border.color {
            ColorAnimation {
                duration: root.animationDuration
            }
        }
        Behavior on x {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
