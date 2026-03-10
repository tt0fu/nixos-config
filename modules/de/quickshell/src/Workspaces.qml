import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    id: workspaces
    implicitWidth: workspacesLayout.implicitWidth + root.gap * 2
    implicitHeight: workspacesLayout.implicitHeight + root.gap * 2
    anchors.centerIn: parent

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius

    RowLayout {
        id: workspacesLayout
        anchors.fill: parent
        anchors.margins: root.gap
        spacing: root.gap

        Repeater {
            model: 9

            Rectangle {
                id: workspace
                color: "transparent"
                border.width: root.borderWidth
                radius: root.borderRadius

                property var currentWorkspace: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property var workspaceClients: isNonEmpty ? currentWorkspace.toplevels.values : []
                property bool isNonEmpty: currentWorkspace ? true : false
                property bool isActive: isNonEmpty ? currentWorkspace.active : false
                property bool isUrgent: isNonEmpty ? currentWorkspace.urgent : false
                property bool isHover: workspaceMouseArea.containsMouse

                border.color: isUrgent ? root.colUrgent : (isActive ? root.colActive : (isHover ? root.colHover : root.colInactive))
                visible: isNonEmpty

                implicitWidth: workspaceLayout.implicitWidth + root.gap * 2
                implicitHeight: workspaceLayout.implicitHeight + root.gap * 2
                MouseArea {
                    id: workspaceMouseArea
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    hoverEnabled: true
                }

                RowLayout {
                    id: workspaceLayout
                    anchors.fill: parent
                    anchors.margins: root.gap
                    spacing: root.gap

                    Text {
                        id: workspaceText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: index + 1
                        color: root.colFg
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                        }
                    }

                    Repeater {
                        model: workspace.workspaceClients

                        Image {
                            required property HyprlandToplevel modelData
                            property string path: Quickshell.iconPath(DesktopEntries.heuristicLookup(modelData.wayland?.appId ?? "")?.icon ?? "", true)

                            source: path === "" ? Qt.resolvedUrl("fallback-icon.svg") : path
                            sourceSize.width: root.iconSize
                            sourceSize.height: root.iconSize
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }
        }
    }
}
