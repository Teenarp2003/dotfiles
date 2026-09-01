import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
  id: win
  visible: MorphTune.visible
  color: "transparent"
  implicitWidth: 316
  implicitHeight: 168
  exclusiveZone: 0
  WlrLayershell.namespace: "quickshell-morph-tune"
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  anchors {
    bottom: true
    right: true
  }
  margins {
    bottom: 24
    right: 24
  }

  Rectangle {
    anchors.fill: parent
    radius: 16
    color: Colors.background

    Column {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 12

      Row {
        width: parent.width
        spacing: 8

        Text {
          width: parent.width - 28
          text: "morph tune  ·  Super+Shift+M"
          color: Colors.muted
          font.family: "Cascadia Code NF"
          font.pixelSize: 11
        }

        Text {
          text: "close"
          color: Colors.accent
          font.family: "Cascadia Code NF"
          font.pixelSize: 11

          MouseArea {
            anchors.fill: parent
            anchors.margins: -6
            onClicked: MorphTune.visible = false
          }
        }
      }

      TuneRow {
        label: "neckHeight"
        valueText: String(MorphTune.neckHeight)
        from: 0
        to: 48
        value: MorphTune.neckHeight
        onMoved: MorphTune.neckHeight = Math.round(v)
      }

      TuneRow {
        label: "blendK"
        valueText: MorphTune.blendK.toFixed(1)
        from: 0
        to: 80
        value: MorphTune.blendK
        onMoved: MorphTune.blendK = Math.round(v * 10) / 10
      }

      Text {
        width: parent.width
        wrapMode: Text.Wrap
        color: Colors.muted
        font.family: "Cascadia Code NF"
        font.pixelSize: 10
        text: "MorphBubble.qml  ·  neckHeight: " + MorphTune.neckHeight + "  ·  blendK: " + MorphTune.blendK.toFixed(1)
      }
    }
  }

  component TuneRow: Column {
    id: row
    property string label
    property string valueText
    property real from
    property real to
    property real value
    signal moved(real v)
    width: parent.width
    spacing: 6

    Row {
      width: parent.width
      Text {
        width: parent.width - 56
        text: row.label
        color: Colors.foreground
        font.family: "Cascadia Code NF"
        font.pixelSize: 13
        font.weight: Font.DemiBold
      }
      Text {
        width: 56
        text: row.valueText
        color: Colors.accent
        font.family: "Cascadia Code NF"
        font.pixelSize: 13
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignRight
      }
    }

    Rectangle {
      id: track
      width: parent.width
      height: 18
      radius: 9
      color: Colors.surfaceInteractive

      Rectangle {
        width: Math.max(18, (row.value - row.from) / Math.max(0.001, row.to - row.from) * parent.width)
        height: parent.height
        radius: 9
        color: Colors.accent
      }

      MouseArea {
        anchors.fill: parent
        onPressed: row.setFromX(mouse.x)
        onPositionChanged: {
          if (pressed)
            row.setFromX(mouse.x)
        }
      }
    }

    function setFromX(x) {
      const t = Math.max(0, Math.min(1, x / track.width))
      row.moved(row.from + t * (row.to - row.from))
    }
  }
}
