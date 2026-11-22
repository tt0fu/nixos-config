pragma Singleton

import qs
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: audioPins

    property var pins: []
    property bool storeReady: false

    readonly property string configHome: {
        const xdg = Quickshell.env("XDG_CONFIG_HOME");
        if (xdg && xdg !== "")
            return xdg;
        const home = Quickshell.env("HOME");
        return home && home !== "" ? home + "/.config" : ".config";
    }
    readonly property string storeDir: audioPins.configHome + "/quickshell"
    readonly property string storePath: audioPins.storeDir + "/audio_connections.json"

    function sanitizeRef(ref) {
        if (!ref || typeof ref.name !== "string" || ref.name === "")
            return null;
        return {
            name: ref.name,
            mediaClass: typeof ref.mediaClass === "string" ? ref.mediaClass : "",
            description: typeof ref.description === "string" ? ref.description : ""
        };
    }

    function loadStore(text) {
        let data = null;
        try {
            data = JSON.parse(text);
        } catch (error) {
            console.warn("audio pins: failed to parse", audioPins.storePath);
            return;
        }
        const stored = data && Array.isArray(data.pins) ? data.pins : [];
        const pins = [];
        for (const pin of stored) {
            if (!pin)
                continue;
            const source = audioPins.sanitizeRef(pin.source);
            const target = audioPins.sanitizeRef(pin.target);
            if (source && target)
                pins.push({
                    source: source,
                    target: target
                });
        }
        audioPins.pins = pins;
    }

    function saveStore() {
        if (!audioPins.storeReady)
            return;
        store.setText(JSON.stringify({
            version: 1,
            pins: audioPins.pins
        }, null, 4));
    }

    FileView {
        id: store

        path: audioPins.storePath
        atomicWrites: true
        printErrors: false

        onLoaded: {
            audioPins.loadStore(store.text());
            audioPins.storeReady = true;
            audioPins.maintain();
        }
        onLoadFailed: error => {
            audioPins.storeReady = true;
            if (error !== FileViewError.FileNotFound)
                console.warn("audio pins: failed to load", FileViewError.toString(error));
        }
        onSaveFailed: error => console.warn("audio pins: failed to save", FileViewError.toString(error))
    }

    function mediaClass(node) {
        return node.properties["media.class"] || "";
    }

    function refOf(node) {
        return {
            name: node.name,
            mediaClass: audioPins.mediaClass(node),
            description: node.description
        };
    }

    function sameNode(ref, node) {
        return !!ref && !!node && ref.name === node.name && ref.mediaClass === audioPins.mediaClass(node);
    }

    function sameRefs(left, right) {
        return !!left && !!right && left.name === right.name && left.mediaClass === right.mediaClass;
    }

    function nodeFor(ref) {
        return Pipewire.nodes.values.find(node => audioPins.sameNode(ref, node)) || null;
    }

    function linkGroupFor(sourceRef, targetRef) {
        return Pipewire.linkGroups.values.find(group => group.source && group.target && audioPins.sameNode(sourceRef, group.source) && audioPins.sameNode(targetRef, group.target)) || null;
    }

    function pinFor(sourceRef, targetRef) {
        return audioPins.pins.find(pin => audioPins.sameRefs(pin.source, sourceRef) && audioPins.sameRefs(pin.target, targetRef)) || null;
    }

    function isPinned(sourceRef, targetRef) {
        return audioPins.pinFor(sourceRef, targetRef) !== null;
    }

    function pinsFor(node) {
        return audioPins.pins.filter(pin => audioPins.sameNode(pin.source, node) || audioPins.sameNode(pin.target, node));
    }

    function add(sourceNode, targetNode) {
        if (!sourceNode || !targetNode)
            return;
        const source = audioPins.refOf(sourceNode);
        const target = audioPins.refOf(targetNode);
        if (audioPins.pinFor(source, target))
            return;
        audioPins.pins = audioPins.pins.concat([
            {
                source: source,
                target: target
            }
        ]);
        audioPins.saveStore();
        audioPins.maintain();
    }

    function remove(pin) {
        if (!pin)
            return;
        audioPins.pins = audioPins.pins.filter(other => !(audioPins.sameRefs(other.source, pin.source) && audioPins.sameRefs(other.target, pin.target)));
        audioPins.saveStore();
    }

    function removeByRefs(sourceRef, targetRef) {
        const pin = audioPins.pinFor(sourceRef, targetRef);
        if (pin)
            audioPins.remove(pin);
    }

    function toggle(sourceNode, targetNode) {
        if (!sourceNode || !targetNode)
            return;
        const pin = audioPins.pinFor(audioPins.refOf(sourceNode), audioPins.refOf(targetNode));
        if (pin)
            audioPins.remove(pin);
        else
            audioPins.add(sourceNode, targetNode);
    }

    readonly property int missingCount: {
        let count = 0;
        for (const pin of audioPins.pins) {
            if (audioPins.linkGroupFor(pin.source, pin.target))
                continue;
            if (audioPins.nodeFor(pin.source) && audioPins.nodeFor(pin.target))
                count++;
        }
        return count;
    }

    function maintain() {
        for (const pin of audioPins.pins) {
            if (audioPins.linkGroupFor(pin.source, pin.target))
                continue;
            const sourceNode = audioPins.nodeFor(pin.source);
            const targetNode = audioPins.nodeFor(pin.target);
            if (!sourceNode || !targetNode)
                continue;
            if (AudioLinks.isPending(sourceNode.id, targetNode.id))
                continue;
            AudioLinks.connect(sourceNode.id, targetNode.id);
        }
    }

    Connections {
        target: Pipewire.nodes

        function onValuesChanged() {
            Qt.callLater(audioPins.maintain);
        }
    }

    Connections {
        target: Pipewire.linkGroups

        function onValuesChanged() {
            Qt.callLater(audioPins.maintain);
        }
    }

    Timer {
        interval: 2000
        repeat: true
        running: audioPins.missingCount > 0
        onTriggered: audioPins.maintain()
    }

    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", audioPins.storeDir]);
        Qt.callLater(audioPins.maintain);
    }
}
