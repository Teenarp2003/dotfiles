import Quickshell
import QtQuick

Item {
  id: root

  property string iconName
  property int size: 32

  width: root.size
  height: root.size

  Image {
    id: fallback
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit
    asynchronous: true
    source: root.iconName ? Quickshell.iconPath(root.iconName, true) : ""
    visible: tela.status !== Image.Ready
  }

  Image {
    id: tela
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit
    asynchronous: true
    source: Icons.telaFileUrl(root.iconName)
  }
}
