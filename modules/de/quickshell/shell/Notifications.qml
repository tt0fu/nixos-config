import qs
import "config"
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Notifications

ColumnLayout {
    id: notifications
    anchors.fill: parent
    anchors.margins: Sizes.gap
    spacing: Sizes.gap

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
        PaddedRect {
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
                    MyText {
                        text: notification.modelData.appName
                        wrapMode: Text.Wrap
                        Layout.maximumWidth: 300
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Item {
                        Layout.alignment: Qt.AlignTop
                        implicitWidth: Fonts.size + Sizes.gap
                        implicitHeight: Fonts.size + Sizes.gap
                        CenterText {
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
                    MyText {
                        text: notification.modelData.summary
                        wrapMode: Text.Wrap
                        Layout.maximumWidth: 300
                    }
                }

                MyText {
                    text: notification.modelData.body
                    wrapMode: Text.Wrap
                    visible: notification.modelData.body !== ""
                    Layout.maximumWidth: 350
                }

                RowLayout {
                    spacing: Sizes.gap
                    visible: notification.modelData.actions.length > 0

                    Repeater {
                        model: notification.modelData.actions
                        PaddedRect {
                            id: notificationAction
                            Layout.fillWidth: true
                            Layout.maximumWidth: 400
                            level: 2
                            required property NotificationAction modelData
                            child: RowLayout {
                                anchors.fill: parent
                                spacing: Sizes.gap
                                Image {
                                    source: notificationAction.modelData.hasActionIcons ? modelData.identifier : ""
                                    sourceSize.width: Sizes.iconSize
                                    sourceSize.height: Sizes.iconSize
                                    Layout.maximumWidth: Sizes.iconSize
                                    Layout.maximumHeight: Sizes.iconSize
                                    visible: notificationAction.modelData.hasActionIcons
                                }
                                MyText {
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
                PaddedRect {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 400
                    visible: notification.modelData.hasInlineReply
                    level: 2
                    child: TextField {
                        id: notificationInlineReplyTextField
                        anchors.fill: parent
                        background: null
                        color: Colors.foreground
                        placeholderTextColor: Colors.muted
                        font {
                            family: Fonts.family
                            pixelSize: Fonts.size
                        }
                        Layout.fillWidth: true
                        placeholderText: notification.modelData.inlineReplyPlaceholder
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }
                    Item {
                        anchors {
                            right: parent.right
                            rightMargin: Sizes.gap
                            verticalCenter: parent.verticalCenter
                        }
                        implicitWidth: Fonts.size + Sizes.gap
                        implicitHeight: Fonts.size + Sizes.gap
                        CenterText {
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

    PaddedRect {
        level: 1
        Layout.fillWidth: true
        visible: notifServer.trackedNotifications.values.length > 0
        child: CenterText {
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
