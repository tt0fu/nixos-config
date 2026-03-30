import QtQuick
import Quickshell.Services.UPower

PaddedRect {
    id: power

    visible: UPower.displayDevice.isLaptopBattery

    child: CenterText {
        id: powerText
        property int charge: UPower.displayDevice.percentage * 100
        property string batteryIcon: ["", "", "", "", ""][Math.ceil(Math.floor(charge * 5 / 100), 4)]

        text: (UPower.onBattery ? batteryIcon : "") + " " + charge + "%"
        color: Qt.hsva(charge / 300.0, 1, 1, 1)
    }
}
