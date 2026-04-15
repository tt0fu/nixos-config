pragma ComponentBehavior: Bound
import "config"
import "stylized"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell
import Quickshell.Io

StylizedColumnLayout {
    id: clipboard
    anchors.margins: Sizes.gap
    spacing: Sizes.gap

    GlobalShortcut {
        appid: "quickshell"
        name: "toggleClipboard"
        description: "Toggle clipboard history"
        onPressed: {
            if (!GlobalState.clipboardOpened) {
                clipboard.updateItems();
                clipboardTextField.text = "";
                itemsList.currentIndex = -1;
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
    property int maxListHeight: 500
    property int maxListWidth: 500

    function updateItems() {
        notificationsFetchProc.running = true;
    }

    function updateFoundItems() {
        foundItems = items.filter(i => i.content.toLowerCase().includes(clipboardTextField.text.toLowerCase()));
        itemsList.currentIndex = foundItems.length > 0 ? 0 : -1;
        itemsList.positionViewAtIndex(0, ListView.Beginning);
    }

    function copyEntry(id) {
        notificationsDecodeProc.command = ["sh", "-c", "cliphist decode " + id + " | wl-copy"];
        notificationsDecodeProc.running = true;
    }

    Keys.onEscapePressed: GlobalState.clipboardOpened = false
    Keys.onDownPressed: {
        if (itemsList.count > 0) {
            itemsList.incrementCurrentIndex();
            itemsList.positionViewAtIndex(itemsList.currentIndex, ListView.Contain);
        }
    }
    Keys.onUpPressed: {
        if (itemsList.count > 0) {
            itemsList.decrementCurrentIndex();
            itemsList.positionViewAtIndex(itemsList.currentIndex, ListView.Contain);
        }
    }
    Keys.onEnterPressed: {
        if (itemsList.currentIndex >= 0 && itemsList.currentIndex < itemsList.count) {
            clipboard.copyEntry(itemsList.model[itemsList.currentIndex].id);
            GlobalState.clipboardOpened = false;
        }
    }

    StylizedPaddedRectangle {
        Layout.fillWidth: true
        Layout.preferredWidth: maxListWidth
        level: 1
        child: StylizedTextField {
            id: clipboardTextField
            focus: GlobalState.clipboardOpened
            anchors.fill: parent
            placeholderText: "Search in clipboard history"
            onTextChanged: clipboard.updateFoundItems()
            onAccepted: {
                if (itemsList.currentIndex >= 0 && itemsList.currentIndex < itemsList.count)
                    clipboard.copyEntry(itemsList.model[itemsList.currentIndex].id);
                GlobalState.clipboardOpened = false;
            }
        }
    }

    StylizedPaddedRectangle {
        id: itemsArea
        visible: clipboard.foundItems.length > 0
        Layout.fillWidth: true
        Layout.preferredWidth: maxListWidth
        Layout.preferredHeight: Math.min(maxListHeight, itemsList.contentHeight + Sizes.gap * 2)
        level: 1

        child: ScrollView {
            anchors.fill: parent
            anchors.margins: Sizes.gap
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                id: itemsList
                width: parent.availableWidth
                model: clipboard.foundItems
                currentIndex: -1
                clip: true
                spacing: Sizes.gap

                delegate: StylizedPaddedRectangle {
                    id: delegateItem
                    required property int index
                    required property var modelData
                    width: ListView.view.width
                    level: 2
                    border.color: {
                        if (index === itemsList.currentIndex)
                            return Colors.border;
                        if (delegateMouseArea.containsMouse)
                            return Colors.hover;
                        return Colors.muted;
                    }

                    child: StylizedText {
                        anchors {
                            fill: parent
                            margins: Sizes.gap
                        }
                        text: modelData.content
                        wrapMode: Text.Wrap
                    }

                    MouseArea {
                        id: delegateMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            itemsList.currentIndex = index;
                            GlobalState.clipboardOpened = false;
                            clipboard.copyEntry(modelData.id);
                        }
                    }
                }
            }
        }

        Behavior on Layout.preferredHeight {
            StylizedNumberAnimation {}
        }
    }
}
