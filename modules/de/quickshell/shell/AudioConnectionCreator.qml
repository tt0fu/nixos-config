pragma ComponentBehavior: Bound

import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

StylizedPaddedRectangle {
    id: creator

    required property PwNode node
    property bool sourceSide: false

    level: 2

    readonly property var candidates: AudioNode.candidates(creator.node, creator.sourceSide)

    function addConnection(otherNode) {
        if (!otherNode)
            return;
        if (creator.sourceSide)
            AudioLinks.connect(creator.node.id, otherNode.id);
        else
            AudioLinks.connect(otherNode.id, creator.node.id);
        selector.expanded = false;
    }

    child: StylizedColumnLayout {
        anchors.fill: parent
        anchors.margins: Sizes.gap

        StylizedDisclosure {
            id: selector

            Layout.fillWidth: true
            title: "Add a connection"
        }

        StylizedColumnLayout {
            Layout.fillWidth: true
            visible: selector.expanded

            Repeater {
                model: creator.candidates

                Item {
                    id: candidate

                    required property PwNode modelData

                    Layout.fillWidth: true
                    implicitHeight: candidateRow.implicitHeight

                    StylizedRowLayout {
                        id: candidateRow
                        anchors.fill: parent

                        StylizedText {
                            Layout.fillWidth: true
                            text: candidate.modelData.description || candidate.modelData.name
                            color: candidateMouseArea.containsMouse ? Colors.hover : Colors.foreground
                            wrapMode: Text.Wrap
                        }

                        StylizedText {
                            color: Colors.muted
                            text: PwNodeType.toString(candidate.modelData.type)
                        }
                    }

                    MouseArea {
                        id: candidateMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: creator.addConnection(candidate.modelData)
                    }
                }
            }

            StylizedText {
                Layout.fillWidth: true
                visible: creator.candidates.length === 0
                color: Colors.muted
                text: "none"
            }
        }
    }
}
