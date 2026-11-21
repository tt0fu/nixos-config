pragma ComponentBehavior: Bound

import "config"
import "stylized"
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: menuList

    property var menuHandle: null
    property int depth: 0
    property int reloadCounter: 0

    signal closeRequested

    implicitWidth: menuColumn.implicitWidth
    implicitHeight: menuColumn.implicitHeight

    QsMenuOpener {
        id: opener
        menu: menuList.reloadCounter >= 0 ? menuList.menuHandle : null
    }

    function reload() {
        menuList.reloadCounter++;
    }

    StylizedColumnLayout {
        id: menuColumn
        anchors.fill: parent
        anchors.margins: Sizes.gap

        Repeater {
            model: opener.children

            ColumnLayout {
                id: entryColumn
                required property QsMenuEntry modelData

                Layout.fillWidth: true
                spacing: Sizes.gap

                property bool expanded: false

                Rectangle {
                    visible: entryColumn.modelData.isSeparator
                    Layout.fillWidth: true
                    implicitHeight: Sizes.borderWidth
                    color: Colors.foreground
                }

                Item {
                    id: entryRow
                    visible: !entryColumn.modelData.isSeparator
                    Layout.fillWidth: true
                    implicitWidth: entryLayout.implicitWidth
                    implicitHeight: entryLayout.implicitHeight

                    RowLayout {
                        id: entryLayout
                        anchors.fill: parent
                        spacing: Sizes.gap

                        Image {
                            source: entryColumn.modelData.icon
                            sourceSize.width: Sizes.iconSize
                            sourceSize.height: Sizes.iconSize
                            visible: entryColumn.modelData.icon !== ""
                        }

                        StylizedText {
                            Layout.fillWidth: true
                            color: entryMouse.containsMouse ? Colors.hover : Colors.foreground
                            text: entryColumn.modelData.text
                            opacity: entryColumn.modelData.enabled ? 1 : 0.5
                        }

                        StylizedCenterText {
                            Layout.minimumWidth: Fonts.size
                            rotation: entryColumn.modelData.hasChildren && entryColumn.expanded ? 90 : 0
                            color: entryMouse.containsMouse ? Colors.hover : Colors.foreground
                            text: {
                                if (entryColumn.modelData.buttonType === QsMenuButtonType.None)
                                    return entryColumn.modelData.hasChildren ? "" : "";
                                if (entryColumn.modelData.buttonType === QsMenuButtonType.CheckBox)
                                    return entryColumn.modelData.checkState === Qt.Checked ? "" : "";
                                return entryColumn.modelData.checkState === Qt.Checked ? "" : "";
                            }

                            Behavior on rotation {
                                StylizedNumberAnimation {}
                            }
                        }
                    }

                    MouseArea {
                        id: entryMouse
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            const entry = entryColumn.modelData;
                            if (!entry.enabled || entry.isSeparator)
                                return;

                            if (entry.hasChildren) {
                                entryColumn.expanded = !entryColumn.expanded;
                                return;
                            }

                            entry.triggered();

                            if (entry.buttonType === QsMenuButtonType.None)
                                menuList.closeRequested();
                            else
                                menuList.reload();
                        }
                    }
                }

                Item {
                    id: childContainer
                    Layout.fillWidth: true
                    visible: childLoader.active

                    implicitWidth: childLoader.implicitWidth + Sizes.gap
                    implicitHeight: childLoader.implicitHeight + Sizes.gap

                    Rectangle {
                        visible: childLoader.active
                        width: Sizes.borderWidth
                        height: parent.height
                        anchors.horizontalCenter: parent.left
                        color: Colors.foreground
                    }

                    Loader {
                        id: childLoader
                        anchors.fill: parent
                        active: entryColumn.expanded && entryColumn.modelData.hasChildren
                        source: "TrayMenuList.qml"

                        onLoaded: {
                            item.menuHandle = entryColumn.modelData;
                            item.depth = menuList.depth + 1;
                        }

                        Connections {
                            target: childLoader.item
                            function onCloseRequested() {
                                menuList.closeRequested();
                            }
                        }
                    }
                }
            }
        }
    }
}
