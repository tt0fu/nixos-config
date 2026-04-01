import QtQuick
import Quickshell.Widgets

MyRect {
    id: paddedRect

    required property var child

    implicitWidth: child.implicitWidth + root.gap * 2
    implicitHeight: child.implicitHeight + root.gap * 2

    Item {
        anchors.fill: parent
        data: child
    }
    Behavior on x {
        MyNumberAnimation {}
    }
    Behavior on y {
        MyNumberAnimation {}
    }
    Behavior on border.color {
        MyColorAnimation {}
    }
}
