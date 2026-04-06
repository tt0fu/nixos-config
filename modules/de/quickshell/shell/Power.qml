import QtQuick
import Quickshell.Services.UPower
import "Oklab.js" as Oklab

PaddedRect {
    id: power
    level: 1

    visible: UPower.displayDevice.isLaptopBattery

    child: CenterText {
        id: powerText
        property real charge: UPower.displayDevice.percentage

        text: (UPower.onBattery ? ["", "", "", "", ""][Math.min(Math.floor(charge * 5), 4)] : "") + " " + Math.round(charge * 100) + "%"
        color: Oklab.red_to_green(charge)
    }

    Behavior on implicitWidth {
        MyNumberAnimation {}
    }
}
