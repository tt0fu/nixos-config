import qs
import "config"
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

ShellRoot {
    PanelWindow {
        id: root

        property real topEdge: mainBar.implicitHeight
        property real leftEdge: 15
        property real rightEdge: 15
        property real bottomEdge: 15

        color: "transparent"
        implicitWidth: screen.width
        implicitHeight: screen.height
        anchors.top: true
        exclusiveZone: topEdge
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        mask: Region {
            item: viewRect
            intersection: Intersection.Subtract
            // Region {
            //     item: leftRect
            //     intersection: Intersection.Subtract
            // }
            // Region {
            //     item: bottomRect
            //     intersection: Intersection.Subtract
            // }
            Region {
                item: bottomRightRect
                intersection: Intersection.Subtract
            }
            // Region {
            //     item: rightRect
            //     intersection: Intersection.Subtract
            // }
        }
        Rectangle {
            id: viewRect
            anchors {
                fill: parent
                topMargin: root.topEdge
                bottomMargin: root.bottomEdge
                leftMargin: root.leftEdge
                rightMargin: root.rightEdge
            }
            visible: false
            radius: Sizes.borderRadius
        }
        // Rectangle {
        //     id: leftRect
        //     anchors.verticalCenter: viewRect.verticalCenter
        //     property bool active: leftMouse.containsMouse
        //     x: active ? 0 : viewRect.x - width
        //     width: 300
        //     height: 500
        //     color: "transparent"
        //     radius: Sizes.borderRadius
        //     Behavior on x {
        //         MyNumberAnimation {}
        //     }
        //     Item {
        //         id: leftTab
        //         anchors {
        //             right: parent.right
        //             verticalCenter: parent.verticalCenter
        //         }
        //         width: viewRect.x
        //         height: parent.height / 5
        //         Rectangle {
        //             id: leftIndicator
        //             anchors {
        //                 fill: parent
        //                 leftMargin: parent.width / 4
        //                 rightMargin: parent.width / 4
        //             }
        //             radius: width / 2
        //         }
        //     }

        //     MouseArea {
        //         id: leftMouse
        //         anchors.fill: parent.active ? parent : leftTab
        //         hoverEnabled: true
        //     }
        //     CenterText {
        //         text: "left panel"
        //     }
        // }
        // Rectangle {
        //     id: bottomRect
        //     color: "transparent"
        //     anchors.horizontalCenter: viewRect.horizontalCenter
        //     y: bottomMouse.containsMouse ? parent.height - height : viewRect.y + viewRect.height
        //     width: 1000
        //     height: 300
        //     radius: Sizes.borderRadius
        //     Behavior on y {
        //         MyNumberAnimation {}
        //     }
        //     MouseArea {
        //         id: bottomMouse
        //         anchors.fill: parent
        //         hoverEnabled: true
        //     }
        //     CenterText {
        //         text: "bottom panel"
        //     }
        // }
        Rectangle {
            id: bottomRightRect
            anchors {
                right: parent.right
                bottom: parent.bottom
            }
            color: "transparent"
            radius: Sizes.borderRadius
            width: Math.max(notifications.implicitWidth + Sizes.gap * 2, parent.width - viewRect.x - viewRect.width + topRightRadius + topLeftRadius)
            height: Math.max(notifications.implicitHeight + Sizes.gap * 2, parent.height - viewRect.y - viewRect.height)
            Behavior on width {
                MyNumberAnimation {}
            }
            Behavior on height {
                MyNumberAnimation {}
            }
            Notifications {
                id: notifications
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
            ShapePath {
                id: borderShapePath
                fillColor: Colors.background
                fillRule: ShapePath.OddEvenFill
                strokeWidth: Sizes.borderWidth

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

                PathRectangle {
                    x: -100
                    y: -100
                    width: root.width + 200
                    height: root.height + 200
                }

                PathMove {
                    x: root.implicitWidth / 2
                    y: viewRect.y
                }

                PathLine {
                    x: viewRect.x + viewRect.topLeftRadius
                    y: viewRect.y
                }
                PathArc {
                    x: viewRect.x
                    y: viewRect.y + viewRect.topLeftRadius
                    radiusX: viewRect.topLeftRadius
                    radiusY: viewRect.topLeftRadius
                    direction: PathArc.Counterclockwise
                }
                
                // PathLine {
                //     x: viewRect.x
                //     y: leftRect.y - leftRect.topLeftRadius
                // }
                // property var leftTopTangent: commonTangents({
                //     x: viewRect.x + leftRect.topLeftRadius,
                //     y: leftRect.y - leftRect.topLeftRadius,
                //     r: leftRect.topLeftRadius
                // }, {
                //     x: leftRect.x + leftRect.width - leftRect.topRightRadius,
                //     y: leftRect.y + leftRect.topRightRadius,
                //     r: leftRect.topRightRadius
                // })[0]
                // PathArc {
                //     x: borderShapePath.leftTopTangent.p1.x
                //     y: borderShapePath.leftTopTangent.p1.y
                //     radiusX: leftRect.topLeftRadius
                //     radiusY: leftRect.topLeftRadius
                //     direction: PathArc.Counterclockwise
                // }
                // PathLine {
                //     x: borderShapePath.leftTopTangent.p2.x
                //     y: borderShapePath.leftTopTangent.p2.y
                // }
                // PathArc {
                //     x: leftRect.x + leftRect.width
                //     y: leftRect.y + leftRect.topRightRadius
                //     radiusX: leftRect.topRightRadius
                //     radiusY: leftRect.topRightRadius
                // }
                // PathLine {
                //     x: leftRect.x + leftRect.width
                //     y: leftRect.y + leftRect.height - leftRect.bottomRightRadius
                // }
                // property var leftBottomTangent: commonTangents({
                //     x: leftRect.x + leftRect.width - leftRect.bottomRightRadius,
                //     y: leftRect.y + leftRect.height - leftRect.bottomRightRadius,
                //     r: leftRect.bottomRightRadius
                // }, {
                //     x: viewRect.x + leftRect.bottomLeftRadius,
                //     y: leftRect.y + leftRect.height + leftRect.bottomLeftRadius,
                //     r: leftRect.bottomLeftRadius
                // })[1]
                // PathArc {
                //     x: borderShapePath.leftBottomTangent.p1.x
                //     y: borderShapePath.leftBottomTangent.p1.y
                //     radiusX: leftRect.bottomRightRadius
                //     radiusY: leftRect.bottomRightRadius
                // }
                // PathLine {
                //     x: borderShapePath.leftBottomTangent.p2.x
                //     y: borderShapePath.leftBottomTangent.p2.y
                // }
                // PathArc {
                //     x: viewRect.x
                //     y: leftRect.y + leftRect.height + leftRect.bottomLeftRadius
                //     radiusX: leftRect.bottomLeftRadius
                //     radiusY: leftRect.bottomLeftRadius
                //     direction: PathArc.Counterclockwise
                // }

                PathLine {
                    x: viewRect.x
                    y: viewRect.y + viewRect.height - viewRect.bottomLeftRadius
                }
                PathArc {
                    x: viewRect.x + viewRect.bottomLeftRadius
                    y: viewRect.y + viewRect.height
                    radiusX: viewRect.bottomLeftRadius
                    radiusY: viewRect.bottomLeftRadius
                    direction: PathArc.Counterclockwise
                }

                // PathLine {
                //     x: bottomRect.x - bottomRect.bottomLeftRadius
                //     y: viewRect.y + viewRect.height
                // }
                // property var bottomLeftTangent: commonTangents({
                //     x: bottomRect.x - bottomRect.bottomLeftRadius,
                //     y: viewRect.y + viewRect.height - bottomRect.bottomLeftRadius,
                //     r: bottomRect.bottomLeftRadius
                // }, {
                //     x: bottomRect.x + bottomRect.topLeftRadius,
                //     y: bottomRect.y + bottomRect.topLeftRadius,
                //     r: bottomRect.topLeftRadius
                // })[0]
                // PathArc {
                //     x: borderShapePath.bottomLeftTangent.p1.x
                //     y: borderShapePath.bottomLeftTangent.p1.y
                //     radiusX: bottomRect.bottomLeftRadius
                //     radiusY: bottomRect.bottomLeftRadius
                //     direction: PathArc.Counterclockwise
                // }
                // PathLine {
                //     x: borderShapePath.bottomLeftTangent.p2.x
                //     y: borderShapePath.bottomLeftTangent.p2.y
                // }
                // PathArc {
                //     x: bottomRect.x + bottomRect.topLeftRadius
                //     y: bottomRect.y
                //     radiusX: bottomRect.topLeftRadius
                //     radiusY: bottomRect.topLeftRadius
                // }
                // PathLine {
                //     x: bottomRect.x + bottomRect.width - bottomRect.topRightRadius
                //     y: bottomRect.y
                // }
                // property var bottomRightTangent: commonTangents({
                //     x: bottomRect.x + bottomRect.width - bottomRect.topRightRadius,
                //     y: bottomRect.y + bottomRect.topRightRadius,
                //     r: bottomRect.topRightRadius
                // }, {
                //     x: bottomRect.x + bottomRect.width + bottomRect.bottomRightRadius,
                //     y: viewRect.y + viewRect.height - bottomRect.bottomRightRadius,
                //     r: bottomRect.bottomRightRadius
                // })[1]
                // PathArc {
                //     x: borderShapePath.bottomRightTangent.p1.x
                //     y: borderShapePath.bottomRightTangent.p1.y
                //     radiusX: bottomRect.topRightRadius
                //     radiusY: bottomRect.topRightRadius
                // }
                // PathLine {
                //     x: borderShapePath.bottomRightTangent.p2.x
                //     y: borderShapePath.bottomRightTangent.p2.y
                // }
                // PathArc {
                //     x: bottomRect.x + bottomRect.width + bottomRect.bottomRightRadius
                //     y: viewRect.y + viewRect.height
                //     radiusX: bottomRect.bottomRightRadius
                //     radiusY: bottomRect.bottomRightRadius
                //     direction: PathArc.Counterclockwise
                // }

                PathLine {
                    x: bottomRightRect.x - bottomRightRect.bottomLeftRadius
                    y: viewRect.y + viewRect.height
                }
                property var bottomRightLeftTangent: commonTangents({
                    x: bottomRightRect.x - bottomRightRect.bottomLeftRadius,
                    y: viewRect.y + viewRect.height - bottomRightRect.bottomLeftRadius,
                    r: bottomRightRect.bottomLeftRadius
                }, {
                    x: bottomRightRect.x + bottomRightRect.topLeftRadius,
                    y: bottomRightRect.y + bottomRightRect.topLeftRadius,
                    r: bottomRightRect.topLeftRadius
                })[0]
                PathArc {
                    x: borderShapePath.bottomRightLeftTangent.p1.x
                    y: borderShapePath.bottomRightLeftTangent.p1.y
                    radiusX: bottomRightRect.bottomLeftRadius
                    radiusY: bottomRightRect.bottomLeftRadius
                    direction: PathArc.Counterclockwise
                }
                PathLine {
                    x: borderShapePath.bottomRightLeftTangent.p2.x
                    y: borderShapePath.bottomRightLeftTangent.p2.y
                }
                property var bottomRightRightTangent: commonTangents({
                    x: bottomRightRect.x + bottomRightRect.topLeftRadius,
                    y: bottomRightRect.y + bottomRightRect.topLeftRadius,
                    r: bottomRightRect.topLeftRadius
                }, {
                    x: viewRect.x + viewRect.width - bottomRightRect.topRightRadius,
                    y: bottomRightRect.y - bottomRightRect.topRightRadius,
                    r: bottomRightRect.topRightRadius
                })[1]
                PathArc {
                    x: borderShapePath.bottomRightRightTangent.p1.x
                    y: borderShapePath.bottomRightRightTangent.p1.y
                    radiusX: bottomRightRect.topLeftRadius
                    radiusY: bottomRightRect.topLeftRadius
                }
                PathLine {
                    x: borderShapePath.bottomRightRightTangent.p2.x
                    y: borderShapePath.bottomRightRightTangent.p2.y
                }
                PathArc {
                    x: viewRect.x + viewRect.width
                    y: bottomRightRect.y - bottomRightRect.topRightRadius
                    radiusX: bottomRightRect.topRightRadius
                    radiusY: bottomRightRect.topRightRadius
                    direction: PathArc.Counterclockwise
                }

                // PathLine {
                //     x: viewRect.x + viewRect.width - viewRect.bottomRightRadius
                //     y: viewRect.y + viewRect.height
                // }
                // PathArc {
                //     x: viewRect.x + viewRect.width
                //     y: viewRect.y + viewRect.height - viewRect.bottomRightRadius
                //     radiusX: viewRect.bottomRightRadius
                //     radiusY: viewRect.bottomRightRadius
                //     direction: PathArc.Counterclockwise
                // }

                // PathLine {
                //     x: viewRect.x + viewRect.width
                //     y: rightRect.y + rightRect.height + rightRect.bottomRightRadius
                // }
                // property var rightBottomTangent: commonTangents({
                //     x: viewRect.x + viewRect.width - rightRect.bottomRightRadius,
                //     y: rightRect.y + rightRect.height + rightRect.bottomRightRadius,
                //     r: rightRect.bottomRightRadius
                // }, {
                //     x: rightRect.x + rightRect.bottomLeftRadius,
                //     y: rightRect.y + rightRect.height - rightRect.bottomLeftRadius,
                //     r: rightRect.bottomLeftRadius
                // })[0]
                // PathArc {
                //     x: borderShapePath.rightBottomTangent.p1.x
                //     y: borderShapePath.rightBottomTangent.p1.y
                //     radiusX: rightRect.bottomRightRadius
                //     radiusY: rightRect.bottomRightRadius
                //     direction: PathArc.Counterclockwise
                // }
                // PathLine {
                //     x: borderShapePath.rightBottomTangent.p2.x
                //     y: borderShapePath.rightBottomTangent.p2.y
                // }
                // PathArc {
                //     x: rightRect.x
                //     y: rightRect.y + rightRect.height - rightRect.bottomLeftRadius
                //     radiusX: rightRect.bottomLeftRadius
                //     radiusY: rightRect.bottomLeftRadius
                // }
                // PathLine {
                //     x: rightRect.x
                //     y: rightRect.y + rightRect.topLeftRadius
                // }
                // property var rightTopTangent: commonTangents({
                //     x: rightRect.x + rightRect.topLeftRadius,
                //     y: rightRect.y + rightRect.topLeftRadius,
                //     r: rightRect.topLeftRadius
                // }, {
                //     x: viewRect.x + viewRect.width - rightRect.topRightRadius,
                //     y: rightRect.y - rightRect.topRightRadius,
                //     r: rightRect.topRightRadius
                // })[1]
                // PathArc {
                //     x: borderShapePath.rightTopTangent.p1.x
                //     y: borderShapePath.rightTopTangent.p1.y
                //     radiusX: rightRect.topLeftRadius
                //     radiusY: rightRect.topLeftRadius
                // }
                // PathLine {
                //     x: borderShapePath.rightTopTangent.p2.x
                //     y: borderShapePath.rightTopTangent.p2.y
                // }
                // PathArc {
                //     x: viewRect.x + viewRect.width
                //     y: rightRect.y - rightRect.topRightRadius
                //     radiusX: rightRect.topRightRadius
                //     radiusY: rightRect.topRightRadius
                //     direction: PathArc.Counterclockwise
                // }

                PathLine {
                    x: viewRect.x + viewRect.width
                    y: viewRect.y + viewRect.topRightRadius
                }
                PathArc {
                    x: viewRect.x + viewRect.width - viewRect.topRightRadius
                    y: viewRect.y
                    radiusX: viewRect.topRightRadius
                    radiusY: viewRect.topRightRadius
                    direction: PathArc.Counterclockwise
                }
                PathLine {
                    x: root.implicitWidth / 2
                    y: viewRect.y
                }
            }
        }

        MainBar {
            id: mainBar
        }
    }

    Scope {
        PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            exclusiveZone: root.leftEdge
            anchors.left: true
        }
        PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            exclusiveZone: root.rightEdge
            anchors.right: true
        }
        PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            exclusiveZone: root.bottomEdge
            anchors.bottom: true
        }
    }
}
