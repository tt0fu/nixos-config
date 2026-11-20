import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pam

Scope {
    id: root

    signal unlocked

    property bool active: GlobalState.locked
    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    property bool actionPending: false
    property string actionMessage: ""

    onCurrentTextChanged: showFailure = false

    function tryUnlock() {
        if (currentText === "")
            return;

        root.unlockInProgress = true;
        pam.start();
    }

    function systemAction(kind) {
        if (root.actionPending)
            return;

        root.currentText = "";
        root.actionPending = true;

        if (kind === "poweroff" || kind === "reboot") {
            root.actionMessage = kind === "poweroff" ? "Shutting down..." : "Rebooting...";
            actionProcess.command = ["system-power", kind];
            actionProcess.running = true;
        } else {
            root.actionMessage = "Exiting...";
            exitWatchdog.start();
            Hyprland.dispatch("hl.dsp.exit()");
        }
    }

    function actionFailed() {
        root.actionPending = false;
        root.actionMessage = "Action failed";
        messageClearTimer.start();
    }

    Process {
        id: actionProcess

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                root.actionFailed();
        }
    }

    Timer {
        id: exitWatchdog

        interval: 10000
        onTriggered: root.actionFailed()
    }

    Timer {
        id: messageClearTimer

        interval: 3000
        onTriggered: {
            if (!root.actionPending)
                root.actionMessage = "";
        }
    }

    PamContext {
        id: pam

        configDirectory: "pam"
        config: "password.conf"

        onPamMessage: {
            if (this.responseRequired) {
                this.respond(root.currentText);
            }
        }

        onCompleted: result => {
            if (result == PamResult.Success) {
                root.currentText = "";
                root.unlocked();
            } else {
                root.currentText = "";
                root.showFailure = true;
            }

            root.unlockInProgress = false;
        }
    }
}
