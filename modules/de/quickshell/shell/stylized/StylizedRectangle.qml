import qs
import "../config"
import QtQuick

Rectangle {
    property int level: 0

    color: "transparent"
    border.color: Colors.border
    border.width: Sizes.borderWidth
    radius: Sizes.radiusFor(level)

    Behavior on border.color {
        StylizedColorAnimation {}
    }
}
