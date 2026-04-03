import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

PaddedRect {
    id: tray
    level: 1

    visible: SystemTray.items.values.length !== 0

    child: RowLayout {
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

                Loader {
                    id: trayMenuLoader
                    anchors.fill: parent
                    active: true
                    sourceComponent: TrayMenu {
                        id: trayMenu
                        menuHandle: modelData.menu
                        anchorX: trayIcon.x + trayLayout.x + tray.x + leftRow.x + barLayout.x + windowRect.x
                        anchorY: root.implicitHeight
                    }

                    function reloadTrayMenu() {
                        active = !active;
                        active = !active;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                    onPressed: event => {
                        if (event.buttons & Qt.LeftButton) {
                            if (modelData.onlyMenu) {
                                trayMenuLoader.item.toggleVisibility();
                            } else {
                                modelData.activate();
                            }
                        }
                        if (event.buttons & Qt.RightButton) {
                            if (modelData.hasMenu) {
                                trayMenuLoader.item.toggleVisibility();
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

    Behavior on implicitWidth {
        MyNumberAnimation {}
    }
}
