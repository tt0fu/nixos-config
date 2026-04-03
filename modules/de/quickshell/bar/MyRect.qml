import QtQuick
import Quickshell.Widgets

Rectangle {
    id: myRect
    property int level: 0

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius - level * root.gap
}
