pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: audioLinks

    property var current: null
    property var queue: []

    function connect(sourceNodeId, targetNodeId) {
        if (sourceNodeId < 0 || targetNodeId < 0 || sourceNodeId === targetNodeId)
            return;
        audioLinks.queue = audioLinks.queue.concat([[sourceNodeId, targetNodeId]]);
        audioLinks.next();
    }

    function isPending(sourceNodeId, targetNodeId) {
        if (audioLinks.current !== null && audioLinks.current[0] === sourceNodeId && audioLinks.current[1] === targetNodeId)
            return true;
        return audioLinks.queue.some(request => request[0] === sourceNodeId && request[1] === targetNodeId);
    }

    function next() {
        if (audioLinks.current !== null || audioLinks.queue.length === 0)
            return;
        const queue = audioLinks.queue.slice();
        audioLinks.current = queue[0];
        audioLinks.queue = queue.slice(1);
        dumpProcess.running = true;
    }

    function finish() {
        audioLinks.current = null;
        Qt.callLater(audioLinks.next);
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
            if (audioLinks.portDirection(info) !== direction)
                continue;
            ports.push({
                id: properties["port.id"],
                channel: properties["audio.channel"] || ""
            });
        }
        return ports;
    }

    function createLinks(dumpText) {
        const request = audioLinks.current;
        let objects = null;
        try {
            objects = JSON.parse(dumpText);
        } catch (error) {
            audioLinks.finish();
            return;
        }
        if (!request) {
            audioLinks.finish();
            return;
        }

        const sourceNodeId = request[0];
        const targetNodeId = request[1];
        const sourcePorts = audioLinks.portsOf(objects, sourceNodeId, "out");
        const targetPorts = audioLinks.portsOf(objects, targetNodeId, "in");

        const commands = [];
        for (const sourcePort of sourcePorts) {
            let targetPort = targetPorts.find(port => port.channel !== "" && port.channel === sourcePort.channel);
            if (!targetPort)
                targetPort = targetPorts.find(port => port.id === sourcePort.id);
            if (targetPort)
                commands.push("pw-cli create-link " + sourceNodeId + " " + sourcePort.id + " " + targetNodeId + " " + targetPort.id + " '{ object.linger = true }'");
        }
        if (commands.length === 0) {
            audioLinks.finish();
            return;
        }

        linkProcess.command = ["sh", "-c", commands.join("; ")];
        linkProcess.running = true;
    }

    Process {
        id: dumpProcess
        command: ["pw-dump"]
        running: false

        stdout: StdioCollector {
            id: dumpCollector
            onStreamFinished: audioLinks.createLinks(dumpCollector.text)
        }
    }

    Process {
        id: linkProcess
        running: false

        onRunningChanged: {
            if (!linkProcess.running && audioLinks.current !== null)
                audioLinks.finish();
        }
    }
}
