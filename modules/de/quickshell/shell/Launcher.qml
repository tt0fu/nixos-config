import "config"
import "stylized"
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell

StylizedColumnLayout {
    id: launcher
    anchors.margins: Sizes.gap

    GlobalShortcut {
        appid: "quickshell"
        name: "toggleLauncher"
        description: "Toggle app launcher"
        onPressed: {
            GlobalState.appLauncherOpened = !GlobalState.appLauncherOpened;
            if (GlobalState.appLauncherOpened) {
                launcherTextField.text = "";
            }
        }
    }

    property list<DesktopEntry> foundEntries: DesktopEntries.applications.values.filter(e => e.name.toLowerCase().includes(launcherTextField.text.toLowerCase()))

    property int maxItemCount: 10
    property int offset: 0
    property int target: 0
    property list<DesktopEntry> displayedEntries: foundEntries.slice(offset, offset + maxItemCount)

    Keys.onEscapePressed: GlobalState.appLauncherOpened = false
    Keys.onDownPressed: {
        target++;
        if (target >= displayedEntries.length) {
            target--;
            offset = Math.min(offset + 1, foundEntries.length - maxItemCount);
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
            id: launcherTextField
            focus: GlobalState.appLauncherOpened
            anchors.fill: parent
            placeholderText: "Search for desktop items"
            onTextChanged: launcher.target = 0
            onAccepted: {
                launcher.displayedEntries[launcher.target].execute();
                GlobalState.appLauncherOpened = false;
            }
        }
    }

    StylizedPaddedRectangle {
        id: entriesArea
        visible: launcher.foundEntries.length > 0
        Layout.fillWidth: true
        level: 1
        child: StylizedColumnLayout {
            anchors.fill: parent
            anchors.margins: Sizes.gap
            Repeater {
                id: displayedEntriesRepeater
                model: launcher.displayedEntries.length
                StylizedPaddedRectangle {
                    id: launcherEntry
                    required property int index
                    property DesktopEntry entry: launcher.displayedEntries[index]
                    level: 2
                    Layout.fillWidth: true
                    border.color: index === target ? Colors.border : (launcherEntryMouseArea.containsMouse ? Colors.hover : Colors.muted)
                    child: StylizedRowLayout {
                        anchors.fill: parent
                        anchors.margins: Sizes.gap
                        Layout.fillWidth: true
                        Image {
                            source: Quickshell.iconPath(launcherEntry.entry.icon, true)
                            sourceSize.width: Sizes.iconSize
                            sourceSize.height: Sizes.iconSize
                            visible: source !== ""
                        }
                        StylizedText {
                            text: launcherEntry.entry.name
                            Layout.fillWidth: true
                        }
                    }
                    MouseArea {
                        id: launcherEntryMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            GlobalState.appLauncherOpened = false;
                            launcherEntry.modelData.execute();
                        }
                    }
                }
            }
        }
        Behavior on width {
            StylizedNumberAnimation {}
        }
        Behavior on height {
            StylizedNumberAnimation {}
        }
    }
}
