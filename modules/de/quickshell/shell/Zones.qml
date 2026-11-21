pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: zones

    readonly property var names: [
        "top",
        "top-left",
        "left",
        "bottom-left",
        "bottom",
        "bottom-right",
        "right",
        "top-right"
    ]

    property var owners: ({})

    signal evicted(string zone, var previousOwner)
    signal changed()

    function isValidZone(zone) {
        return zones.names.indexOf(zone) !== -1;
    }

    function owner(zone) {
        return owners[zone] !== undefined ? owners[zone] : null;
    }

    function isOccupied(zone) {
        return owner(zone) !== null;
    }

    function ownerZone(item) {
        for (const zone of zones.names) {
            if (owners[zone] === item)
                return zone;
        }
        return "";
    }

    function releaseAllFor(item) {
        let next = null;
        for (const zone of zones.names) {
            if (owners[zone] === item) {
                if (!next)
                    next = Object.assign({}, owners);
                delete next[zone];
            }
        }
        if (next) {
            owners = next;
            changed();
        }
    }

    function request(zone, item) {
        if (!isValidZone(zone) || !item)
            return false;

        if (owners[zone] === item)
            return true;

        releaseAllFor(item);

        const previousOwner = owner(zone);
        const next = Object.assign({}, owners);
        next[zone] = item;
        owners = next;
        changed();

        if (previousOwner && previousOwner !== item)
            evicted(zone, previousOwner);

        return true;
    }

    function release(zone, item) {
        if (owners[zone] !== item)
            return;
        const next = Object.assign({}, owners);
        delete next[zone];
        owners = next;
        changed();
    }

    function close(zone) {
        const item = owner(zone);
        if (!item)
            return;
        release(zone, item);
        evicted(zone, item);
    }

    function toggle(zone, item) {
        if (owner(zone) === item)
            release(zone, item);
        else
            request(zone, item);
    }
}
