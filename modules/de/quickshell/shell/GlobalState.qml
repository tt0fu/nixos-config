pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool notificationTextFieldHovered: false
    property bool notificationsShown: true
    property bool appLauncherOpened: false
    property bool clipboardOpened: false
    property bool locked: false

    property var trayMenuOwner: null
    readonly property bool trayMenuOpened: trayMenuOwner !== null
    property var trayMenuAnchors: ({})

    function setTrayMenuAnchor(item, anchor) {
        if (!item)
            return;
        const next = Object.assign({}, trayMenuAnchors);
        next[item.id] = anchor;
        trayMenuAnchors = next;
    }

    function trayMenuAnchorFor(item) {
        return item && trayMenuAnchors[item.id] !== undefined ? trayMenuAnchors[item.id] : 0;
    }

    property bool clockDateShown: false

    property bool audioAdvancedOpened: false
    property real audioAdvancedAnchorX: 0
}
