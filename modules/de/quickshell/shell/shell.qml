pragma ComponentBehavior: Bound

import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

ShellRoot {
    id: shellRoot

    property bool fakeLockActive: !GlobalState.locked

    function lockScreen() {
        if (GlobalState.locked) {
            return;
        }
        GlobalState.appLauncherOpened = false;
        GlobalState.clipboardOpened = false;
        GlobalState.notificationsShown = false;
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

    PanelWindow {
        id: mainWindow

        property real topEdge: mainBar.implicitHeight
        property real leftEdge: 15
        property real rightEdge: 15
        property real bottomEdge: 15

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
                x: leftRect.x
                y: leftRect.y + shellContent.y
                width: leftRect.width
                height: leftRect.height
                intersection: Intersection.Subtract
            }
            Region {
                x: bottomRect.x
                y: bottomRect.y + shellContent.y
                width: bottomRect.width
                height: bottomRect.height
                intersection: Intersection.Subtract
            }
            Region {
                x: bottomRightRect.x
                y: bottomRightRect.y + shellContent.y
                width: bottomRightRect.width
                height: bottomRightRect.height
                intersection: Intersection.Subtract
            }
            // Region {
            //     item: rightRect
            //     intersection: Intersection.Subtract
            // }
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
            Rectangle {
                id: leftRect
                color: "transparent"
                anchors.verticalCenter: viewRect.verticalCenter
                x: GlobalState.clipboardOpened ? 0 : viewRect.x - width
                width: clipboard.implicitWidth + Sizes.gap * 2
                height: clipboard.implicitHeight + Sizes.gap * 2
                radius: Sizes.borderRadius
                Behavior on x {
                    StylizedNumberAnimation {}
                }
                Clipboard {
                    id: clipboard
                    anchors {
                        rightMargin: GlobalState.clipboardOpened ? Sizes.gap : parent.parent.height - viewRect.y - viewRect.height
                        fill: parent
                    }
                }
            }
            Rectangle {
                id: bottomRect
                color: "transparent"
                anchors.horizontalCenter: viewRect.horizontalCenter
                y: GlobalState.appLauncherOpened ? parent.height - height : viewRect.y + viewRect.height
                width: launcher.implicitWidth + Sizes.gap * 2
                height: launcher.implicitHeight + Sizes.gap * 2
                radius: Sizes.borderRadius
                Behavior on y {
                    StylizedNumberAnimation {}
                }
                Launcher {
                    id: launcher
                    anchors {
                        topMargin: GlobalState.appLauncherOpened ? Sizes.gap : parent.parent.height - viewRect.y - viewRect.height
                        fill: parent
                    }
                }
            }
            Rectangle {
                id: bottomRightRect
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    bottomMargin: GlobalState.notificationsShown ? 0 : -height + (parent.height - viewRect.y - viewRect.height)
                }
                color: "transparent"
                radius: Sizes.borderRadius
                width: Math.max(notifications.implicitWidth + Sizes.gap * 2, parent.width - viewRect.x - viewRect.width + topRightRadius + topLeftRadius)
                height: Math.max(notifications.implicitHeight + Sizes.gap * 2, parent.height - viewRect.y - viewRect.height)
                Behavior on width {
                    StylizedNumberAnimation {}
                }
                Behavior on height {
                    StylizedNumberAnimation {}
                }
                Behavior on anchors.bottomMargin {
                    StylizedNumberAnimation {}
                }
                Notifications {
                    id: notifications
                    anchors {
                        topMargin: GlobalState.notificationsShown ? Sizes.gap : parent.parent.height - viewRect.y - viewRect.height
                        fill: parent
                    }
                }
            }
            // Rectangle {
            //     id: rightRect
            //     color: "transparent"
            //     x: rightMouse.containsMouse ? parent.x + parent.width - width : viewRect.x + viewRect.width
            //     anchors.verticalCenter: viewRect.verticalCenter
            //     width: 300
            //     height: 500
            //     radius: Sizes.borderRadius
            //     Behavior on x {
            //         MyNumberAnimation {}
            //     }
            //     MouseArea {
            //         id: rightMouse
            //         anchors.fill: parent
            //         hoverEnabled: true
            //     }
            //     CenterText {
            //         text: "right panel"
            //     }
            // }
            Shape {
                id: borderShape
                anchors.fill: parent

                function commonTangents(c1, c2) {
                    const {
                        x: x1,
                        y: y1,
                        r: r1
                    } = c1;
                    const {
                        x: x2,
                        y: y2,
                        r: r2
                    } = c2;
                    const dx = x2 - x1;
                    const dy = y2 - y1;
                    const d = Math.hypot(dx, dy);
                    const cosPhi = (r1 + r2) / d;
                    const sinPhi = Math.sqrt(1 - cosPhi * cosPhi);
                    const ux = dx / d;
                    const uy = dy / d;
                    const perpX = -uy;
                    const perpY = ux;
                    const n1x = cosPhi * ux + sinPhi * perpX;
                    const n1y = cosPhi * uy + sinPhi * perpY;
                    const n2x = cosPhi * ux - sinPhi * perpX;
                    const n2y = cosPhi * uy - sinPhi * perpY;
                    const tangent1 = {
                        p1: {
                            x: x1 + r1 * n1x,
                            y: y1 + r1 * n1y
                        },
                        p2: {
                            x: x2 - r2 * n1x,
                            y: y2 - r2 * n1y
                        }
                    };
                    const tangent2 = {
                        p1: {
                            x: x1 + r1 * n2x,
                            y: y1 + r1 * n2y
                        },
                        p2: {
                            x: x2 - r2 * n2x,
                            y: y2 - r2 * n2y
                        }
                    };
                    return [tangent1, tangent2];
                }

                property var leftTopTangent: commonTangents({
                    x: viewRect.x + leftRect.topLeftRadius,
                    y: leftRect.y - leftRect.topLeftRadius,
                    r: leftRect.topLeftRadius
                }, {
                    x: leftRect.x + leftRect.width - leftRect.topRightRadius,
                    y: leftRect.y + leftRect.topRightRadius,
                    r: leftRect.topRightRadius
                })[0]
                property var leftBottomTangent: commonTangents({
                    x: leftRect.x + leftRect.width - leftRect.bottomRightRadius,
                    y: leftRect.y + leftRect.height - leftRect.bottomRightRadius,
                    r: leftRect.bottomRightRadius
                }, {
                    x: viewRect.x + leftRect.bottomLeftRadius,
                    y: leftRect.y + leftRect.height + leftRect.bottomLeftRadius,
                    r: leftRect.bottomLeftRadius
                })[1]
                property var bottomLeftTangent: commonTangents({
                    x: bottomRect.x - bottomRect.bottomLeftRadius,
                    y: viewRect.y + viewRect.height - bottomRect.bottomLeftRadius,
                    r: bottomRect.bottomLeftRadius
                }, {
                    x: bottomRect.x + bottomRect.topLeftRadius,
                    y: bottomRect.y + bottomRect.topLeftRadius,
                    r: bottomRect.topLeftRadius
                })[0]
                property var bottomRightTangent: commonTangents({
                    x: bottomRect.x + bottomRect.width - bottomRect.topRightRadius,
                    y: bottomRect.y + bottomRect.topRightRadius,
                    r: bottomRect.topRightRadius
                }, {
                    x: bottomRect.x + bottomRect.width + bottomRect.bottomRightRadius,
                    y: viewRect.y + viewRect.height - bottomRect.bottomRightRadius,
                    r: bottomRect.bottomRightRadius
                })[1]
                property var bottomRightLeftTangent: commonTangents({
                    x: bottomRightRect.x - bottomRightRect.bottomLeftRadius,
                    y: viewRect.y + viewRect.height - bottomRightRect.bottomLeftRadius,
                    r: bottomRightRect.bottomLeftRadius
                }, {
                    x: bottomRightRect.x + bottomRightRect.topLeftRadius,
                    y: bottomRightRect.y + bottomRightRect.topLeftRadius,
                    r: bottomRightRect.topLeftRadius
                })[0]
                property var bottomRightRightTangent: commonTangents({
                    x: bottomRightRect.x + bottomRightRect.topLeftRadius,
                    y: bottomRightRect.y + bottomRightRect.topLeftRadius,
                    r: bottomRightRect.topLeftRadius
                }, {
                    x: viewRect.x + viewRect.width - bottomRightRect.topRightRadius,
                    y: bottomRightRect.y - bottomRightRect.topRightRadius,
                    r: bottomRightRect.topRightRadius
                })[1]
                // property var rightBottomTangent: commonTangents({
                //     x: viewRect.x + viewRect.width - rightRect.bottomRightRadius,
                //     y: rightRect.y + rightRect.height + rightRect.bottomRightRadius,
                //     r: rightRect.bottomRightRadius
                // }, {
                //     x: rightRect.x + rightRect.bottomLeftRadius,
                //     y: rightRect.y + rightRect.height - rightRect.bottomLeftRadius,
                //     r: rightRect.bottomLeftRadius
                // })[0]
                // property var rightTopTangent: commonTangents({
                //     x: rightRect.x + rightRect.topLeftRadius,
                //     y: rightRect.y + rightRect.topLeftRadius,
                //     r: rightRect.topLeftRadius
                // }, {
                //     x: viewRect.x + viewRect.width - rightRect.topRightRadius,
                //     y: rightRect.y - rightRect.topRightRadius,
                //     r: rightRect.topRightRadius
                // })[1]
                property list<QtObject> borderCurve: [
                    PathMove {
                        x: mainWindow.implicitWidth / 2
                        y: viewRect.y
                    },
                    PathLine {
                        x: viewRect.x + viewRect.topLeftRadius
                        y: viewRect.y
                    },
                    PathArc {
                        x: viewRect.x
                        y: viewRect.y + viewRect.topLeftRadius
                        radiusX: viewRect.topLeftRadius
                        radiusY: viewRect.topLeftRadius
                        direction: PathArc.Counterclockwise
                    },
                    PathLine {
                        x: viewRect.x
                        y: leftRect.y - leftRect.topLeftRadius
                    },
                    PathArc {
                        x: borderShape.leftTopTangent.p1.x
                        y: borderShape.leftTopTangent.p1.y
                        radiusX: leftRect.topLeftRadius
                        radiusY: leftRect.topLeftRadius
                        direction: PathArc.Counterclockwise
                    },
                    PathLine {
                        x: borderShape.leftTopTangent.p2.x
                        y: borderShape.leftTopTangent.p2.y
                    },
                    PathArc {
                        x: leftRect.x + leftRect.width
                        y: leftRect.y + leftRect.topRightRadius
                        radiusX: leftRect.topRightRadius
                        radiusY: leftRect.topRightRadius
                    },
                    PathLine {
                        x: leftRect.x + leftRect.width
                        y: leftRect.y + leftRect.height - leftRect.bottomRightRadius
                    },
                    PathArc {
                        x: borderShape.leftBottomTangent.p1.x
                        y: borderShape.leftBottomTangent.p1.y
                        radiusX: leftRect.bottomRightRadius
                        radiusY: leftRect.bottomRightRadius
                    },
                    PathLine {
                        x: borderShape.leftBottomTangent.p2.x
                        y: borderShape.leftBottomTangent.p2.y
                    },
                    PathArc {
                        x: viewRect.x
                        y: leftRect.y + leftRect.height + leftRect.bottomLeftRadius
                        radiusX: leftRect.bottomLeftRadius
                        radiusY: leftRect.bottomLeftRadius
                        direction: PathArc.Counterclockwise
                    },
                    PathLine {
                        x: viewRect.x
                        y: viewRect.y + viewRect.height - viewRect.bottomLeftRadius
                    },
                    PathArc {
                        x: viewRect.x + viewRect.bottomLeftRadius
                        y: viewRect.y + viewRect.height
                        radiusX: viewRect.bottomLeftRadius
                        radiusY: viewRect.bottomLeftRadius
                        direction: PathArc.Counterclockwise
                    },
                    PathLine {
                        x: bottomRect.x - bottomRect.bottomLeftRadius
                        y: viewRect.y + viewRect.height
                    },
                    PathArc {
                        x: borderShape.bottomLeftTangent.p1.x
                        y: borderShape.bottomLeftTangent.p1.y
                        radiusX: bottomRect.bottomLeftRadius
                        radiusY: bottomRect.bottomLeftRadius
                        direction: PathArc.Counterclockwise
                    },
                    PathLine {
                        x: borderShape.bottomLeftTangent.p2.x
                        y: borderShape.bottomLeftTangent.p2.y
                    },
                    PathArc {
                        x: bottomRect.x + bottomRect.topLeftRadius
                        y: bottomRect.y
                        radiusX: bottomRect.topLeftRadius
                        radiusY: bottomRect.topLeftRadius
                    },
                    PathLine {
                        x: bottomRect.x + bottomRect.width - bottomRect.topRightRadius
                        y: bottomRect.y
                    },
                    PathArc {
                        x: borderShape.bottomRightTangent.p1.x
                        y: borderShape.bottomRightTangent.p1.y
                        radiusX: bottomRect.topRightRadius
                        radiusY: bottomRect.topRightRadius
                    },
                    PathLine {
                        x: borderShape.bottomRightTangent.p2.x
                        y: borderShape.bottomRightTangent.p2.y
                    },
                    PathArc {
                        x: bottomRect.x + bottomRect.width + bottomRect.bottomRightRadius
                        y: viewRect.y + viewRect.height
                        radiusX: bottomRect.bottomRightRadius
                        radiusY: bottomRect.bottomRightRadius
                        direction: PathArc.Counterclockwise
                    },
                    PathLine {
                        x: bottomRightRect.x - bottomRightRect.bottomLeftRadius
                        y: viewRect.y + viewRect.height
                    },
                    PathArc {
                        x: borderShape.bottomRightLeftTangent.p1.x
                        y: borderShape.bottomRightLeftTangent.p1.y
                        radiusX: bottomRightRect.bottomLeftRadius
                        radiusY: bottomRightRect.bottomLeftRadius
                        direction: PathArc.Counterclockwise
                    },
                    PathLine {
                        x: borderShape.bottomRightLeftTangent.p2.x
                        y: borderShape.bottomRightLeftTangent.p2.y
                    },
                    PathArc {
                        x: borderShape.bottomRightRightTangent.p1.x
                        y: borderShape.bottomRightRightTangent.p1.y
                        radiusX: bottomRightRect.topLeftRadius
                        radiusY: bottomRightRect.topLeftRadius
                    },
                    PathLine {
                        x: borderShape.bottomRightRightTangent.p2.x
                        y: borderShape.bottomRightRightTangent.p2.y
                    },
                    PathArc {
                        x: viewRect.x + viewRect.width
                        y: bottomRightRect.y - bottomRightRect.topRightRadius
                        radiusX: bottomRightRect.topRightRadius
                        radiusY: bottomRightRect.topRightRadius
                        direction: PathArc.Counterclockwise
                    },

                    // PathLine {
                    //     x: viewRect.x + viewRect.width - viewRect.bottomRightRadius
                    //     y: viewRect.y + viewRect.height
                    // },
                    // PathArc {
                    //     x: viewRect.x + viewRect.width
                    //     y: viewRect.y + viewRect.height - viewRect.bottomRightRadius
                    //     radiusX: viewRect.bottomRightRadius
                    //     radiusY: viewRect.bottomRightRadius
                    //     direction: PathArc.Counterclockwise
                    // },

                    // PathLine {
                    //     x: viewRect.x + viewRect.width
                    //     y: rightRect.y + rightRect.height + rightRect.bottomRightRadius
                    // },
                    // PathArc {
                    //     x: borderShape.rightBottomTangent.p1.x
                    //     y: borderShape.rightBottomTangent.p1.y
                    //     radiusX: rightRect.bottomRightRadius
                    //     radiusY: rightRect.bottomRightRadius
                    //     direction: PathArc.Counterclockwise
                    // },
                    // PathLine {
                    //     x: borderShape.rightBottomTangent.p2.x
                    //     y: borderShape.rightBottomTangent.p2.y
                    // },
                    // PathArc {
                    //     x: rightRect.x
                    //     y: rightRect.y + rightRect.height - rightRect.bottomLeftRadius
                    //     radiusX: rightRect.bottomLeftRadius
                    //     radiusY: rightRect.bottomLeftRadius
                    // },
                    // PathLine {
                    //     x: rightRect.x
                    //     y: rightRect.y + rightRect.topLeftRadius
                    // },
                    // PathArc {
                    //     x: borderShape.rightTopTangent.p1.x
                    //     y: borderShape.rightTopTangent.p1.y
                    //     radiusX: rightRect.topLeftRadius
                    //     radiusY: rightRect.topLeftRadius
                    // },
                    // PathLine {
                    //     x: borderShape.rightTopTangent.p2.x
                    //     y: borderShape.rightTopTangent.p2.y
                    // },
                    // PathArc {
                    //     x: viewRect.x + viewRect.width
                    //     y: rightRect.y - rightRect.topRightRadius
                    //     radiusX: rightRect.topRightRadius
                    //     radiusY: rightRect.topRightRadius
                    //     direction: PathArc.Counterclockwise
                    // },

                    PathLine {
                        x: viewRect.x + viewRect.width
                        y: viewRect.y + viewRect.topRightRadius
                    },
                    PathArc {
                        x: viewRect.x + viewRect.width - viewRect.topRightRadius
                        y: viewRect.y
                        radiusX: viewRect.topRightRadius
                        radiusY: viewRect.topRightRadius
                        direction: PathArc.Counterclockwise
                    },
                    PathLine {
                        x: mainWindow.implicitWidth / 2
                        y: viewRect.y
                    }
                ]
                ShapePath {
                    fillColor: Colors.background
                    fillRule: ShapePath.OddEvenFill
                    strokeWidth: -1

                    property var fillRectangle: PathRectangle {
                        x: 0
                        y: 0
                        width: mainWindow.width
                        height: mainWindow.height
                    }

                    pathElements: borderShape.borderCurve.concat(fillRectangle)
                }
                ShapePath {
                    fillColor: "transparent"
                    strokeWidth: Sizes.borderWidth
                    pathElements: borderShape.borderCurve
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

        locked: GlobalState.locked

        WlSessionLockSurface {
            color: Colors.background
            LockScreen {
                context: lockContext
                anchors.fill: parent
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
