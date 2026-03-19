import QtQuick

Text {
    id: centerText
    color: root.colFg
    font {
        family: root.fontFamily
        pixelSize: root.fontSize
    }
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent

    text: "text"
}
