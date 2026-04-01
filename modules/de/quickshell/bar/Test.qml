import QtQuick
import "Oklab.js" as Oklab

PaddedRect {
    id: test

    property real val: 0.0
    
    MouseArea {
        id: testMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onWheel: wheelEvent => {
            val = Math.min(1, Math.max(0, val + wheelEvent.angleDelta.y / 10000.0));
        }
    }

    child: CenterText {
        id: testText
        text: val.toPrecision(3)
        color: Oklab.red_to_green(val);
    }
    
    Behavior on implicitWidth {
        MyNumberAnimation {}
    }
}
