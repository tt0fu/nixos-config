pragma ComponentBehavior: Bound

import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire

StylizedPaddedRectangle {
    id: creator

    required property PwNode node
    property bool sourceSide: false

    level: 2

    property int pendingId: -1

    readonly property var candidates: AudioNode.candidates(creator.node, creator.sourceSide)

    function createConnection(nodeId) {
        creator.pendingId = nodeId;
        dumpProcess.running = true;
    }

    function createLinks(dumpText) {
        const pendingId = creator.pendingId;
        creator.pendingId = -1;
        if (pendingId < 0 || !Pipewire.nodes.values.some(other => other.id === pendingId))
            return;

        let objects = null;
        try {
            objects = JSON.parse(dumpText);
        } catch (error) {
            return;
        }

        const sourceNodeId = creator.sourceSide ? creator.node.id : pendingId;
        const targetNodeId = creator.sourceSide ? pendingId : creator.node.id;
        const sourcePorts = creator.portsOf(objects, sourceNodeId, "out");
        const targetPorts = creator.portsOf(objects, targetNodeId, "in");

        const commands = [];
        for (const sourcePort of sourcePorts) {
            let targetPort = targetPorts.find(port => port.channel !== "" && port.channel === sourcePort.channel);
            if (!targetPort)
                targetPort = targetPorts.find(port => port.id === sourcePort.id);
            if (targetPort)
                commands.push("pw-cli create-link " + sourceNodeId + " " + sourcePort.id + " " + targetNodeId + " " + targetPort.id + " '{ object.linger = true }'");
        }
        if (commands.length === 0)
            return;

        linkProcess.command = ["sh", "-c", commands.join("; ")];
        linkProcess.running = true;
        selector.expanded = false;
    }

    function portDirection(info) {
        const properties = info.props || {};
        const direction = properties["port.direction"] || info.direction || "";
        if (direction === "in" || direction === "input")
            return "in";
        if (direction === "out" || direction === "output")
            return "out";
        return "";
    }

    function portsOf(objects, nodeId, direction) {
        const ports = [];
        for (const object of objects) {
            if (object.type !== "PipeWire:Interface:Port")
                continue;
            const info = object.info;
            if (!info || !info.props)
                continue;
            const properties = info.props;
            if (properties["node.id"] !== nodeId || properties["port.monitor"])
                continue;
            if (creator.portDirection(info) !== direction)
                continue;
            ports.push({
                id: properties["port.id"],
                channel: properties["audio.channel"] || ""
            });
        }
        return ports;
    }

    Process {
        id: dumpProcess
        command: ["pw-dump"]
        running: false

        stdout: StdioCollector {
            id: dumpCollector
            onStreamFinished: creator.createLinks(dumpCollector.text)
        }
    }

    Process {
        id: linkProcess
        running: false
    }

    child: StylizedColumnLayout {
        anchors.fill: parent
        anchors.margins: Sizes.gap

        StylizedDisclosure {
            id: selector

            Layout.fillWidth: true
            title: "Add a connection"
        }

        StylizedColumnLayout {
            Layout.fillWidth: true
            visible: selector.expanded

            Repeater {
                model: creator.candidates

                Item {
                    id: candidate

                    required property PwNode modelData

                    Layout.fillWidth: true
                    implicitHeight: candidateRow.implicitHeight

                    StylizedRowLayout {
                        id: candidateRow
                        anchors.fill: parent

                        StylizedText {
                            Layout.fillWidth: true
                            text: candidate.modelData.description || candidate.modelData.name
                            color: candidateMouseArea.containsMouse ? Colors.hover : Colors.foreground
                            wrapMode: Text.Wrap
                        }

                        StylizedText {
                            color: Colors.muted
                            text: PwNodeType.toString(candidate.modelData.type)
                        }
                    }

                    MouseArea {
                        id: candidateMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: creator.createConnection(candidate.modelData.id)
                    }
                }
            }

            StylizedText {
                Layout.fillWidth: true
                visible: creator.candidates.length === 0
                color: Colors.muted
                text: "none"
            }
        }
    }
}
