pragma ComponentBehavior: Bound
import "config"
import "stylized"
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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
            if (!GlobalState.appLauncherOpened) {
                launcherTextField.text = "";
            }
            GlobalState.appLauncherOpened = !GlobalState.appLauncherOpened;
        }
    }

    property list<DesktopEntry> foundEntries: DesktopEntries.applications.values
    property int maxListHeight: 500
    property int maxListWidth: 500

    function updateFoundEntries() {
        foundEntries = DesktopEntries.applications.values.filter(e => e.name.toLowerCase().includes(launcherTextField.text.toLowerCase()));
        entriesList.currentIndex = foundEntries.length > 0 ? 0 : -1;
        entriesList.positionViewAtIndex(0, ListView.Beginning);
    }

    function launchCurrent() {
        if (entriesList.currentIndex >= 0 && entriesList.currentIndex < entriesList.count) {
            entriesList.model[entriesList.currentIndex].execute();
            GlobalState.appLauncherOpened = false;
        }
    }

    Keys.onEscapePressed: GlobalState.appLauncherOpened = false
    Keys.onDownPressed: {
        if (entriesList.count > 0) {
            entriesList.incrementCurrentIndex();
            entriesList.positionViewAtIndex(entriesList.currentIndex, ListView.Contain);
        }
    }
    Keys.onUpPressed: {
        if (entriesList.count > 0) {
            entriesList.decrementCurrentIndex();
            entriesList.positionViewAtIndex(entriesList.currentIndex, ListView.Contain);
        }
    }
    Keys.onEnterPressed: launchCurrent()

    StylizedPaddedRectangle {
        Layout.fillWidth: true
        Layout.preferredWidth: launcher.maxListWidth
        level: 1
        child: StylizedTextField {
            id: launcherTextField
            focus: GlobalState.appLauncherOpened
            anchors.fill: parent
            placeholderText: "Search for desktop items"
            onTextChanged: launcher.updateFoundEntries()
            onAccepted: launcher.launchCurrent()
        }
    }

    StylizedPaddedRectangle {
        id: entriesArea
        visible: launcher.foundEntries.length > 0
        Layout.fillWidth: true
        Layout.preferredWidth: launcher.maxListWidth
        Layout.preferredHeight: Math.min(launcher.maxListHeight, entriesList.contentHeight + Sizes.gap * 2)
        level: 1
        child: ScrollView {
            anchors.fill: parent
            anchors.margins: Sizes.gap
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                id: entriesList
                width: parent.availableWidth
                model: launcher.foundEntries
                currentIndex: -1
                clip: true
                spacing: Sizes.gap

                delegate: StylizedPaddedRectangle {
                    id: launcherEntry
                    required property int index
                    required property DesktopEntry modelData
                    width: ListView.view.width
                    level: 2
                    border.color: {
                        if (index === entriesList.currentIndex)
                            return Colors.border;
                        if (launcherEntryMouseArea.containsMouse)
                            return Colors.hover;
                        return Colors.muted;
                    }
                    child: StylizedRowLayout {
                        anchors.fill: parent
                        anchors.margins: Sizes.gap
                        Layout.fillWidth: true
                        Image {
                            source: Quickshell.iconPath(launcherEntry.modelData.icon, true)
                            sourceSize.width: Sizes.iconSize
                            sourceSize.height: Sizes.iconSize
                            visible: source !== ""
                        }
                        StylizedText {
                            text: launcherEntry.modelData.name
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
