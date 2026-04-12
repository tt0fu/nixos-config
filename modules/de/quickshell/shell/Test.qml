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
            val = Math.min(1, Math.max(0, test.val + wheelEvent.angleDelta.y / 5000.0));
        }
    }

    child: StylizedCenterText {
        anchors.fill: parent
        text: test.val.toPrecision(3)
        color: Oklab.red_to_green(test.val)
    }

    Behavior on implicitWidth {
        StylizedNumberAnimation {}
    }
}
