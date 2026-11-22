pragma ComponentBehavior: Bound

import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "BorderPath.js" as BorderPath

ShellRoot {
    id: shellRoot

    property bool fakeLockActive: true

    function lockScreen() {
        if (GlobalState.locked) {
            return;
        }
        GlobalState.appLauncherOpened = false;
        GlobalState.clipboardOpened = false;
        GlobalState.notificationsShown = false;
        GlobalState.trayMenuOpened = false;
        GlobalState.clockDateShown = false;
        GlobalState.audioAdvancedOpened = false;
        lockContext.currentText = "";
        GlobalState.locked = true;
    }

    function unlockScreen() {
        if (!GlobalState.locked) {
            return;
        }
        fakeLockActive = true;
        completeUnlockTimer.start();
    }

    function onShellSlideFinished() {
        if (!GlobalState.locked) {
            return;
        }
        lock.locked = true;
        fakeLockDeactivationTimer.start();
    }

    Timer {
        id: fakeLockDeactivationTimer
        interval: 5
        onTriggered: shellRoot.fakeLockActive = false
    }

    Timer {
        id: completeUnlockTimer
        interval: 5
        onTriggered: {
            lock.locked = false;
            GlobalState.locked = false;
        }
    }

    LockContext {
        id: lockContext
        onUnlocked: shellRoot.unlockScreen()
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "lock"
        description: "Lock the screen"
        onPressed: shellRoot.lockScreen()
    }

    WlSessionLock {
        id: lock

        locked: false

        WlSessionLockSurface {
            color: Colors.background
            LockScreen {
                context: lockContext
                anchors.fill: parent
            }
        }
    }

    Component.onCompleted: {
        if (Date.now() - Quickshell.launchTime.getTime() < 2000 && !Quickshell.env("QS_SKIP_AUTOLOCK")) {
            shellRoot.lockScreen();
        }
    }

    PanelWindow {
        id: mainWindow

        property real topEdge: mainBar.implicitHeight
        property real leftEdge: 15
        property real rightEdge: 15
        property real bottomEdge: 15

        property var zoneHosts: [clipboardZone, launcherZone, notificationsZone, trayMenuZone, clockDateZone, audioAdvancedZone]
        property var zoneNotches: {
            const allOwners = Zones.owners;
            const vx0 = viewRect.x;
            const vy0 = viewRect.y;
            const vx1 = viewRect.x + viewRect.width;
            const vy1 = viewRect.y + viewRect.height;
            const result = [];

            for (const host of zoneHosts) {
                if (!host || host.zone === "" || !host.hasContent) {
                    continue;
                }
                
                const currentOwner = allOwners[host.zone];
                if (currentOwner !== undefined && currentOwner !== host) {
                    continue;
                }

                const x0 = host.x;
                const y0 = host.y;
                const x1 = host.x + host.width;
                const y1 = host.y + host.height;

                const overlapsX = x1 > vx0 + 0.5 && x0 < vx1 - 0.5;
                const overlapsY = y1 > vy0 + 0.5 && y0 < vy1 - 0.5;

                let active = false;
                switch (host.zone) {
                case "top":
                    active = overlapsX && y1 > vy0 + 0.5;
                    break;
                case "bottom":
                    active = overlapsX && y0 < vy1 - 0.5;
                    break;
                case "left":
                    active = overlapsY && x1 > vx0 + 0.5;
                    break;
                case "right":
                    active = overlapsY && x0 < vx1 - 0.5;
                    break;
                case "top-left":
                    active = x1 > vx0 + 0.5 && y1 > vy0 + 0.5;
                    break;
                case "top-right":
                    active = x0 < vx1 - 0.5 && y1 > vy0 + 0.5;
                    break;
                case "bottom-left":
                    active = x1 > vx0 + 0.5 && y0 < vy1 - 0.5;
                    break;
                case "bottom-right":
                    active = x0 < vx1 - 0.5 && y0 < vy1 - 0.5;
                    break;
                }

                result.push({
                    type: host.zone,
                    x0: x0,
                    y0: y0,
                    x1: x1,
                    y1: y1,
                    active: active
                });
            }
            return result;
        }

        color: "transparent"
        implicitWidth: screen.width
        implicitHeight: screen.height
        anchors.top: true
        exclusiveZone: topEdge
        WlrLayershell.keyboardFocus: (GlobalState.locked || GlobalState.appLauncherOpened || GlobalState.clipboardOpened) ? WlrKeyboardFocus.Exclusive : (GlobalState.notificationTextFieldHovered ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None)

        mask: Region {
            x: viewRect.x
            y: viewRect.y + shellContent.y
            width: viewRect.width
            height: viewRect.height
            intersection: Intersection.Subtract
            Region {
                item: clipboardZone
                intersection: Intersection.Subtract
            }
            Region {
                item: launcherZone
                intersection: Intersection.Subtract
            }
            Region {
                item: notificationsZone
                intersection: Intersection.Subtract
            }
            Region {
                item: trayMenuZone
                intersection: Intersection.Subtract
            }
            Region {
                item: clockDateZone
                intersection: Intersection.Subtract
            }
            Region {
                item: audioAdvancedZone
                intersection: Intersection.Subtract
            }
        }

        Item {
            id: shellContent
            width: mainWindow.width
            height: mainWindow.height
            y: GlobalState.locked ? mainWindow.height : 0
            Behavior on y {
                LongStylizedNumberAnimation {
                    onRunningChanged: {
                        if (!running) {
                            shellRoot.onShellSlideFinished();
                        }
                    }
                }
            }

            Rectangle {
                id: viewRect
                anchors {
                    fill: parent
                    topMargin: mainWindow.topEdge
                    bottomMargin: mainWindow.bottomEdge
                    leftMargin: mainWindow.leftEdge
                    rightMargin: mainWindow.rightEdge
                }
                visible: false
                radius: Sizes.borderRadius
            }
            ZoneHost {
                id: clipboardZone
                zone: "left"
                open: GlobalState.clipboardOpened
                viewX: viewRect.x
                viewY: viewRect.y
                viewWidth: viewRect.width
                viewHeight: viewRect.height
                screenWidth: mainWindow.width
                screenHeight: mainWindow.height
                onEvicted: GlobalState.clipboardOpened = false

                Clipboard {
                    id: clipboard
                    anchors.fill: parent
                }
            }

            ZoneHost {
                id: launcherZone
                zone: "bottom"
                open: GlobalState.appLauncherOpened
                viewX: viewRect.x
                viewY: viewRect.y
                viewWidth: viewRect.width
                viewHeight: viewRect.height
                screenWidth: mainWindow.width
                screenHeight: mainWindow.height
                onEvicted: GlobalState.appLauncherOpened = false

                Launcher {
                    id: launcher
                    anchors.fill: parent
                }
            }

            ZoneHost {
                id: notificationsZone
                zone: "bottom-right"
                open: GlobalState.notificationsShown
                viewX: viewRect.x
                viewY: viewRect.y
                viewWidth: viewRect.width
                viewHeight: viewRect.height
                screenWidth: mainWindow.width
                screenHeight: mainWindow.height
                onEvicted: GlobalState.notificationsShown = false

                Notifications {
                    id: notifications
                    anchors.fill: parent
                }
            }

            ZoneHost {
                id: clockDateZone
                zone: "top-right"
                open: GlobalState.clockDateShown
                viewX: viewRect.x
                viewY: viewRect.y - Sizes.gap
                viewWidth: viewRect.width
                viewHeight: viewRect.height
                screenWidth: mainWindow.width
                screenHeight: mainWindow.height
                onEvicted: GlobalState.clockDateShown = false

                ClockDate {
                    anchors.fill: parent
                }
            }

            ZoneHost {
                id: trayMenuZone
                zone: "top"
                open: GlobalState.trayMenuOpened && GlobalState.trayMenuHandle !== null
                hasAnchorX: true
                anchorX: GlobalState.trayMenuAnchorX
                viewX: viewRect.x
                viewY: viewRect.y - Sizes.gap
                viewWidth: viewRect.width
                viewHeight: viewRect.height
                screenWidth: mainWindow.width
                screenHeight: mainWindow.height
                onEvicted: GlobalState.trayMenuOpened = false

                TrayMenu {
                    id: trayMenu
                    anchors.fill: parent
                    menuHandle: GlobalState.trayMenuHandle
                    onCloseRequested: GlobalState.trayMenuOpened = false
                }
            }

            ZoneHost {
                id: audioAdvancedZone
                zone: "top"
                open: GlobalState.audioAdvancedOpened
                hasAnchorX: true
                anchorRight: true
                anchorX: GlobalState.audioAdvancedAnchorX
                viewX: viewRect.x
                viewY: viewRect.y - Sizes.gap
                viewWidth: viewRect.width
                viewHeight: viewRect.height
                screenWidth: mainWindow.width
                screenHeight: mainWindow.height
                onEvicted: GlobalState.audioAdvancedOpened = false

                AdvancedAudio {
                    anchors.fill: parent
                }
            }

            Shape {
                id: borderShape
                anchors.fill: parent

                property string outline: BorderPath.build(mainWindow.zoneNotches, {
                    x: viewRect.x,
                    y: viewRect.y,
                    width: viewRect.width,
                    height: viewRect.height
                }, Sizes.borderRadius)

                property string filled: BorderPath.fillPath(borderShape.outline, borderShape.width, borderShape.height)

                ShapePath {
                    fillColor: Colors.background
                    fillRule: ShapePath.OddEvenFill
                    strokeWidth: -1

                    PathSvg {
                        path: borderShape.filled
                    }
                }

                ShapePath {
                    fillColor: "transparent"
                    strokeWidth: Sizes.borderWidth

                    PathSvg {
                        path: borderShape.outline
                    }
                }
            }

            MainBar {
                id: mainBar
            }

            Rectangle {
                id: fakeLock
                visible: shellRoot.fakeLockActive
                width: mainWindow.width
                height: mainWindow.height
                color: Colors.background
                y: -mainWindow.height
                LockScreen {
                    anchors.fill: parent
                    context: lockContext
                }
            }
        }
    }

    Scope {
        PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            exclusiveZone: mainWindow.leftEdge
            anchors.left: true
        }
        PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            exclusiveZone: mainWindow.rightEdge
            anchors.right: true
        }
        PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            exclusiveZone: mainWindow.bottomEdge
            anchors.bottom: true
        }
    }
}
