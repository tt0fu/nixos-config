import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

PaddedRect {
    id: audioSource
    level: 1

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Pipewire.defaultAudioSource.audio.muted = !Pipewire.defaultAudioSource.audio.muted
        onWheel: wheelEvent => {
            if (wheelEvent.angleDelta.y > 0) {
                Pipewire.defaultAudioSource.audio.volume = Math.min(Pipewire.defaultAudioSource.audio.volume + 0.05, 1.5);
            }
            if (wheelEvent.angleDelta.y < 0) {
                Pipewire.defaultAudioSource.audio.volume -= 0.05;
            }
        }
    }

    child: CenterText {
        id: audioSourceText

        text: Pipewire.defaultAudioSource.audio.muted ? "󰍭" : "󰍬 " + Math.round(Pipewire.defaultAudioSource.audio.volume * 100) + "%"
    }

    Behavior on implicitWidth {
        MyNumberAnimation {}
    }
}
