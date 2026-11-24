import qs
import "stylized"
import "config"
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

StylizedPaddedRectangle {
    id: tray
    level: 0

    visible: SystemTray.items.values.length !== 0

    function closeMenu() {
        GlobalState.trayMenuOpened = false;
    }

    function toggleMenu(item, visualItem) {
        if (GlobalState.trayMenuOpened && GlobalState.trayMenuOwner === item) {
            closeMenu();
            return;
        }

        const anchor = visualItem.mapToItem(null, 0, 0).x;
        GlobalState.trayMenuHandle = item.menu;
        GlobalState.trayMenuOwner = item;
        GlobalState.trayMenuAnchorX = anchor;
        GlobalState.trayMenuOpened = true;
    }

    child: StylizedRowLayout {
        id: trayLayout
        anchors.fill: parent
        anchors.margins: Sizes.gap

        Repeater {
            model: SystemTray.items
            Image {
                id: trayItem
                required property SystemTrayItem modelData

                source: modelData.icon
                sourceSize.width: Sizes.iconSize
                sourceSize.height: Sizes.iconSize
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                    onPressed: event => {
                        if (event.buttons & Qt.LeftButton) {
                            if (modelData.onlyMenu) {
                                tray.toggleMenu(modelData, trayItem);
                            } else {
                                tray.closeMenu();
                                modelData.activate();
                            }
                        }
                        if (event.buttons & Qt.RightButton) {
                            if (modelData.hasMenu) {
                                tray.toggleMenu(modelData, trayItem);
                            } else {
                                tray.closeMenu();
                                modelData.activate();
                            }
                        }
                        if (event.buttons & Qt.MiddleButton) {
                            tray.closeMenu();
                            modelData.secondaryActivate();
                        }
                    }
                }
            }
        }
    }

    Behavior on implicitWidth {
        StylizedNumberAnimation {}
    }
}
