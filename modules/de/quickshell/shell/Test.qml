import QtQuick
import "stylized"
import "config"
import "Oklab.js" as Oklab

StylizedPaddedRectangle {
    id: test
    level: 1

    property real val: 0.0

    MouseArea {
        id: testMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onWheel: wheelEvent => {
            val = Math.min(1, Math.max(0, val + wheelEvent.angleDelta.y / 5000.0));
        }
    }

    child: StylizedCenterText {
        anchors.fill: parent
        text: val.toPrecision(3)
        color: Oklab.red_to_green(val)
    }

    Behavior on implicitWidth {
        StylizedNumberAnimation {}
    }
}
