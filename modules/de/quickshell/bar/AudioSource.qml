import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

PaddedRect {
    id: audioSource

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

    child: CenterText {
        id: audioSourceText

        text: Pipewire.defaultAudioSource.audio.muted ? "󰍭" : "󰍬 " + Math.round(Pipewire.defaultAudioSource.audio.volume * 100) + "%"
    }
}
