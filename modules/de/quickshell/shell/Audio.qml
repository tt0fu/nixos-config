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
            id: sinkDisplay
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            PwObjectTracker {
                objects: [Pipewire.defaultAudioSink]
            }

            property PwNodeAudio nodeAudio: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null
            text: nodeAudio ? AudioIcon.sinkText(nodeAudio.volume, nodeAudio.muted) : ""

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onClicked: {
                    if (!sinkDisplay.nodeAudio)
                        return;
                    sinkDisplay.nodeAudio.muted = !sinkDisplay.nodeAudio.muted;
                }
                onWheel: wheelEvent => {
                    if (!sinkDisplay.nodeAudio)
                        return;
                    if (wheelEvent.angleDelta.y > 0)
                        sinkDisplay.nodeAudio.volume = Math.min(sinkDisplay.nodeAudio.volume + 0.05, 1.5);
                    if (wheelEvent.angleDelta.y < 0)
                        sinkDisplay.nodeAudio.volume -= 0.05;
                }
            }
        }
        StylizedCenterText {
            id: sourceDisplay
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            PwObjectTracker {
                objects: [Pipewire.defaultAudioSource]
            }

            property PwNodeAudio nodeAudio: Pipewire.defaultAudioSource ? Pipewire.defaultAudioSource.audio : null
            text: nodeAudio ? AudioIcon.sourceText(nodeAudio.volume, nodeAudio.muted) : ""

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onClicked: {
                    if (!sourceDisplay.nodeAudio)
                        return;
                    sourceDisplay.nodeAudio.muted = !sourceDisplay.nodeAudio.muted;
                }
                onWheel: wheelEvent => {
                    if (!sourceDisplay.nodeAudio)
                        return;
                    if (wheelEvent.angleDelta.y > 0)
                        sourceDisplay.nodeAudio.volume = Math.min(sourceDisplay.nodeAudio.volume + 0.05, 1.5);
                    if (wheelEvent.angleDelta.y < 0)
                        sourceDisplay.nodeAudio.volume -= 0.05;
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
