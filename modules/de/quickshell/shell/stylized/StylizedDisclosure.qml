import qs
import "../config"
import QtQuick
import QtQuick.Layouts

Item {
    id: disclosure

    property string title: ""
    property bool expanded: false

    readonly property bool hovered: mouseArea.containsMouse

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    StylizedRowLayout {
        id: row

        anchors.fill: parent

        StylizedText {
            Layout.fillWidth: true
            color: disclosure.hovered ? Colors.hover : Colors.muted
            text: disclosure.title
            wrapMode: Text.Wrap
        }

        StylizedCenterText {
            Layout.minimumWidth: Fonts.size
            rotation: disclosure.expanded ? 90 : 0
            text: "\ueb70"
            color: disclosure.hovered ? Colors.hover : Colors.muted

            Behavior on rotation {
                StylizedNumberAnimation {}
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: disclosure.expanded = !disclosure.expanded
    }
}
