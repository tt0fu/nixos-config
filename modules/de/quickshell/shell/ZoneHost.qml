import qs
import "config"
import "stylized"
import QtQuick

Item {
    id: host

    property string zone: ""
    property bool open: false

    property real viewX: 0
    property real viewY: 0
    property real viewWidth: 0
    property real viewHeight: 0
    property real screenWidth: viewX + viewWidth
    property real screenHeight: viewY + viewHeight

    property bool hasAnchorX: false
    property real anchorX: 0
    property bool anchorRight: false

    readonly property real viewRight: viewX + viewWidth
    readonly property real viewBottom: viewY + viewHeight
    readonly property Item content: children.length > 0 ? children[0] : null
    readonly property bool hasContent: content ? content.implicitWidth > 0.5 && content.implicitHeight > 0.5 : false

    readonly property bool zoneAvailable: {
        const currentOwner = Zones.owners[zone];
        return zone !== "" && (currentOwner === undefined || currentOwner === host);
    }

    signal evicted()

    implicitWidth: content ? content.implicitWidth + Sizes.gap * 2 : 0
    implicitHeight: content ? content.implicitHeight + Sizes.gap * 2 : 0
    width: implicitWidth
    height: implicitHeight

    x: targetX
    y: targetY
    opacity: open && zoneAvailable && hasContent ? 1 : 0

    property bool animateGeometry: true

    property bool sizeChanging: false

    Timer {
        id: sizeSettledTimer
        interval: Animations.duration + 100
        onTriggered: host.sizeChanging = false
    }

    function noteSizeChange() {
        host.sizeChanging = true;
        sizeSettledTimer.restart();
    }

    onImplicitWidthChanged: host.noteSizeChange()
    onImplicitHeightChanged: host.noteSizeChange()

    readonly property real targetX: {
        if (zone === "left" || zone === "top-left" || zone === "bottom-left")
            return open ? 0 : -width;
        if (zone === "right" || zone === "top-right" || zone === "bottom-right")
            return open ? screenWidth - width : screenWidth;
        if (zone === "top" || zone === "bottom") {
            if (hasAnchorX) {
                const anchoredX = anchorRight ? anchorX - width : anchorX;
                return Math.max(viewX, Math.min(anchoredX, viewRight - width));
            }
            const centered = viewX + (viewWidth - width) / 2;
            return Math.max(viewX, Math.min(centered, viewRight - width));
        }
        return viewX;
    }

    readonly property real targetY: {
        if (zone === "top" || zone === "top-left" || zone === "top-right")
            return open ? viewY : viewY - height;
        if (zone === "bottom" || zone === "bottom-left" || zone === "bottom-right")
            return open ? screenHeight - height : screenHeight;
        if (zone === "left" || zone === "right") {
            const centered = viewY + (viewHeight - height) / 2;
            return Math.max(viewY, Math.min(centered, viewBottom - height));
        }
        return viewY;
    }

    function updateRegistration() {
        if (open && zone !== "" && Zones.isValidZone(zone))
            Zones.request(zone, host);
        else
            Zones.releaseAllFor(host);
    }

    onOpenChanged: host.updateRegistration()
    onZoneChanged: {
        animateGeometry = false;
        Qt.callLater(() => host.animateGeometry = true);
        host.updateRegistration();
    }
    Component.onCompleted: host.updateRegistration()
    Component.onDestruction: Zones.releaseAllFor(host)

    Connections {
        target: Zones

        function onEvicted(zone, previousOwner) {
            if (previousOwner === host)
                host.evicted();
        }
    }

    Behavior on x {
        enabled: host.animateGeometry && !host.sizeChanging
        StylizedNumberAnimation {}
    }
    Behavior on y {
        enabled: host.animateGeometry && !host.sizeChanging
        StylizedNumberAnimation {}
    }
    Behavior on width {
        StylizedNumberAnimation {}
    }
    Behavior on height {
        StylizedNumberAnimation {}
    }
    Behavior on opacity {
        StylizedNumberAnimation {}
    }
}
