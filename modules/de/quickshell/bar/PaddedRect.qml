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
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on y {
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on implicitHeight {
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on border.color {
        ColorAnimation {
            duration: root.animationDuration
        }
    }
}
