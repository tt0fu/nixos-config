import "stylized"
import QtQuick
import Quickshell.Io
import Quickshell.Networking

StylizedPaddedRectangle {
    id: network
    level: 0

    readonly property var devices: Networking.devices.values

    readonly property var wiredDevice: {
        for (const device of devices)
            if (device.type === DeviceType.Wired && device.connected)
                return device;
        return null;
    }

    readonly property var wifiNetwork: {
        const device = devices.find(d => d.type === DeviceType.Wifi);
        if (!device)
            return null;
        for (const net of device.networks.values)
            if (net.connected)
                return net;
        return null;
    }

    property string statusText: {
        if (wiredDevice)
            return "\uef44";
        if (wifiNetwork)
            return "\uf1eb " + Math.round(wifiNetwork.signalStrength * 100) + "%";
        return "\u{F1790}";
    }

    Process {
        id: nmguiProc
        command: ["nmgui"]
        running: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: nmguiProc.running = true
    }

    child: StylizedCenterText {
        anchors.fill: parent
        text: network.statusText
    }

    Behavior on implicitWidth {
        StylizedNumberAnimation {}
    }
}
