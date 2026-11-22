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

    required property PwLinkGroup linkGroup
    required property PwNode node

    level: 2

    visible: connection.linkGroup !== null

    readonly property bool isSource: connection.linkGroup ? connection.linkGroup.source === connection.node : false
    readonly property var otherNode: connection.linkGroup ? (connection.isSource ? connection.linkGroup.target : connection.linkGroup.source) : null
    readonly property string otherName: connection.otherNode ? (connection.otherNode.description || connection.otherNode.name) : ""

    readonly property var links: {
        const group = connection.linkGroup;
        if (!group || !group.source || !group.target)
            return [];
        return Pipewire.links.values.filter(link => link.source && link.target && link.source.id === group.source.id && link.target.id === group.target.id);
    }
    readonly property string stateText: connection.formatStates(connection.links.map(link => PwLinkState.toString(link.state)))

    readonly property var propertyRows: {
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

    function deleteConnection() {
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
                wrapMode: Text.Wrap
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
