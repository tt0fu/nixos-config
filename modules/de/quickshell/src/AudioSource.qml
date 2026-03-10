import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

Rectangle {
    id: audioSource
    implicitWidth: audioSourceText.implicitWidth + root.gap * 2
    implicitHeight: audioSourceText.implicitHeight + root.gap * 2

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource]
    }

    Process {
        id: audioSourceMuteProc
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]
        running: false
    }
    Process {
        id: audioSourceIncreaseVolumeProc
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", "5%+", "--limit", "1.5"]
        running: false
    }
    Process {
        id: audioSourceDecreaseVolumeProc
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", "5%-"]
        running: false
    }
    MouseArea {
        anchors.fill: parent
        onClicked: audioSourceMuteProc.running = true
        onWheel: wheelEvent => {
            if (wheelEvent.angleDelta.y > 0) {
                audioSourceIncreaseVolumeProc.running = true;
            }
            if (wheelEvent.angleDelta.y < 0) {
                audioSourceDecreaseVolumeProc.running = true;
            }
        }
    }

    Text {
        id: audioSourceText
        color: root.colFg
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
        }
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        property int volume: Pipewire.defaultAudioSource.audio.volume * 100

        text: Pipewire.defaultAudioSource.audio.muted ? "󰍭" : "󰍬 " + volume + "%"
    }
}
