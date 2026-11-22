import qs
import "../config"
import QtQuick

Item {
    id: slider

    property real from: 0
    property real to: 1
    property real value: 0
    property real step: 0

    property bool dragging: false
    property real draggingValue: 0

    readonly property real shownValue: slider.dragging ? slider.draggingValue : slider.value
    readonly property real ratio: {
        if (slider.to <= slider.from)
            return 0;
        return Math.max(0, Math.min(1, (slider.shownValue - slider.from) / (slider.to - slider.from)));
    }

    implicitWidth: 100
    implicitHeight: Sizes.iconSize

    signal moved(real value)

    function snapValue(value) {
        if (slider.step <= 0)
            return value;
        const steps = Math.round((value - slider.from) / slider.step);
        const snapped = slider.from + steps * slider.step;
        return Math.max(slider.from, Math.min(slider.to, Math.round(snapped * 1000000) / 1000000));
    }

    function valueAt(x) {
        if (slider.width <= 0)
            return slider.value;
        const ratio = Math.max(0, Math.min(1, x / slider.width));
        return slider.snapValue(slider.from + ratio * (slider.to - slider.from));
    }

    function moveTo(value) {
        if (value === slider.draggingValue && slider.dragging)
            return;
        slider.dragging = true;
        slider.draggingValue = value;
        slider.moved(value);
    }

    Rectangle {
        id: track

        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: Sizes.gap
        radius: height / 2
        color: Colors.muted
    }

    Rectangle {
        anchors.verticalCenter: track.verticalCenter
        width: track.width * slider.ratio
        height: track.height
        radius: track.radius
        color: Colors.foreground
    }

    MouseArea {
        id: area

        anchors.fill: parent
        hoverEnabled: true

        onPressed: mouse => slider.moveTo(slider.valueAt(mouse.x))
        onPositionChanged: mouse => {
            if (area.pressed)
                slider.moveTo(slider.valueAt(mouse.x));
        }
        onReleased: slider.dragging = false
        onCanceled: slider.dragging = false
    }
}
