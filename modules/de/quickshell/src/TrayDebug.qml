import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

PaddedRect {
    id: trayDebug

    visible: SystemTray.items.values.length !== 0

    child: Loader {
        id: trayLoader
        anchors.fill: parent
        active: true
        onActiveChanged: console.log("Reloaded")
        required property QsMenuEntry modelData
        sourceComponent: RowLayout {
            id: trayLayout
            anchors.fill: parent
            anchors.margins: root.gap
            spacing: root.gap

            Repeater {
                model: SystemTray.items
                PaddedRect {
                    required property SystemTrayItem modelData
                    child: RowLayout {
                        id: trayDebugLayout
                        anchors.fill: parent
                        anchors.margins: root.gap
                        spacing: root.gap

                        Image {
                            id: trayIcon
                            source: modelData.icon
                            sourceSize.width: root.iconSize
                            sourceSize.height: root.iconSize
                            fillMode: Image.PreserveAspectFit
                        }

                        QsMenuOpener {
                            id: menuOpener
                            menu: modelData.menu
                        }

                        Repeater {
                            model: menuOpener.children

                            MyText {
                                text: {
                                    if (modelData.buttonType === QsMenuButtonType.None) {
                                        return modelData.hasChildren ? "" : "";
                                    }
                                    if (modelData.buttonType === QsMenuButtonType.CheckBox) {
                                        return modelData.checkState === Qt.Checked ? "" : "";
                                    }
                                    return modelData.checkState === Qt.Checked ? "" : "";
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    MouseArea {
        id: menuItemMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            trayLoader.active = !trayLoader.active;
            trayLoader.active = !trayLoader.active;
        }
    }
}
