import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Pipewire

StylizedRowLayout {
    id: advancedAudio

    property real columnWidth: 400
    property real maxColumnHeight: 600

    readonly property var sourceNodes: Pipewire.nodes.values.filter(node => AudioNode.sends(node))
    readonly property var sinkNodes: Pipewire.nodes.values.filter(node => AudioNode.receives(node))

    PwObjectTracker {
        objects: Pipewire.nodes.values.concat(Pipewire.links.values)
    }

    anchors.margins: Sizes.gap

    Component.onCompleted: AudioPins.maintain()

    ScrollView {
        id: sourceScroll

        implicitWidth: advancedAudio.columnWidth
        implicitHeight: Math.min(sourceList.implicitHeight, advancedAudio.maxColumnHeight)
        contentWidth: availableWidth
        Layout.alignment: Qt.AlignTop
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        StylizedColumnLayout {
            id: sourceList
            width: sourceScroll.availableWidth
            Repeater {
                model: advancedAudio.sourceNodes
                AudioDevice {
                    required property PwNode modelData
                    Layout.fillWidth: true
                    node: modelData
                    sourceSide: true
                }
            }
        }
    }

    ScrollView {
        id: sinkScroll

        implicitWidth: advancedAudio.columnWidth
        implicitHeight: Math.min(sinkList.implicitHeight, advancedAudio.maxColumnHeight)
        contentWidth: availableWidth
        Layout.alignment: Qt.AlignTop
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        StylizedColumnLayout {
            id: sinkList
            width: sinkScroll.availableWidth

            Repeater {
                model: advancedAudio.sinkNodes
                AudioDevice {
                    required property PwNode modelData
                    Layout.fillWidth: true
                    node: modelData
                }
            }
        }
    }
}
