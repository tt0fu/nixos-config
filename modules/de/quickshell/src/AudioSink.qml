import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

Rectangle {
    id: audioSink
    implicitWidth: audioSinkText.implicitWidth + root.gap * 2
    implicitHeight: audioSinkText.implicitHeight + root.gap * 2

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Process {
        id: audioSinkMuteProc
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        running: false
    }
    Process {
        id: audioSinkIncreaseVolumeProc
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+", "--limit", "1.5"]
        running: false
    }
    Process {
        id: audioSinkDecreaseVolumeProc
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
        running: false
    }
    MouseArea {
        anchors.fill: parent
        onClicked: audioSinkMuteProc.running = true
        onWheel: wheelEvent => {
            if (wheelEvent.angleDelta.y > 0) {
                audioSinkIncreaseVolumeProc.running = true;
            }
            if (wheelEvent.angleDelta.y < 0) {
                audioSinkDecreaseVolumeProc.running = true;
            }
        }
    }

    Text {
        id: audioSinkText
        color: root.colFg
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
        }
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        property int volume: Pipewire.defaultAudioSink.audio.volume * 100

        property string volumeIcon: volume >= 75 ? "" : (volume <= 25 ? "" : "")

        text: Pipewire.defaultAudioSink.audio.muted ? "" : volumeIcon + " " + volume + "%"
    }
}
