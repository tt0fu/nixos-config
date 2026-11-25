pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: zones

    readonly property var names: ["top", "top-left", "left", "bottom-left", "bottom", "bottom-right", "right", "top-right"]

    property var owners: ({})
    property var waiting: ({})

    signal evicted(string zone, var previousOwner)
    signal changed

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
            handOver();
            changed();
        }
    }

    function handOver() {
        let nextOwners = null;
        let nextWaiting = null;
        for (const zone of zones.names) {
            const item = waiting[zone];
            if (!item || owners[zone] !== undefined)
                continue;
            if (!item.open)
                continue;
            nextOwners = nextOwners || Object.assign({}, owners);
            nextOwners[zone] = item;
            nextWaiting = nextWaiting || Object.assign({}, waiting);
            delete nextWaiting[zone];
        }
        if (nextOwners)
            owners = nextOwners;
        if (nextWaiting)
            waiting = nextWaiting;
    }

    function request(zone, item) {
        if (!isValidZone(zone) || !item)
            return false;

        if (owners[zone] === item) {
            if (waiting[zone] === item) {
                const nextWaiting = Object.assign({}, waiting);
                delete nextWaiting[zone];
                waiting = nextWaiting;
            }
            return true;
        }

        releaseAllFor(item);

        const previousOwner = owner(zone);
        if (previousOwner && previousOwner !== item) {
            const nextWaiting = Object.assign({}, waiting);
            nextWaiting[zone] = item;
            waiting = nextWaiting;
            evicted(zone, previousOwner);
            return true;
        }

        const next = Object.assign({}, owners);
        next[zone] = item;
        owners = next;
        changed();
        return true;
    }

    function release(zone, item) {
        if (owners[zone] !== item)
            return;
        const next = Object.assign({}, owners);
        delete next[zone];
        owners = next;
        handOver();
        changed();
    }

    function close(zone) {
        const item = owner(zone);
        if (!item)
            return;
        evicted(zone, item);
    }

    function toggle(zone, item) {
        if (owner(zone) === item)
            evicted(zone, item);
        else
            request(zone, item);
    }
}
