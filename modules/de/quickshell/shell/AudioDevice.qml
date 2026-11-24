pragma ComponentBehavior: Bound

import qs
import "config"
import "stylized"
import "AudioIcon.js" as AudioIcon
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

StylizedPaddedRectangle {
    id: device

    required property PwNode node

    property bool sourceSide: false

    level: 2

    readonly property var nodeAudio: device.node.audio
    readonly property bool canBeDefault: device.nodeAudio !== null && !device.node.isStream
    readonly property bool isDefault: device.sourceSide ? Pipewire.defaultAudioSource === device.node : Pipewire.defaultAudioSink === device.node
    readonly property string muteIcon: device.nodeAudio ? (device.node.isSink ? AudioIcon.sink(device.nodeAudio.volume, device.nodeAudio.muted) : AudioIcon.source(device.nodeAudio.muted)) : ""

    function setVolume(volume) {
        if (device.nodeAudio)
            device.nodeAudio.volume = volume;
    }

    function toggleMute() {
        if (device.nodeAudio)
            device.nodeAudio.muted = !device.nodeAudio.muted;
    }

    function makeDefault() {
        if (device.sourceSide)
            Pipewire.preferredDefaultAudioSource = device.node;
        else
            Pipewire.preferredDefaultAudioSink = device.node;
    }

    child: StylizedColumnLayout {
        anchors.fill: parent
        anchors.margins: Sizes.gap

        StylizedText {
            Layout.fillWidth: true
            text: device.node.description || device.node.name
            wrapMode: Text.Wrap
        }

        StylizedRowLayout {
            Layout.fillWidth: true
            visible: device.nodeAudio !== null

            StylizedSlider {
                id: volumeSlider
                Layout.fillWidth: true
                from: 0
                to: 1.5
                step: 0.05
                value: device.nodeAudio ? device.nodeAudio.volume : 0
                onMoved: volume => device.setVolume(volume)
            }

            StylizedText {
                verticalAlignment: Text.AlignVCenter
                text: Math.round(volumeSlider.shownValue * 100) + "%"
            }

            StylizedCenterText {
                Layout.preferredWidth: Sizes.iconSize
                Layout.preferredHeight: Sizes.iconSize
                text: device.muteIcon
                color: muteMouseArea.containsMouse ? Colors.hover : Colors.foreground
                MouseArea {
                    id: muteMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: device.toggleMute()
                }
            }

            StylizedCenterText {
                Layout.preferredWidth: Sizes.iconSize
                Layout.preferredHeight: Sizes.iconSize
                visible: device.canBeDefault
                text: device.isDefault ? AudioIcon.check : AudioIcon.cross
                color: defaultMouseArea.containsMouse ? Colors.hover : (device.isDefault ? Colors.foreground : Colors.muted)
                MouseArea {
                    id: defaultMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: device.makeDefault()
                }
            }
        }

        StylizedDisclosure {
            id: connectionsToggle

            Layout.fillWidth: true
            title: "connections"
        }

        Loader {
            Layout.fillWidth: true
            active: connectionsToggle.expanded
            visible: active
            sourceComponent: connectionsComponent
        }

        StylizedDisclosure {
            id: detailsToggle

            Layout.fillWidth: true
            title: "properties"
        }

        Loader {
            Layout.fillWidth: true
            active: detailsToggle.expanded
            visible: active
            sourceComponent: detailsComponent
        }
    }

    Component {
        id: connectionsComponent

        AudioConnections {
            node: device.node
            sourceSide: device.sourceSide
        }
    }

    Component {
        id: detailsComponent

        AudioDeviceDetails {
            node: device.node
        }
    }
}
