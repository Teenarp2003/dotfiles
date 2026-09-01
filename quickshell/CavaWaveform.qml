import QtQuick

Item {
  id: root

  property int barCount: 40
  property int maxRange: 100
  readonly property var levels: CavaService.levels

  implicitHeight: 40
  height: 40

  Item {
    id: bars
    anchors.fill: parent

    Repeater {
      model: root.barCount

      delegate: Rectangle {
        required property int index
        readonly property real barWidth: Math.max(2, (bars.width - (root.barCount - 1) * 2) / root.barCount)
        x: index * (barWidth + 2)
        width: barWidth
        height: Math.max(3, bars.height * Math.min(1, (root.levels[index] || 0) / root.maxRange))
        y: bars.height - height
        radius: 2
        color: Colors.accent
      }
    }
  }
}
