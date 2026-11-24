import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
    id: workspaces
    anchors.centerIn: parent

    readonly property int focusedWorkspaceId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1

    property int targetIndex: -1

    readonly property Item targetItem: {
        const id = focusedWorkspaceId;
        if (id < 0 || targetIndex < 0 || targetIndex >= workspacesRepeater.count)
            return null;
        const item = workspacesRepeater.itemAt(targetIndex);
        if (!item || !item.modelData || item.modelData.id !== id)
            return null;
        return item;
    }

    property real targetWidth: 0
    property real targetHeight: 0

    readonly property real targetX: {
        const item = targetItem;
        if (item && (targetIndex === 0 || item.x > 0))
            return item.x;

        let x = 0;
        const count = Math.min(targetIndex, workspacesRepeater.count);
        for (let i = 0; i < count; ++i) {
            const preceding = workspacesRepeater.itemAt(i);
            x += (preceding ? preceding.width : 0) + workspacesLayout.spacing;
        }
        return x;
    }

    readonly property real targetOffset: (workspacesLayout.width - targetWidth) / 2 - targetX

    function refreshTarget() {
        const focused = Hyprland.focusedWorkspace;
        if (!focused)
            return;

        const index = Hyprland.workspaces.values.findIndex(w => w && w.id === focused.id);
        if (index >= 0)
            targetIndex = index;
    }

    function updateTargetSize() {
        if (!targetItem)
            return;
        if (targetItem.width > 0)
            targetWidth = targetItem.width;
        if (targetItem.height > 0)
            targetHeight = targetItem.height;
    }

    implicitWidth: workspacesLayout.implicitWidth * 2 - Math.min(workspacesRepeater.itemAt(0)?.implicitWidth ?? 0, workspacesRepeater.itemAt(workspacesRepeater.count - 1)?.implicitWidth ?? 0)
    implicitHeight: workspacesLayout.implicitHeight

    Component.onCompleted: refreshTarget()

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            workspaces.refreshTarget();
        }
    }

    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            workspaces.refreshTarget();
        }
    }

    onTargetItemChanged: {
        updateTargetSize();
        selectionRect.animateSize = true;
        Qt.callLater(() => selectionRect.animateSize = false);
    }

    Connections {
        target: workspaces.targetItem
        function onWidthChanged() {
            workspaces.updateTargetSize();
        }
        function onHeightChanged() {
            workspaces.updateTargetSize();
        }
    }

    StylizedRowLayout {
        id: workspacesLayout
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: workspaces.targetOffset

        Behavior on anchors.horizontalCenterOffset {
            StylizedNumberAnimation {}
        }

        Repeater {
            id: workspacesRepeater

            // model: 9
            model: Hyprland.workspaces

            StylizedPaddedRectangle {
                id: workspaceRect
                level: 0

                // required property int index
                // property HyprlandWorkspace workspace: Hyprland.workspaces.values.find(w => w.id === index + 1) ?? null
                // property string name: index + 1

                required property HyprlandWorkspace modelData

                property bool isUrgent: modelData ? modelData.urgent : false
                property var topLevels: modelData ? modelData.toplevels : []

                border.color: isUrgent ? Colors.urgent : (workspaceMouseArea.containsMouse ? Colors.hover : Colors.inactive)

                z: 0

                MouseArea {
                    id: workspaceMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.AllButtons
                    onPressed: event => {
                        if (event.buttons & Qt.LeftButton) {
                            workspaceRect.modelData.activate();
                        }
                        if (event.buttons & Qt.RightButton) {
                            Hyprland.dispatch("hl.dsp.window.move({ workspace = " + workspaceRect.modelData.name + " })");
                        }
                    }
                }

                child: StylizedRowLayout {
                    id: workspaceLayout
                    anchors.fill: parent
                    anchors.margins: Sizes.gap

                    StylizedCenterText {
                        id: workspaceText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: workspaceRect.modelData.name
                    }

                    Repeater {
                        model: workspaceRect.topLevels

                        Image {
                            required property HyprlandToplevel modelData
                            property string path: Quickshell.iconPath(DesktopEntries.heuristicLookup(modelData.wayland?.appId ?? "")?.icon ?? "", true)

                            source: path === "" ? Qt.resolvedUrl("fallback-icon.svg") : path
                            sourceSize.width: Sizes.iconSize
                            sourceSize.height: Sizes.iconSize
                        }
                    }
                }
                Behavior on implicitWidth {
                    StylizedNumberAnimation {}
                }
            }
        }
    }

    StylizedRectangle {
        id: selectionRect
        level: 0

        anchors.centerIn: parent
        z: 1
        border.color: (Hyprland.focusedWorkspace?.urgent ?? false) ? Colors.urgent : Colors.border

        width: workspaces.targetWidth
        height: workspaces.targetHeight

        property bool animateSize: false

        Behavior on width {
            enabled: selectionRect.animateSize
            StylizedNumberAnimation {}
        }
        Behavior on height {
            enabled: selectionRect.animateSize
            StylizedNumberAnimation {}
        }
    }
}
