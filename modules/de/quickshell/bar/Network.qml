import QtQuick
import Quickshell.Io

PaddedRect {
    id: network

    property string statusText: "󱞐"

    Process {
        id: networkStatusProc
        command: ["sh", "-c", "active=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | head -n1)\n" + "if [ -z \"$active\" ]; then\n" + "    echo '󱞐'\n" + "else\n" + "    IFS=':' read -r name type device <<< \"$active\"\n" + "    if [ \"$type\" = '802-11-wireless' ]; then\n" + "        signal=$(nmcli -t -f SIGNAL device show \"$device\" | cut -d: -f2)\n" + "        echo \" $signal\"\n" + "    elif [ \"$type\" = '802-3-ethernet' ]; then\n" + "        echo ''\n" + "    else\n" + "        echo '󱞐'\n" + "    fi\n" + "fi"]
        stdout: SplitParser {
            onRead: data => {
                var trimmed = data.trim();
                if (trimmed !== "")
                    network.statusText = trimmed;
            }
        }
        running: true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: networkStatusProc.running = true
    }

    Process {
        id: nmguiProc
        command: ["nmgui"]
        running: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            nmguiProc.running = true;
        }
    }

    child: CenterText {
        id: statusDisplay
        text: statusText
    }
}
