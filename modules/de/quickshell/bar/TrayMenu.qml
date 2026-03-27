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

    anchor.window: root
    anchor.rect.x: anchorX
    anchor.rect.y: anchorY

    implicitWidth: menuLayout.implicitWidth + root.gap * 2
    implicitHeight: menuLayout.implicitHeight + root.gap * 2

    color: "transparent"

    Loader {
        id: childMenuLoader
        active: false
    }

    Rectangle {
        id: menuWindowBg
        anchors.fill: parent
        color: root.colBg
        border.color: root.colBorder
        border.width: root.borderWidth
        radius: root.borderRadius

        QsMenuOpener {
            id: menuOpener
            menu: menuHandle
        }
        ColumnLayout {
            id: menuLayout
            anchors.fill: parent
            anchors.margins: root.gap
            spacing: root.gap

            Component {
                id: menuSeparator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: root.borderWidth
                    color: root.colFg
                }
            }

            Component {
                id: menuButton
                Item {
                    id: menuButtonRoot

                    property int offset

                    Layout.fillWidth: true

                    implicitWidth: menuButtonRow.implicitWidth
                    implicitHeight: menuButtonRow.implicitHeight

                    RowLayout {
                        id: menuButtonRow
                        width: parent.width
                        spacing: root.gap

                        Image {
                            source: modelData.icon
                            sourceSize.width: root.iconSize
                            sourceSize.height: root.iconSize
                            visible: modelData.icon !== ""
                        }

                        MyText {
                            Layout.fillWidth: true
                            color: menuItemMouseArea.containsMouse ? root.colHover : root.colFg
                            text: modelData.text
                        }

                        MyText {
                            id: menuIndicatorText
                            Layout.minimumWidth: root.fontSize
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: menuItemMouseArea.containsMouse ? root.colHover : root.colFg
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
                                childMenuLoader.setSource("TrayMenu.qml", {
                                    menuHandle: modelData,
                                    parentMenu: menuWindow,
                                    anchorX: menuWindow.anchor.rect.x + menuWindow.width,
                                    anchorY: menuWindow.anchor.rect.y + menuButtonRoot.mapToItem(menuWindowBg, 0, 0).y
                                });
                                childMenuLoader.active = true;
                                childMenu = childMenuLoader.item;
                                childMenu.visible = true;
                            }
                        }

                        onExited: {
                            if (childMenu) {
                                childMenu.startSelfCloseTimer();
                            }
                        }

                        onClicked: {
                            modelData.triggered();
                            reloadTrayMenu();
                        }
                    }
                }
            }
            Repeater {
                model: menuOpener.children

                Loader {
                    id: menuButtonLoader
                    required property QsMenuEntry modelData
                    Layout.fillWidth: true
                    sourceComponent: modelData.isSeparator ? menuSeparator : menuButton
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
