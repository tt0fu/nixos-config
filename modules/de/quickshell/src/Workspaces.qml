import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PaddedRect {
    id: workspaces
    anchors.centerIn: parent

    child: RowLayout {
        id: workspacesLayout
        anchors.fill: parent
        anchors.margins: root.gap
        spacing: root.gap

        Repeater {
            model: 9

            PaddedRect {
                id: workspace
                required property int index;
                property var currentWorkspace: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property var workspaceClients: isNonEmpty ? currentWorkspace.toplevels.values : []
                property bool isNonEmpty: currentWorkspace ? true : false
                property bool isActive: isNonEmpty ? currentWorkspace.active : false
                property bool isUrgent: isNonEmpty ? currentWorkspace.urgent : false
                property bool isHover: workspaceMouseArea.containsMouse

                border.color: isUrgent ? root.colUrgent : (isActive ? root.colActive : (isHover ? root.colHover : root.colInactive))
                visible: isNonEmpty

                MouseArea {
                    id: workspaceMouseArea
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    hoverEnabled: true
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
                        model: workspace.workspaceClients

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
}
