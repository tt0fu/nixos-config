import qs
import "config"
import QtQuick
import QtQuick.Layouts

Item {
    id: mainBar
    anchors {
        left: parent.left
        right: parent.right
        rightMargin: Sizes.gap
        leftMargin: Sizes.gap
    }
    implicitHeight: Math.max(leftRow.implicitHeight, workspaces.implicitHeight, rightRow.implicitHeight) + Sizes.gap * 2

    RowLayout {
        id: leftRow
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: Sizes.gap

        Keyboard {}

        Vpn {}

        Tray {}

        // Test {}
    }

    Workspaces {
        id: workspaces
        anchors.centerIn: parent
    }

    RowLayout {
        id: rightRow
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: Sizes.gap

        AudioSink {}

        AudioSource {}

        Network {}

        Power {}

        Clock {}
    }
}
