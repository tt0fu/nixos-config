pragma ComponentBehavior: Bound

import qs
import "config"
import QtQuick

Item {
    id: trayMenu

    property var menuHandle: null
    property bool active: false

    signal closeRequested

    implicitWidth: menuList.implicitWidth
    implicitHeight: menuList.implicitHeight

    TrayMenuList {
        id: menuList
        anchors.fill: parent
        menuHandle: trayMenu.menuHandle
        onCloseRequested: trayMenu.closeRequested()
    }

    HoverHandler {
        id: menuHover
    }

    Timer {
        id: closeTimer

        interval: 5000
        repeat: false
        running: trayMenu.active && !menuHover.hovered

        onTriggered: trayMenu.closeRequested()
    }
}
