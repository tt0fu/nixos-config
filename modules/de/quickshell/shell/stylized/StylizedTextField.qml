import qs
import "../config"
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls


TextField {
    background: null
    color: Colors.foreground
    placeholderTextColor: Colors.muted
    font {
        family: Fonts.family
        pixelSize: Fonts.size
    }
    placeholderText: notification.modelData.inlineReplyPlaceholder
    verticalAlignment: Text.AlignVCenter
    wrapMode: Text.Wrap
}