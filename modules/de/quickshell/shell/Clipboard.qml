pragma ComponentBehavior: Bound
import "config"
import "stylized"
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell
import Quickshell.Io

StylizedColumnLayout {
    id: clipboard
    anchors.margins: Sizes.gap

    GlobalShortcut {
        appid: "quickshell"
        name: "toggleClipboard"
        description: "Toggle clipboard history"
        onPressed: {
            if (!GlobalState.clipboardOpened) {
                clipboard.updateItems();
                clipboardTextField.text = "";
            }
            GlobalState.clipboardOpened = !GlobalState.clipboardOpened;
        }
    }

    Process {
        id: notificationsFetchProc
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                items = text.split('\n').filter(line => line.trim() !== "").map(line => {
                    const parts = line.split('\t');
                    return {
                        id: parseInt(parts[0], 10),
                        content: parts.length > 1 ? parts.slice(1).join('\t') : ""
                    };
                });
                updateFoundItems();
            }
        }
        running: true
    }

    Process {
        id: notificationsDecodeProc
    }

    property list<var> items: []

    property list<var> foundItems: items

    property int maxItemCount: 10
    property int offset: 0
    property int target: 0
    property list<var> displayedItems: foundItems.slice(offset, offset + maxItemCount)

    function updateItems() {
        notificationsFetchProc.running = true;
    }

    function updateFoundItems() {
        foundItems = items.filter(i => i.content.toLowerCase().includes(clipboardTextField.text.toLowerCase()));
        target = 0;
        offset = 0;
    }

    function copyEntry(id) {
        notificationsDecodeProc.command = ["sh", "-c", "cliphist decode " + id + " | wl-copy"];
        notificationsDecodeProc.running = true;
    }

    Keys.onEscapePressed: GlobalState.clipboardOpened = false
    Keys.onDownPressed: {
        target++;
        if (target >= displayedItems.length) {
            target--;
            offset = Math.min(offset + 1, foundItems.length - maxItemCount);
        }
    }
    Keys.onUpPressed: {
        target--;
        if (target < 0) {
            target++;
            offset = Math.max(offset - 1, 0);
        }
    }

    StylizedPaddedRectangle {
        Layout.fillWidth: true
        Layout.maximumWidth: 400
        level: 1
        child: StylizedTextField {
            id: clipboardTextField
            focus: GlobalState.clipboardOpened
            anchors.fill: parent
            placeholderText: "Search in clipboard history"
            onTextChanged: clipboard.updateFoundItems()
            onAccepted: {
                clipboard.copyEntry(clipboard.displayedItems[clipboard.target].id);
                GlobalState.clipboardOpened = false;
            }
        }
    }

    StylizedPaddedRectangle {
        id: entriesArea
        visible: clipboard.foundItems.length > 0
        Layout.fillWidth: true
        Layout.maximumWidth: 400
        level: 1
        child: StylizedColumnLayout {
            anchors.fill: parent
            anchors.margins: Sizes.gap
            Repeater {
                id: displayedItemsRepeater
                model: clipboard.displayedItems
                StylizedPaddedRectangle {
                    id: clipboardEntry
                    required property int index
                    required property var modelData
                    property var entry: modelData
                    level: 2
                    Layout.fillWidth: true
                    border.color: index === target ? Colors.border : (clipboardEntryMouseArea.containsMouse ? Colors.hover : Colors.muted)
                    child: StylizedRowLayout {
                        anchors.fill: parent
                        anchors.margins: Sizes.gap
                        Layout.fillWidth: true
                        StylizedText {
                            text: clipboardEntry.entry.content
                            wrapMode: Text.Wrap
                            Layout.fillWidth: true
                        }
                    }
                    MouseArea {
                        id: clipboardEntryMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            GlobalState.clipboardOpened = false;
                            clipboard.copyEntry(clipboardEntry.entry.id);
                        }
                    }
                }
            }
        }
        Behavior on implicitWidth {
            StylizedNumberAnimation {}
        }
        Behavior on implicitHeight {
            StylizedNumberAnimation {}
        }
    }
}
