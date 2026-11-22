import qs
import "../config"
import QtQuick
import QtQuick.Layouts

StylizedRowLayout {
    id: row

    property string label: ""
    property string value: ""
    property real labelWidth: Fonts.size * 8

    StylizedText {
        Layout.preferredWidth: row.labelWidth
        color: Colors.muted
        text: row.label
        wrapMode: Text.Wrap
    }

    StylizedText {
        Layout.fillWidth: true
        text: row.value
        wrapMode: Text.Wrap
    }
}
