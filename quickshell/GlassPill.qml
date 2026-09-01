import QtQuick

Item {
  id: root

  property color fill: Colors.background
  property real radius: 17

  Rectangle {
    anchors.fill: parent
    radius: root.radius
    color: root.fill
  }

  ShaderEffect {
    anchors.fill: parent
    property real srcWidth: width
    property real srcHeight: height
    property real radius: root.radius
    fragmentShader: Qt.resolvedUrl("GlassPill.frag.qsb")
  }
}
