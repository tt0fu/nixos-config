pragma ComponentBehavior: Bound

import qs
import "config"
import QtQuick

Item {
    id: trayMenu

    property var menuHandle: null

    signal closeRequested

    readonly property bool active: GlobalState.trayMenuOpened
    readonly property int autoCloseDelay: 5000

    property bool hasHovered: false

    implicitWidth: menuList.implicitWidth
    implicitHeight: menuList.implicitHeight

    TrayMenuList {
        id: menuList
        anchors.fill: parent
        menuHandle: trayMenu.menuHandle
        onCloseRequested: trayMenu.closeRequested()
    }

    onActiveChanged: {
        if (active) {
            hasHovered = false;
            closeTimer.interval = trayMenu.autoCloseDelay;
            closeTimer.restart();
        } else {
            closeTimer.stop();
        }
    }

    onMenuHandleChanged: {
        if (active) {
            hasHovered = false;
            closeTimer.interval = trayMenu.autoCloseDelay;
            closeTimer.restart();
        }
    }

    Component.onCompleted: {
        if (active) {
            hasHovered = false;
            closeTimer.interval = trayMenu.autoCloseDelay;
            closeTimer.restart();
        }
    }

    HoverHandler {
        id: menuHover

        onHoveredChanged: {
            if (hovered) {
                hasHovered = true;
                closeTimer.stop();
            } else if (hasHovered && GlobalState.trayMenuOpened) {
                closeTimer.interval = 500;
                closeTimer.restart();
            }
        }
    }

    Timer {
        id: closeTimer
        repeat: false
        onTriggered: {
            if (!menuHover.hovered) {
                trayMenu.closeRequested();
            }
        }
    }
}
