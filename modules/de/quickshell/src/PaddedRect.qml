import QtQuick
import Quickshell.Widgets

Rectangle {
    id: paddedRect

    required property var child

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius
    implicitWidth: child.implicitWidth + root.gap * 2
    implicitHeight: child.implicitHeight + root.gap * 2

    Item {
        anchors.fill: parent
        data: child
    }
}
