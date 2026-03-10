import QtQuick
import Quickshell.Services.UPower

Rectangle {
    id: power

    implicitWidth: powerText.implicitWidth + root.gap * 2
    implicitHeight: powerText.implicitHeight + root.gap * 2

    color: "transparent"
    border.color: root.colBorder
    border.width: root.borderWidth
    radius: root.borderRadius

    visible: UPower.displayDevice.isLaptopBattery

    Text {
        id: powerText
        color: root.colFg
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
        }
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        property int charge: UPower.displayDevice.percentage * 100
        property string batteryIcon: ["", "", "", "", ""][Math.ceil(Math.floor(charge * 5 / 100), 4)]

        text: (UPower.onBattery ? batteryIcon : "") + " " + charge + "%"
    }
}
