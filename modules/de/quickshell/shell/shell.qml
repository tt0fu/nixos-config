pragma ComponentBehavior: Bound

import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.SystemTray
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

        property var trayHosts: []
        property var zoneHosts: [clipboardZone, launcherZone, notificationsZone, clockDateZone, audioAdvancedZone].concat(trayHosts)
        property var activeTrayHost: GlobalState.trayMenuOwner ? activeTrayHostFor(GlobalState.trayMenuOwner) : null

        function registerTrayHost(host) {
            trayHosts = trayHosts.concat([host]);
        }

        function unregisterTrayHost(host) {
            trayHosts = trayHosts.filter(h => h !== host);
        }

        function activeTrayHostFor(item) {
            return trayHosts.find(h => h.trayItem === item) || null;
        }
        property var zoneNotches: {
            const allOwners = Zones.owners;
            const vx0 = viewRect.x;
            const vy0 = viewRect.y;
            const vx1 = viewRect.x + viewRect.width;
            const vy1 = viewRect.y + viewRect.height;
            const result = [];

            for (const host of zoneHosts) {
                if (!host) {
                    continue;
                }

                const zone = host.zone;
                const hasContent = host.hasContent;
                const x0 = host.x;
                const y0 = host.y;
                const x1 = x0 + host.width;
                const y1 = y0 + host.height;

                if (zone === "" || !hasContent) {
                    continue;
                }

                const currentOwner = allOwners[zone];
                if (currentOwner !== undefined && currentOwner !== host) {
                    continue;
                }

                const overlapsX = x1 > vx0 + 0.5 && x0 < vx1 - 0.5;
                const overlapsY = y1 > vy0 + 0.5 && y0 < vy1 - 0.5;

                let active = false;
                switch (zone) {
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
                    type: zone,
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
                item: mainWindow.activeTrayHost
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

            Repeater {
                model: SystemTray.items

                delegate: ZoneHost {
                    id: trayMenuZone

                    required property SystemTrayItem modelData

                    readonly property var trayItem: modelData

                    zone: "top"
                    open: GlobalState.trayMenuOwner === trayMenuZone.trayItem
                    hasAnchorX: true
                    anchorX: GlobalState.trayMenuAnchorFor(trayMenuZone.trayItem)
                    viewX: viewRect.x
                    viewY: viewRect.y - Sizes.gap
                    viewWidth: viewRect.width
                    viewHeight: viewRect.height
                    screenWidth: mainWindow.width
                    screenHeight: mainWindow.height
                    onEvicted: {
                        if (GlobalState.trayMenuOwner === trayMenuZone.trayItem)
                            GlobalState.trayMenuOwner = null;
                    }

                    Component.onCompleted: mainWindow.registerTrayHost(trayMenuZone)
                    Component.onDestruction: {
                        mainWindow.unregisterTrayHost(trayMenuZone);
                        if (GlobalState.trayMenuOwner === trayMenuZone.trayItem)
                            GlobalState.trayMenuOwner = null;
                    }

                    TrayMenu {
                        anchors.fill: parent
                        menuHandle: trayMenuZone.trayItem ? trayMenuZone.trayItem.menu : null
                        active: trayMenuZone.open
                        onCloseRequested: {
                            if (GlobalState.trayMenuOwner === trayMenuZone.trayItem)
                                GlobalState.trayMenuOwner = null;
                        }
                    }
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
                }, Sizes.radiusFor(-1))

                property string filled: BorderPath.fillPath(borderShape.outline, borderShape.width, borderShape.height)

                ShapePath {
                    fillColor: Colors.background
                    fillRule: ShapePath.OddEvenFill
                    strokeWidth: -1

                    PathSvg {
                        path: borderShape.filled
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

    PanelWindow {
        id: borderWindow

        color: "transparent"
        implicitWidth: screen.width
        implicitHeight: screen.height
        anchors.top: true
        exclusiveZone: -1
        mask: Region {}
        WlrLayershell.namespace: "quickshell-border"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor: "transparent"
                strokeColor: Colors.border
                strokeWidth: Sizes.borderWidth

                PathSvg {
                    path: BorderPath.build(mainWindow.zoneNotches, {
                        x: viewRect.x,
                        y: viewRect.y + shellContent.y,
                        width: viewRect.width,
                        height: viewRect.height
                    }, Sizes.radiusFor(-1))
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
