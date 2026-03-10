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

                        Text {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: modelData.text
                            color: menuItemMouseArea.containsMouse ? root.colHover : root.colFg
                            font {
                                family: root.fontFamily
                                pixelSize: root.fontSize
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Text {
                            property string checkBoxIcon: modelData.checkState === Qt.Unchecked ? "" : (modelData.checkState === Qt.Checked ? "" : "󰇘")
                            property string radioBoxIcon: modelData.checkState === Qt.Unchecked ? "" : (modelData.checkState === Qt.Checked ? "" : "󰇘")
                            property string icon: modelData.buttonType === QsMenuButtonType.None ? (modelData.hasChildren ? "" : "") : (modelData.buttonType === QsMenuButtonType.CheckBox ? checkBoxIcon : radioBoxIcon)

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: icon
                            color: menuItemMouseArea.containsMouse ? root.colHover : root.colFg
                            font {
                                family: root.fontFamily
                                pixelSize: root.fontSize
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

                        onClicked: modelData.triggered()
                    }
                }
            }
        }

        // Note that quickshell Wrappers resize their child, so this is like setting
        // the width: 600 and height: 600 in the GridLayout
        // Setting the width/height of any layout
        // is needed so that fillWidth/fillHeight works
        // WrapperRectangle {
        //     implicitWidth: 600
        //     implicitHeight: 600

        //     margin: 18
        //     radius: 20
        //     color: "grey"

        //     anchors.centerIn: parent

        //     GridLayout {
        //         columns: 3

        //         MyRect {}
        //         Text {
        //             text: "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
        //             Layout.fillWidth: true
        //         }
        //         MyRect {}

        //         Separator {}

        //         MyRect {}
        //         Text {
        //             text: "hhhhhhhhhhhhhhhhhhh"
        //             Layout.fillWidth: true
        //         }
        //         MyRect {}

        //         Separator {}

        //         MyRect {}
        //         Text {
        //             text: "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
        //             Layout.fillWidth: true
        //         }
        //         MyRect {}

        //         Separator {}

        //         // Spacer
        //         Item {
        //             Layout.columnSpan: 3
        //             Layout.fillWidth: true
        //             Layout.fillHeight: true
        //         }

        //         Separator {}

        //         MyRect {}
        //         Text {
        //             text: "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
        //             Layout.fillWidth: true
        //         }
        //         MyRect {}
        //     }
        // }
    }

    // component MyRect: Rectangle {
    //     implicitWidth: 20
    //     implicitHeight: 20
    //     radius: 2
    // }
    // component Separator: Rectangle {
    //     Layout.fillWidth: true
    //     Layout.columnSpan: 3
    //     implicitHeight: 2
    // }

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
            closeAllMenus();
        } else {
            visible = true;
            // startSelfCloseTimer();
        }
    }
}
