import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "config"
import "stylized"

Item {
    id: root

    required property var context

    SystemClock {
        id: systemClock
        precision: SystemClock.Seconds
    }

    StylizedPaddedRectangle {
        id: passwordBox
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
        }
        level: 0
        StylizedCenterText {
            id: failureText
            anchors.fill: parent
            visible: root.context.showFailure
            text: "Incorrect password"
            color: Colors.urgent
        }
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
        id: dateText
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: passwordBox.top
            bottomMargin: Sizes.gap * 3
        }
        text: Qt.formatDateTime(systemClock.date, "dddd, d MMMM")
        font.pixelSize: Math.round(Fonts.size * 2)
        color: Colors.muted
    }

    StylizedCenterText {
        id: clockText
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: dateText.top
            bottomMargin: Sizes.gap
        }
        text: Qt.formatDateTime(systemClock.date, "HH:mm:ss")
        font.pixelSize: Fonts.size * 6
        font.weight: Font.Black
    }

    StylizedRowLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: passwordBox.bottom
            topMargin: Sizes.gap * 5
        }
        spacing: Sizes.gap * 10
        StylizedCenterText {
            text: "⏻"
            font.pixelSize: Fonts.size * 3
            color: shutdownMouseArea.containsMouse ? Colors.hover : Colors.foreground
            Process {
                id: shutdownProc
                command: ["shutdown", "now"]
                running: false
            }
            MouseArea {
                id: shutdownMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: shutdownProc.running = true
            }
        }
        StylizedCenterText {
            text: ""
            font.pixelSize: Fonts.size * 3
            color: rebootMouseArea.containsMouse ? Colors.hover : Colors.foreground
            Process {
                id: rebootProc
                command: ["shutdown", "now"]
                running: false
            }
            MouseArea {
                id: rebootMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: rebootProc.running = true
            }
        }
        StylizedCenterText {
            text: "󰈆"
            font.pixelSize: Fonts.size * 3
            color: exitMouseArea.containsMouse ? Colors.hover : Colors.foreground
            MouseArea {
                id: exitMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Hyprland.dispatch("hl.dsp.exit()");
            }
        }
    }
}
