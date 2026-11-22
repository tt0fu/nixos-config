pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: audioNode

    function sends(node) {
        if (!node || (node.type & PwNodeType.Audio) === 0)
            return false;
        if (node.isStream)
            return node.isSink;
        return (node.type & PwNodeType.Source) !== 0;
    }

    function receives(node) {
        if (!node || (node.type & PwNodeType.Audio) === 0)
            return false;
        if (node.isStream)
            return !node.isSink;
        return (node.type & PwNodeType.Sink) !== 0;
    }

    function isConnected(node, other) {
        return Pipewire.linkGroups.values.some(group => group.source && group.target && ((group.source.id === node.id && group.target.id === other.id) || (group.target.id === node.id && group.source.id === other.id)));
    }

    function candidates(node, sourceSide) {
        return Pipewire.nodes.values.filter(other => {
            if (!node || !other || other.id === node.id)
                return false;
            if (sourceSide ? !audioNode.receives(other) : !audioNode.sends(other))
                return false;
            return !audioNode.isConnected(node, other);
        });
    }
}
