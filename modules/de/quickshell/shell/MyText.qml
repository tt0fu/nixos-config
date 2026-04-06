import qs
import "config"
import QtQuick

Text {
    color: Colors.foreground
    font {
        family: Fonts.family
        pixelSize: Fonts.size
    }
    text: "text"
    Behavior on color {
        MyColorAnimation {}
    }
}
