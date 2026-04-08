import qs
import "../config"
import QtQuick

StylizedRectangle {
    required property Item child
    default property list<QtObject> members

    implicitWidth: child.implicitWidth + Sizes.gap * 2
    implicitHeight: child.implicitHeight + Sizes.gap * 2
    
    data: [child, ...members]
}
