pragma ComponentBehavior: Bound

import "stylized"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

StylizedColumnLayout {
    id: connections

    required property PwNode node
    property bool sourceSide: false

    readonly property var linkGroups: Pipewire.linkGroups.values.filter(group => group.source && group.target && (group.source.id === connections.node.id || group.target.id === connections.node.id))

    Repeater {
        model: connections.linkGroups

        AudioConnection {
            required property PwLinkGroup modelData

            Layout.fillWidth: true
            node: connections.node
            linkGroup: modelData
        }
    }

    AudioConnectionCreator {
        Layout.fillWidth: true
        node: connections.node
        sourceSide: connections.sourceSide
    }
}
