pragma ComponentBehavior: Bound
import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Notifications

StylizedColumnLayout {
    id: notifications
    anchors.fill: parent
    anchors.margins: Sizes.gap

    NotificationServer {
        id: notifServer
        bodyHyperlinksSupported: false
        bodyMarkupSupported: true
        inlineReplySupported: true
        keepOnReload: true
        persistenceSupported: true
        actionsSupported: true
        bodySupported: true
        bodyImagesSupported: false
        imageSupported: true
        actionIconsSupported: true

        onNotification: notif => {
            notif.tracked = true;
        }
    }

    Repeater {
        model: notifServer.trackedNotifications
        StylizedPaddedRectangle {
            id: notification
            level: 1
            required property Notification modelData
            border.color: switch (modelData.urgency) {
            case NotificationUrgency.Low:
                return Colors.muted;
            case NotificationUrgency.Critical:
                return Colors.urgent;
            default:
                return Colors.border;
            }
            Layout.fillWidth: true
            Layout.maximumWidth: 400
            child: ColumnLayout {
                anchors.fill: parent
                anchors.margins: Sizes.gap
                spacing: Sizes.gap

                RowLayout {
                    spacing: Sizes.gap
                    Image {
                        source: Quickshell.iconPath(notification.modelData.appIcon, true)
                        sourceSize.width: Sizes.iconSize
                        sourceSize.height: Sizes.iconSize
                        Layout.maximumWidth: Sizes.iconSize
                        Layout.maximumHeight: Sizes.iconSize
                        visible: notification.modelData.appIcon !== ""
                    }
                    StylizedText {
                        text: notification.modelData.appName
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    Item {
                        Layout.alignment: Qt.AlignTop
                        implicitWidth: Fonts.size + Sizes.gap
                        implicitHeight: Fonts.size + Sizes.gap
                        StylizedCenterText {
                            anchors.fill: parent
                            text: ""
                            font.pixelSize: Fonts.size
                            color: notificationDismissMouseArea.containsMouse ? Colors.hover : Colors.border
                        }
                        MouseArea {
                            id: notificationDismissMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: notification.modelData.dismiss()
                        }
                    }
                }

                RowLayout {
                    Image {
                        source: notification.modelData.image
                        sourceSize.width: Sizes.iconSize
                        sourceSize.height: Sizes.iconSize
                        Layout.maximumWidth: Sizes.iconSize
                        Layout.maximumHeight: Sizes.iconSize
                        visible: notification.modelData.image !== ""
                    }
                    StylizedText {
                        text: notification.modelData.summary
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                }

                StylizedText {
                    text: notification.modelData.body
                    wrapMode: Text.Wrap
                    visible: notification.modelData.body !== ""
                    Layout.fillWidth: true
                }

                StylizedRowLayout {
                    Layout.fillWidth: true
                    visible: notification.modelData.actions.length > 0

                    Repeater {
                        model: notification.modelData.actions
                        StylizedPaddedRectangle {
                            id: notificationAction
                            Layout.fillWidth: true
                            level: 2
                            required property NotificationAction modelData
                            child: RowLayout {
                                anchors.fill: parent
                                spacing: Sizes.gap
                                Image {
                                    source: notification.modelData.hasActionIcons ? notificationAction.modelData.identifier : ""
                                    sourceSize.width: Sizes.iconSize
                                    sourceSize.height: Sizes.iconSize
                                    Layout.maximumWidth: Sizes.iconSize
                                    Layout.maximumHeight: Sizes.iconSize
                                    visible: notification.modelData.hasActionIcons
                                }
                                StylizedText {
                                    Layout.fillWidth: true
                                    text: notificationAction.modelData.text
                                    color: notificationActionMouseArea.containsMouse ? Colors.hover : Colors.foreground
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    wrapMode: Text.Wrap
                                }
                            }
                            border.color: notificationActionMouseArea.containsMouse ? Colors.hover : Colors.border
                            MouseArea {
                                id: notificationActionMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: notificationAction.modelData.invoke()
                            }
                        }
                    }
                }
                StylizedPaddedRectangle {
                    level: 2
                    visible: notification.modelData.hasInlineReply
                    Layout.fillWidth: true
                    child: StylizedRowLayout {
                        anchors.margins: Sizes.gap
                        anchors.fill: parent
                        StylizedTextField {
                            id: notificationInlineReplyTextField
                            Layout.fillWidth: true
                            placeholderText: notification.modelData.inlineReplyPlaceholder
                            hoverEnabled: true
                            onHoveredChanged: GlobalState.notificationTextFieldHovered = hovered
                        }

                        Item {
                            implicitWidth: Fonts.size + Sizes.gap
                            implicitHeight: Fonts.size + Sizes.gap
                            StylizedCenterText {
                                anchors.fill: parent
                                text: ""
                                color: notificationInlineReplyMouseArea.containsMouse ? Colors.hover : Colors.foreground
                            }
                            MouseArea {
                                id: notificationInlineReplyMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: notification.modelData.sendInlineReply(notificationInlineReplyTextField.text)
                            }
                        }
                    }
                }
            }
        }
    }

    StylizedPaddedRectangle {
        level: 1
        Layout.fillWidth: true
        visible: notifServer.trackedNotifications.values.length > 0
        child: StylizedCenterText {
            anchors.fill: parent
            text: "Dismiss all"
            color: dismissAllMouseArea.containsMouse ? Colors.hover : Colors.foreground
        }
        border.color: dismissAllMouseArea.containsMouse ? Colors.hover : Colors.border
        MouseArea {
            id: dismissAllMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                while (notifServer.trackedNotifications.values.length > 0) {
                    notifServer.trackedNotifications.values[0].dismiss();
                }
            }
        }
    }
}
