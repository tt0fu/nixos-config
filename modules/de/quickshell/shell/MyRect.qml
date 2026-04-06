import qs
import "config"
import QtQuick

Rectangle {
    id: myRect
    property int level: 0

    color: "transparent"
    border.color: Colors.border
    border.width: Sizes.borderWidth
    radius: Sizes.borderRadius - level * Sizes.gap
}
