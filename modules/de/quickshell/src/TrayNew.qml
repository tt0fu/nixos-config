import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PaddedRect {
    id: trayDebug

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

                QsMenuOpener {
                    id: menuOpener
                    menu: modelData.menu
                }
                
                Menu {
                    id: trayMenu
                    cascade: true
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                    Repeater {
                        model: menuOpener.children

                        
                        MenuItem {
                            required property SystemTrayItem modelData
                            text: modelData.text
                        }
                    }
                }

                MouseArea {
                    id: trayIconMouseArea
                    anchors.fill: parent

                    onClicked: trayMenu.popup(trayIcon, root.iconSize, 100)
                }
            }
        }
    }
}
