pragma ComponentBehavior: Bound

import qs
import "config"
import "stylized"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

StylizedColumnLayout {
    id: details

    required property PwNode node

    property real labelWidth: Fonts.size * 8

    readonly property var fields: {
        const node = details.node;
        const audio = node.audio;
        const result = [
            {
                label: "id",
                value: String(node.id)
            },
            {
                label: "name",
                value: node.name
            },
            {
                label: "nickname",
                value: node.nickname
            },
            {
                label: "type",
                value: PwNodeType.toString(node.type)
            }
        ];

        if (!audio) {
            result.push({
                label: "audio",
                value: "none"
            });
            return result.filter(field => field.value !== "");
        }

        result.push({
            label: "audio.muted",
            value: String(audio.muted)
        });
        result.push({
            label: "audio.volume",
            value: details.formatVolume(audio.volume)
        });
        result.push({
            label: "audio.channels",
            value: details.formatList(audio.channels.map(channel => PwAudioChannel.toString(channel)))
        });
        result.push({
            label: "audio.volumes",
            value: details.formatList(audio.volumes.map(volume => details.formatVolume(volume)))
        });
        return result.filter(field => field.value !== "");
    }

    readonly property var propertyKeys: {
        const properties = details.node.properties;
        const usefulKeys = [
            "media.class",
            "application.name",
            "application.process.binary",
            "media.name",
            "media.role",
            "device.api",
            "device.profile.name",
            "device.icon-name",
            "port.group",
            "priority.session",
            "priority.driver",
            "node.rate",
            "node.latency",
            "node.driver",
            "node.pause-on-idle"
        ];
        return usefulKeys.filter(key => properties[key] !== undefined && String(properties[key]) !== "");
    }

    function formatVolume(volume) {
        return Math.round(volume * 100) + "%";
    }

    function formatList(values) {
        return values.length > 0 ? values.join(", ") : "none";
    }

    function formatValue(value) {
        return value === undefined || value === null ? "" : String(value);
    }

    Repeater {
        model: details.fields

        StylizedKeyValueRow {
            required property var modelData

            Layout.fillWidth: true
            labelWidth: details.labelWidth
            label: modelData.label
            value: details.formatValue(modelData.value)
        }
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: Sizes.borderWidth
        color: Colors.border
        visible: details.propertyKeys.length > 0
    }

    Repeater {
        model: details.propertyKeys

        StylizedKeyValueRow {
            required property string modelData

            Layout.fillWidth: true
            labelWidth: details.labelWidth
            label: modelData
            value: details.formatValue(details.node.properties[modelData])
        }
    }
}
