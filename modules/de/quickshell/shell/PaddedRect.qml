import qs
import "config"
import QtQuick
import Quickshell.Widgets

MyRect {
    id: paddedRect

    required property var child

    implicitWidth: child.implicitWidth + Sizes.gap * 2
    implicitHeight: child.implicitHeight + Sizes.gap * 2

    Item {
        anchors.fill: parent
        data: child
    }
    Behavior on x {
        StylizedNumberAnimation {}
    }
    Behavior on y {
        StylizedNumberAnimation {}
    }
    Behavior on border.color {
        MyColorAnimation {}
    }
}
