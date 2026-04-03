import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
    id: workspaces
    anchors.centerIn: parent

    property Item targetItem: workspacesRepeater.itemAt(Hyprland.workspaces.values.findIndex(w => w.focused)) ?? workspacesLayout

    implicitWidth: workspacesLayout.implicitWidth * 2 - Math.min(workspacesRepeater.itemAt(0).implicitWidth, workspacesRepeater.itemAt(workspacesRepeater.count - 1).implicitWidth)
    implicitHeight: workspacesLayout.implicitHeight

    RowLayout {
        id: workspacesLayout
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: (workspacesLayout.width - targetItem.width) / 2 - targetItem.mapToItem(workspacesLayout, 0, 0).x
        spacing: root.gap

        Behavior on anchors.horizontalCenterOffset {
            MyNumberAnimation {}
        }


        Repeater {
            id: workspacesRepeater

            // model: 9
            model: Hyprland.workspaces

            PaddedRect {
                id: workspaceRect
                level: 1

                // required property int index
                // property HyprlandWorkspace workspace: Hyprland.workspaces.values.find(w => w.id === index + 1) ?? null
                // property string name: index + 1

                required property HyprlandWorkspace modelData
                property HyprlandWorkspace workspace: modelData
                property string name: workspace.id

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
                            Hyprland.dispatch("workspace " + name);
                        }
                        if (event.buttons & Qt.RightButton) {
                            Hyprland.dispatch("movetoworkspace " + name);
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
                        text: name
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
                Behavior on implicitWidth {
                    MyNumberAnimation {}
                }
            }
        }
    }

    onTargetItemChanged: {
        selectionRect.animateSize = true;
        Qt.callLater(() => selectionRect.animateSize = false);
    }

    MyRect {
        id: selectionRect
        level: 1

        anchors.centerIn: parent
        z: 1
        border.color: Hyprland.focusedWorkspace.urgent ? root.colUrgent : root.colBorder

        width: targetItem.width
        height: targetItem.height

        property bool animateSize: false

        Behavior on border.color {
            MyColorAnimation {}
        }
        Behavior on width {
            enabled: selectionRect.animateSize
            MyNumberAnimation {}
        }
        Behavior on height {
            enabled: selectionRect.animateSize
            MyNumberAnimation {}
        }
    }
}
