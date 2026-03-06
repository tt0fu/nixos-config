import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    // Theme
    property color colBg: "#01000000"
    property color colFg: "white"
    property color colBorder: "white"
    property color colMuted: "#808080"

    property color colActive: "white"
    property color colInactive: "#808080"
    property color colHover: "#b0b0b0"
    property color colUrgent: "#ff6060"

    property int borderWidth: 2
    property int borderRadius: 10
    property int gap: 5

    property string fontFamily: "JetBrainsMono Nerd Font Propo"
    property int fontSize: 15

    property int iconSize: 20

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: barLayout.implicitHeight
    color: "transparent"

    Rectangle {
        id: windowRect
        color: root.colBg
        border.color: root.colBorder
        border.width: root.borderWidth
        radius: root.borderRadius

        anchors.fill: parent

        Item {
            id: barLayout
            anchors.fill: parent
            anchors.margins: root.gap
            implicitHeight: Math.max(leftRow.implicitHeight, workspaces.implicitHeight, rightRow.implicitHeight) + root.gap * 2

            RowLayout {
                id: leftRow
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                spacing: root.gap

                Rectangle {
                    id: keyboard
                    implicitWidth: keyboardText.implicitWidth + root.gap * 2
                    implicitHeight: keyboardText.implicitHeight + root.gap * 2

                    color: "transparent"
                    border.color: root.colBorder
                    border.width: root.borderWidth
                    radius: root.borderRadius

                    property string layout: "EN"

                    Component.onCompleted: {
                        Hyprland.rawEvent.connect(event => {
                            if (event.name === "activelayout") {
                                keyboard.layout = event.data.split(",")[1].trim().substr(0, 2).toUpperCase();
                            }
                        });
                    }

                    Process {
                        id: keyboardSwitchProc
                        command: ["hyprctl", "switchxkblayout", "main", "next"]
                        running: false
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: keyboardSwitchProc.running = true
                    }

                    Text {
                        id: keyboardText
                        color: root.colFg
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                        }
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: keyboard.layout
                    }
                }

                Rectangle {
                    id: vpn
                    implicitWidth: vpnText.implicitWidth + root.gap * 2
                    implicitHeight: vpnText.implicitHeight + root.gap * 2

                    color: "transparent"
                    border.color: root.colBorder
                    border.width: root.borderWidth
                    radius: root.borderRadius

                    property bool enabled: false

                    Process {
                        id: vpnSwitchProc
                        command: ["pkexec", "sh", "-c", "wg-quick down config || wg-quick up config"]
                        stdout: SplitParser {
                            onRead: data => {
                                vpnDisplayProc.running = true;
                            }
                        }
                        running: false
                    }
                    Process {
                        id: vpnDisplayProc
                        command: ["sh", "-c", "ip link show config > /dev/null 2> /dev/null; echo $?"]
                        stdout: SplitParser {
                            onRead: data => {
                                vpn.enabled = parseInt(data) === 0;
                            }
                        }

                        running: true
                    }
                    Timer {
                        interval: 2000
                        running: true
                        repeat: true
                        onTriggered: {
                            vpnDisplayProc.running = true;
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            vpnSwitchProc.running = true;
                            vpnDisplayProc.running = true;
                        }
                    }

                    Text {
                        id: vpnText
                        color: root.colFg
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                        }
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: "󰖂 " + (vpn.enabled ? "" : "")
                    }
                }

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
                                property QsMenuOpener menu: QsMenuOpener {
                                    menu: modelData.menu
                                }

                                source: modelData.icon
                                sourceSize.width: root.iconSize
                                sourceSize.height: root.iconSize
                                fillMode: Image.PreserveAspectFit

                                PopupWindow {
                                    id: trayWindow
                                    anchor.window: root
                                    anchor.rect.x: trayIcon.x + trayLayout.x + tray.x + leftRow.x + barLayout.x + windowRect.x
                                    anchor.rect.y: root.implicitHeight

                                    implicitWidth: trayWindowLayout.implicitWidth + root.gap * 2
                                    implicitHeight: trayWindowLayout.implicitHeight + root.gap * 2
                                    visible: false
                                    color: "transparent"

                                    Rectangle {
                                        color: root.colBg
                                        border.color: root.colBorder
                                        border.width: root.borderWidth
                                        radius: root.borderRadius

                                        anchors.fill: parent

                                        ColumnLayout {
                                            id: trayWindowLayout
                                            anchors.fill: parent
                                            anchors.margins: root.gap
                                            spacing: root.gap
                                            Repeater {
                                                model: menu.children
                                                Item {
                                                    required property QsMenuEntry modelData

                                                    implicitWidth: modelData.isSeparator ? trayWindowLayout.implicitWidth : trayWindowItemButton.implicitWidth + root.gap * 2
                                                    implicitHeight: modelData.isSeparator ? 1 : trayWindowItemButton.implicitHeight + root.gap * 2
                                                    Rectangle {
                                                        implicitWidth: trayWindowLayout.implicitWidth
                                                        implicitHeight: 1
                                                        color: root.colFg
                                                        visible: modelData.isSeparator
                                                    }

                                                    RowLayout {
                                                        id: trayWindowItemButton
                                                        anchors.fill: parent
                                                        anchors.margins: root.gap
                                                        spacing: root.gap
                                                        visible: !modelData.isSeparator

                                                        Image {
                                                            source: modelData.icon
                                                            sourceSize.width: root.iconSize
                                                            sourceSize.height: root.iconSize
                                                            visible: modelData.icon !== ""
                                                        }

                                                        Text {
                                                            property string checkBoxIcon: modelData.checkState === Qt.Unchecked ? "" : (modelData.checkState === Qt.Checked ? "" : "󰇘")
                                                            property string radioBoxIcon: modelData.checkState === Qt.Unchecked ? "" : (modelData.checkState === Qt.Checked ? "" : "󰇘")
                                                            property string icon: modelData.buttonType === QsMenuButtonType.None ? "" : (modelData.buttonType === QsMenuButtonType.CheckBox ? checkBoxIcon : radioBoxIcon)

                                                            horizontalAlignment: Text.AlignHCenter
                                                            verticalAlignment: Text.AlignVCenter
                                                            text: modelData.text
                                                            color: trayWindowItemArea.containsMouse ? root.colHover : root.colFg
                                                            font {
                                                                family: root.fontFamily
                                                                pixelSize: root.fontSize
                                                            }
                                                        }
                                                    }

                                                    MouseArea {
                                                        id: trayWindowItemArea
                                                        anchors.fill: parent
                                                        onClicked: {
                                                            modelData.triggered();
                                                            trayWindow.visible = false;
                                                        }
                                                        onEntered: {
                                                            if (modelData.hasChildren) {
                                                                // spawn a window the with the same characteristics as menuWindow
                                                            }
                                                        }
                                                        hoverEnabled: true
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    HyprlandFocusGrab {
                                        id: menuWindowFocusGrab
                                        windows: [trayWindow]
                                        onCleared: trayWindow.visible = false
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.AllButtons
                                    onPressed: event => {
                                        if (event.buttons & Qt.LeftButton) {
                                            if (modelData.onlyMenu) {
                                                trayWindow.visible = true;
                                                menuWindowFocusGrab.active = true;
                                            } else {
                                                modelData.activate();
                                            }
                                        }
                                        if (event.buttons & Qt.RightButton) {
                                            if (modelData.hasMenu) {
                                                trayWindow.visible = true;
                                                menuWindowFocusGrab.active = true;
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
            }

            Rectangle {
                id: workspaces
                implicitWidth: workspacesLayout.implicitWidth + root.gap * 2
                implicitHeight: workspacesLayout.implicitHeight + root.gap * 2
                anchors.centerIn: parent

                color: "transparent"
                border.color: root.colBorder
                border.width: root.borderWidth
                radius: root.borderRadius

                RowLayout {
                    id: workspacesLayout
                    anchors.fill: parent
                    anchors.margins: root.gap
                    spacing: root.gap

                    Repeater {
                        model: 9

                        Rectangle {
                            id: workspace
                            color: "transparent"
                            border.width: root.borderWidth
                            radius: root.borderRadius

                            property var currentWorkspace: Hyprland.workspaces.values.find(w => w.id === index + 1)
                            property var workspaceClients: isNonEmpty ? currentWorkspace.toplevels.values : []
                            property bool isNonEmpty: currentWorkspace ? true : false
                            property bool isActive: isNonEmpty ? currentWorkspace.active : false
                            property bool isUrgent: isNonEmpty ? currentWorkspace.urgent : false
                            property bool isHover: workspaceMouseArea.containsMouse

                            border.color: isUrgent ? root.colUrgent : (isActive ? root.colActive : (isHover ? root.colHover : root.colInactive))
                            visible: isNonEmpty

                            implicitWidth: workspaceLayout.implicitWidth + root.gap * 2
                            implicitHeight: workspaceLayout.implicitHeight + root.gap * 2
                            MouseArea {
                                id: workspaceMouseArea
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch("workspace " + (index + 1))
                                hoverEnabled: true
                            }

                            RowLayout {
                                id: workspaceLayout
                                anchors.fill: parent
                                anchors.margins: root.gap
                                spacing: root.gap

                                Text {
                                    id: workspaceText
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: index + 1
                                    color: root.colFg
                                    font {
                                        family: root.fontFamily
                                        pixelSize: root.fontSize
                                    }
                                }

                                Repeater {
                                    model: workspace.workspaceClients

                                    Image {
                                        required property HyprlandToplevel modelData
                                        property string path: Quickshell.iconPath(DesktopEntries.heuristicLookup(modelData.wayland?.appId ?? "")?.icon ?? "", true)

                                        source: path === "" ? Qt.resolvedUrl("fallback-icon.svg") : path
                                        sourceSize.width: root.iconSize
                                        sourceSize.height: root.iconSize
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }
                            }
                        }
                    }
                }
            }

            RowLayout {
                id: rightRow
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                spacing: root.gap

                Rectangle {
                    id: clock
                    implicitWidth: clockText.implicitWidth + root.gap * 2
                    implicitHeight: clockText.implicitHeight + root.gap * 2

                    color: "transparent"
                    border.color: root.colBorder
                    border.width: root.borderWidth
                    radius: root.borderRadius

                    Text {
                        id: clockText
                        color: root.colFg
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                        }
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: Qt.formatDateTime(new Date(), "HH:mm:ss")
                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
                        }
                    }
                }
            }
        }
    }
}
