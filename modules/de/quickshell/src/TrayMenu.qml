import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

PopupWindow {
    id: menuWindow

    required property QsMenuHandle menuHandle
    property TrayMenu parentMenu: null
    property TrayMenu childMenu: null

    property real anchorX: 0
    property real anchorY: 0

    QsMenuOpener {
        id: menu
        menu: menuHandle
    }

    anchor.window: root
    anchor.rect.x: anchorX
    anchor.rect.y: anchorY

    implicitWidth: menuLayout.implicitWidth + root.gap * 2
    implicitHeight: menuLayout.implicitHeight + root.gap * 2

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: root.colBg
        border.color: root.colBorder
        border.width: root.borderWidth
        radius: root.borderRadius

        ColumnLayout {
            id: menuLayout
            anchors.fill: parent
            anchors.margins: root.gap
            spacing: root.gap

            Repeater {
                id: menuRepeater
                model: menu.children

                Item {
                    required property QsMenuEntry modelData

                    implicitWidth: modelData.isSeparator ? menuLayout.implicitWidth : menuItemRow.implicitWidth + root.gap * 2
                    implicitHeight: modelData.isSeparator ? root.borderWidth : menuItemRow.implicitHeight + root.gap * 2

                    Rectangle {
                        height: root.borderWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: menuLayout.implicitWidth
                        color: root.colFg
                        visible: modelData.isSeparator
                    }

                    RowLayout {
                        id: menuItemRow
                        anchors.fill: parent
                        anchors.margins: root.gap
                        visible: !modelData.isSeparator

                        Image {
                            source: modelData.icon
                            sourceSize.width: root.iconSize
                            sourceSize.height: root.iconSize
                            visible: modelData.icon !== ""
                        }

                        MyText {
                            text: modelData.text
                        }

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

                    MouseArea {
                        id: menuItemMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            if (modelData.hasChildren) {
                                destroyChild();

                                const component = Qt.createComponent("TrayMenu.qml");

                                if (component.status === Component.Ready) {
                                    childMenu = component.createObject(root, {
                                        menuHandle: modelData,
                                        parentMenu: menuWindow,
                                        anchorX: menuWindow.anchor.rect.x + menuWindow.width,
                                        anchorY: menuWindow.anchor.rect.y + parent.y
                                    });

                                    childMenu.visible = true;
                                }
                            }
                        }

                        onExited: {
                            if (childMenu) {
                                childMenu.startSelfCloseTimer();
                            }
                        }

                        onClicked: {
                            modelData.triggered();
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
            childMenu.destroy();
            childMenu = null;
        }
    }

    function startSelfCloseTimer() {
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
        }
    }
}