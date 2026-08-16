import QtQuick
import Quickshell
import Quickshell.Hyprland
import "config"
import "stylized"

Item {
    id: root

    required property var context

    SystemClock {
        id: systemClock
        precision: SystemClock.Seconds
    }

    MouseArea {
        anchors.fill: parent
    }

    StylizedCenterText {
        id: clockText
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: dateText.top
            bottomMargin: Sizes.gap
        }
        text: Qt.formatDateTime(systemClock.date, "HH:mm:ss")
        font.pixelSize: Math.round(Fonts.size * 6)
        font.weight: Font.Black
    }

    StylizedCenterText {
        id: dateText
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: passwordBox.top
            bottomMargin: Sizes.gap * 2
        }
        text: Qt.formatDateTime(systemClock.date, "dddd, d MMMM")
        font.pixelSize: Math.round(Fonts.size * 3)
        color: Colors.muted
    }

    StylizedPaddedRectangle {
        id: passwordBox
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
        }
        level: 0
        child: StylizedTextField {
            id: passwordField
            anchors.fill: parent
            implicitWidth: 200
            font.pixelSize: Fonts.size * 2
            horizontalAlignment: Text.AlignHCenter
            focus: root.context.active
            enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            placeholderText: "Password"
            selectByMouse: true
            onTextChanged: root.context.currentText = text
            onAccepted: root.context.tryUnlock()
            Keys.onEscapePressed: text = ""
            Connections {
                target: root.context

                function onCurrentTextChanged() {
                    if (passwordField.text !== root.context.currentText) {
                        passwordField.text = root.context.currentText;
                    }
                }
            }
        }
    }

    StylizedCenterText {
        id: failureText
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: passwordBox.bottom
            topMargin: Sizes.gap * 2
        }
        visible: root.context.showFailure
        text: "Incorrect password"
        color: Colors.urgent
    }
}
