import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Layouts

Item {
    anchors {
        left: parent.left
        right: parent.right
        rightMargin: Sizes.gap
        leftMargin: Sizes.gap
    }
    implicitHeight: Math.max(leftRow.implicitHeight, workspaces.implicitHeight, rightRow.implicitHeight) + Sizes.gap * 2

    StylizedRowLayout {
        id: leftRow
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Keyboard {}

        Vpn {}

        Tray {}

        // Test {}
    }

    Workspaces {
        id: workspaces
        anchors.centerIn: parent
    }

    StylizedRowLayout {
        id: rightRow
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        AudioSink {}

        AudioSource {}

        Network {}

        Power {}

        Clock {}
    }
}
