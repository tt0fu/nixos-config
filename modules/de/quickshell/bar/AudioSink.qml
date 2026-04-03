import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

PaddedRect {
    id: audioSink
    level: 1

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
        onWheel: wheelEvent => {
            if (wheelEvent.angleDelta.y > 0) {
                Pipewire.defaultAudioSink.audio.volume = Math.min(Pipewire.defaultAudioSink.audio.volume + 0.05, 1.5);
            }
            if (wheelEvent.angleDelta.y < 0) {
                Pipewire.defaultAudioSink.audio.volume -= 0.05;
            }
        }
    }

    child: CenterText {
        id: audioSinkText
        property real volume: Pipewire.defaultAudioSink.audio.volume

        text: Pipewire.defaultAudioSink.audio.muted ? "" : ((volume * 3 >= 2 ? "" : (volume * 3 <= 1 ? "" : "")) + " " + Math.round(volume * 100) + "%")
    }

    Behavior on implicitWidth {
        MyNumberAnimation {}
    }
}
