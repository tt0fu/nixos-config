import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: tray
    implicitWidth: trayLayout.implicitWidth + root.gap * 2
    implicitHeight: trayLayout.implicitHeight + root.gap * 2

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius
    visible: SystemTray.items.values.length !== 0

    RowLayout {
        id: trayLayout
        anchors.fill: parent
        anchors.margins: root.gap
        spacing: root.gap

        Repeater {
            model: SystemTray.items
            Image {
                id: trayIcon
                required property SystemTrayItem modelData

                source: modelData.icon
                sourceSize.width: root.iconSize
                sourceSize.height: root.iconSize
                fillMode: Image.PreserveAspectFit

                TrayMenu {
                    id: trayWindow
                    menuHandle: modelData.menu
                    anchorX: trayIcon.x + trayLayout.x + tray.x + leftRow.x + barLayout.x + windowRect.x
                    anchorY: root.implicitHeight
                    visible: false
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                    onPressed: event => {
                        if (event.buttons & Qt.LeftButton) {
                            if (modelData.onlyMenu) {
                                trayWindow.toggleVisibility();
                            } else {
                                modelData.activate();
                            }
                        }
                        if (event.buttons & Qt.RightButton) {
                            if (modelData.hasMenu) {
                                trayWindow.toggleVisibility();
                            } else {
                                modelData.activate();
                            }
                        }
                        if (event.buttons & Qt.MiddleButton) {
                            modelData.secondaryActivate();
                        }
                    }
                }
            }
        }
    }
}
