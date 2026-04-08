pragma ComponentBehavior: Bound
import qs
import "stylized"
import "config"
import Quickshell
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: menuWindow

    required property QsMenuHandle menuHandle

    property TrayMenu parentMenu: null
    property TrayMenu childMenu: null

    property real anchorX: 0
    property real anchorY: 0

    signal reload

    anchor.window: root
    anchor.rect.x: anchorX
    anchor.rect.y: anchorY

    implicitWidth: menuLayout.implicitWidth + Sizes.gap * 2
    implicitHeight: menuLayout.implicitHeight + Sizes.gap * 2

    color: "transparent"

    Loader {
        id: childMenuLoader
        active: false
    }

    Connections {
        target: childMenuLoader.item
        function onReload() {
            menuWindow.reload();
        }
    }

    StylizedRectangle {
        id: menuWindowBg
        level: 0
        anchors.fill: parent
        color: Colors.background

        QsMenuOpener {
            id: menuOpener
            menu: menuWindow.menuHandle
        }
        StylizedColumnLayout {
            id: menuLayout
            anchors.fill: parent
            anchors.margins: Sizes.gap

            Repeater {
                model: menuOpener.children
                Item {
                    id: menuEntry
                    required property QsMenuEntry modelData
                    implicitWidth: menuEntryLayout.implicitWidth
                    implicitHeight: menuEntryLayout.implicitHeight
                    Layout.fillWidth: true
                    StylizedRowLayout {
                        anchors.fill: parent
                        id: menuEntryLayout
                        Layout.fillWidth: true

                        Image {
                            source: menuEntry.modelData.icon
                            sourceSize.width: Sizes.iconSize
                            sourceSize.height: Sizes.iconSize
                            visible: !menuEntry.modelData.isSeparator && menuEntry.modelData.icon !== ""
                        }

                        StylizedText {
                            Layout.fillWidth: true
                            color: menuItemMouseArea.containsMouse ? Colors.hover : Colors.foreground
                            text: menuEntry.modelData.text
                            visible: !menuEntry.modelData.isSeparator
                        }

                        StylizedCenterText {
                            id: menuIndicatorText
                            visible: !menuEntry.modelData.isSeparator
                            Layout.minimumWidth: Fonts.size
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: menuItemMouseArea.containsMouse ? Colors.hover : Colors.foreground
                            text: {
                                if (menuEntry.modelData.buttonType === QsMenuButtonType.None) {
                                    return menuEntry.modelData.hasChildren ? "" : "";
                                }
                                if (menuEntry.modelData.buttonType === QsMenuButtonType.CheckBox) {
                                    return menuEntry.modelData.checkState === Qt.Checked ? "" : "";
                                }
                                return menuEntry.modelData.checkState === Qt.Checked ? "" : "";
                            }
                        }

                        Rectangle {
                            id: menuSeparator
                            Layout.fillWidth: true
                            visible: menuEntry.modelData.isSeparator
                            implicitHeight: Sizes.borderWidth
                            color: Colors.foreground
                        }
                    }
                    MouseArea {
                        id: menuItemMouseArea
                        visible: !menuEntry.modelData.isSeparator
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            if (menuEntry.modelData.hasChildren) {
                                childMenuLoader.setSource("TrayMenu.qml", {
                                    menuHandle: menuEntry.modelData,
                                    parentMenu: menuWindow,
                                    anchorX: menuWindow.anchor.rect.x + menuWindow.width,
                                    anchorY: menuWindow.anchor.rect.y + menuEntry.mapToItem(menuWindowBg, 0, 0).y
                                });
                                childMenuLoader.active = true;
                                menuWindow.childMenu = childMenuLoader.item;
                                menuWindow.childMenu.visible = true;
                            }
                        }

                        onExited: {
                            if (menuWindow.childMenu) {
                                menuWindow.childMenu.startSelfCloseTimer();
                            }
                        }

                        onClicked: {
                            menuEntry.modelData.triggered();
                            menuWindow.reload();
                        }
                    }
                }
            }
        }
    }

    HoverHandler {
        id: menuHover

        onHoveredChanged: {
            if (hovered) {
                stopSelfCloseTimer();
            } else {
                startSelfCloseTimer();
            }
        }
    }

    Timer {
        id: selfCloseTimer
        interval: 500
        repeat: false
        onTriggered: closeSelf()
    }

    function closeSelf() {
        destroyChild();
        if (menuHover.hovered) {
            return;
        }
        if (parentMenu) {
            parentMenu.destroyChild();
            parentMenu.closeSelf();
        } else {
            visible = false;
        }
    }

    function destroyChild() {
        if (childMenu) {
            childMenu.destroyChild();
            childMenuLoader.active = false;
            childMenu = null;
        }
    }

    function startSelfCloseTimer(interval = 500) {
        selfCloseTimer.interval = interval;
        selfCloseTimer.start();
    }

    function stopSelfCloseTimer() {
        if (parentMenu) {
            parentMenu.stopSelfCloseTimer();
        }
        selfCloseTimer.stop();
    }

    function toggleVisibility() {
        if (visible) {
            closeSelf();
        } else {
            visible = true;
            startSelfCloseTimer(2000);
        }
    }
}
