pragma ComponentBehavior: Bound

import qs
import "stylized"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

StylizedColumnLayout {
    id: connections

    required property PwNode node
    property bool sourceSide: false

    readonly property var linkGroups: Pipewire.linkGroups.values.filter(group => group.source && group.target && (group.source.id === connections.node.id || group.target.id === connections.node.id))
    readonly property var missingPins: AudioPins.pinsFor(connections.node).filter(pin => !AudioPins.linkGroupFor(pin.source, pin.target))

    Repeater {
        model: connections.linkGroups

        AudioConnection {
            required property PwLinkGroup modelData

            Layout.fillWidth: true
            node: connections.node
            linkGroup: modelData
        }
    }

    Repeater {
        model: connections.missingPins

        AudioConnection {
            required property var modelData

            Layout.fillWidth: true
            node: connections.node
            pin: modelData
        }
    }

    AudioConnectionCreator {
        Layout.fillWidth: true
        node: connections.node
        sourceSide: connections.sourceSide
    }
}
