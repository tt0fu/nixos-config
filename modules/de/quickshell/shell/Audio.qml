import qs
import "stylized"
import "config"
import "AudioIcon.js" as AudioIcon
import QtQuick
import Quickshell.Services.Pipewire

StylizedPaddedRectangle {
    id: audio
    level: 1

    child: StylizedRowLayout {
        anchors.fill: parent
        anchors.margins: Sizes.gap

        StylizedCenterText {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            PwObjectTracker {
                objects: [Pipewire.defaultAudioSink]
            }

            property PwNodeAudio nodeAudio: Pipewire.defaultAudioSink.audio
            text: AudioIcon.sinkText(nodeAudio.volume, nodeAudio.muted)

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
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
        }
        StylizedCenterText {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            PwObjectTracker {
                objects: [Pipewire.defaultAudioSource]
            }

            property PwNodeAudio nodeAudio: Pipewire.defaultAudioSource.audio
            text: AudioIcon.sourceText(nodeAudio.volume, nodeAudio.muted)

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
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
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: {
            GlobalState.audioAdvancedAnchorX = audio.mapToItem(null, audio.width + Sizes.gap, 0).x;
            GlobalState.audioAdvancedOpened = !GlobalState.audioAdvancedOpened;
        }
    }

    Behavior on implicitWidth {
        StylizedNumberAnimation {}
    }
}
