import QtQuick
import Quickshell.Services.UPower
import "Oklab.js" as Oklab

PaddedRect {
    id: power

    visible: UPower.displayDevice.isLaptopBattery

    child: CenterText {
        id: powerText
        property real charge: UPower.displayDevice.percentage

        text: (UPower.onBattery ? ["", "", "", "", ""][Math.ceil(Math.floor(charge * 5), 4)] : "") + " " + Math.round(charge * 100) + "%"
        color: Oklab.red_to_green(charge)
    }
}
