import "stylized"
import QtQuick
import Quickshell.Services.UPower
import "Oklab.js" as Oklab

StylizedPaddedRectangle {
    id: power
    level: 1

    visible: UPower.displayDevice.isLaptopBattery

    child: StylizedCenterText {
        anchors.fill: parent
        id: powerText
        property real charge: UPower.displayDevice.percentage

        text: (UPower.onBattery ? ["", "", "", "", ""][Math.min(Math.floor(charge * 5), 4)] : "") + " " + Math.round(charge * 100) + "%"
        color: Oklab.red_to_green(charge)
    }

    Behavior on implicitWidth {
        StylizedNumberAnimation {}
    }
}
