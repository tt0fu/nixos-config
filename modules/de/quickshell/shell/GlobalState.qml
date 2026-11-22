pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool notificationTextFieldHovered: false
    property bool notificationsShown: true
    property bool appLauncherOpened: false
    property bool clipboardOpened: false
    property bool locked: false

    property bool trayMenuOpened: false
    property var trayMenuHandle: null
    property var trayMenuOwner: null
    property real trayMenuAnchorX: 0

    property bool clockDateShown: false

    property bool audioAdvancedOpened: false
    property real audioAdvancedAnchorX: 0
}
