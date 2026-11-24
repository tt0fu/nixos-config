pragma ComponentBehavior: Bound

import qs
import "config"
import "stylized"
import "AudioIcon.js" as AudioIcon
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire

StylizedPaddedRectangle {
    id: connection

    required property PwNode node

    property var linkGroup: null
    property var pin: null

    level: 3

    visible: connection.linkGroup !== null || connection.pin !== null

    opacity: connection.live ? 1 : 0.6
    border.color: connection.live ? Colors.border : Colors.muted

    readonly property bool live: connection.linkGroup !== null
    readonly property var sourceRef: connection.live ? AudioPins.refOf(connection.linkGroup.source) : (connection.pin ? connection.pin.source : null)
    readonly property var targetRef: connection.live ? AudioPins.refOf(connection.linkGroup.target) : (connection.pin ? connection.pin.target : null)
    readonly property bool isSource: connection.live ? connection.linkGroup.source === connection.node : (connection.pin ? AudioPins.sameNode(connection.pin.source, connection.node) : false)
    readonly property bool pinned: AudioPins.isPinned(connection.sourceRef, connection.targetRef)

    readonly property string otherName: {
        if (connection.live)
            return connection.isSource ? (connection.linkGroup.target.description || connection.linkGroup.target.name) : (connection.linkGroup.source.description || connection.linkGroup.source.name);
        if (!connection.pin)
            return "";
        if (connection.isSource)
            return connection.pin.target.description || connection.pin.target.name;
        return connection.pin.source.description || connection.pin.source.name;
    }

    readonly property var links: {
        if (!connection.live || !connection.linkGroup.source || !connection.linkGroup.target)
            return [];
        const source = connection.linkGroup.source;
        const target = connection.linkGroup.target;
        return Pipewire.links.values.filter(link => link.source && link.target && link.source.id === source.id && link.target.id === target.id);
    }
    readonly property string stateText: connection.live ? connection.formatStates(connection.links.map(link => PwLinkState.toString(link.state))) : "unlinked"

    readonly property var propertyRows: {
        if (!connection.live) {
            const pin = connection.pin;
            if (!pin)
                return [];
            return [
                {
                    label: "state",
                    value: "unlinked"
                },
                {
                    label: "source.name",
                    value: pin.source.name
                },
                {
                    label: "source.media.class",
                    value: pin.source.mediaClass
                },
                {
                    label: "source.description",
                    value: pin.source.description
                },
                {
                    label: "target.name",
                    value: pin.target.name
                },
                {
                    label: "target.media.class",
                    value: pin.target.mediaClass
                },
                {
                    label: "target.description",
                    value: pin.target.description
                }
            ].filter(row => row.value !== "");
        }

        const group = connection.linkGroup;
        if (!group || !group.source || !group.target)
            return [];
        const source = group.source;
        const target = group.target;
        const rows = [
            {
                label: "direction",
                value: connection.isSource ? "sends" : "receives"
            },
            {
                label: "state",
                value: connection.stateText
            },
            {
                label: "links",
                value: String(connection.links.length)
            },
            {
                label: "link.states",
                value: connection.links.map(link => link.id + "=" + PwLinkState.toString(link.state)).join(", ")
            },
            {
                label: "source.id",
                value: String(source.id)
            },
            {
                label: "source.name",
                value: source.name
            },
            {
                label: "source.description",
                value: source.description
            },
            {
                label: "source.nickname",
                value: source.nickname
            },
            {
                label: "source.type",
                value: PwNodeType.toString(source.type)
            },
            {
                label: "source.media.class",
                value: source.properties["media.class"] || ""
            },
            {
                label: "target.id",
                value: String(target.id)
            },
            {
                label: "target.name",
                value: target.name
            },
            {
                label: "target.description",
                value: target.description
            },
            {
                label: "target.nickname",
                value: target.nickname
            },
            {
                label: "target.type",
                value: PwNodeType.toString(target.type)
            },
            {
                label: "target.media.class",
                value: target.properties["media.class"] || ""
            }
        ];
        return rows.filter(row => row.value !== "");
    }

    function formatStates(states) {
        const unique = states.filter((state, index) => states.indexOf(state) === index);
        return unique.length > 0 ? unique.join(", ") : "unknown";
    }

    function togglePin() {
        if (connection.live)
            AudioPins.toggle(connection.linkGroup.source, connection.linkGroup.target);
        else
            AudioPins.remove(connection.pin);
    }

    function deleteConnection() {
        if (connection.live)
            AudioPins.removeByRefs(connection.sourceRef, connection.targetRef);
        else
            AudioPins.remove(connection.pin);
        const ids = connection.links.map(link => link.id);
        if (ids.length === 0)
            return;
        deleteProcess.command = ["sh", "-c", ids.map(id => "pw-cli destroy " + id).join("; ")];
        deleteProcess.running = true;
    }

    Process {
        id: deleteProcess
        running: false
    }

    child: StylizedColumnLayout {
        anchors.fill: parent
        anchors.margins: Sizes.gap

        StylizedRowLayout {
            Layout.fillWidth: true

            StylizedText {
                Layout.fillWidth: true
                text: connection.otherName
                color: connection.live ? Colors.foreground : Colors.muted
                wrapMode: Text.Wrap
            }

            Item {
                Layout.alignment: Qt.AlignTop
                implicitWidth: Sizes.iconSize
                implicitHeight: Sizes.iconSize

                StylizedCenterText {
                    anchors.fill: parent
                    text: AudioIcon.pin
                    color: pinMouseArea.containsMouse ? Colors.hover : (connection.pinned ? Colors.foreground : Colors.muted)
                }

                MouseArea {
                    id: pinMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: connection.togglePin()
                }
            }

            Item {
                Layout.alignment: Qt.AlignTop
                implicitWidth: Sizes.iconSize
                implicitHeight: Sizes.iconSize

                StylizedCenterText {
                    anchors.fill: parent
                    text: AudioIcon.cross
                    color: deleteMouseArea.containsMouse ? Colors.hover : Colors.muted
                }

                MouseArea {
                    id: deleteMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: connection.deleteConnection()
                }
            }
        }

        StylizedDisclosure {
            id: propertiesToggle

            Layout.fillWidth: true
            title: "properties"
        }

        StylizedColumnLayout {
            Layout.fillWidth: true
            visible: propertiesToggle.expanded

            Repeater {
                model: connection.propertyRows

                StylizedKeyValueRow {
                    required property var modelData

                    Layout.fillWidth: true
                    label: modelData.label
                    value: modelData.value
                }
            }
        }
    }
}
