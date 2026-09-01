import Quickshell
import Quickshell.Hyprland
import QtQuick

Item {
  id: root

  property var ownerWindow
  property bool open: false
  property int barHeight: 40
  property alias panel: morph.panel
  readonly property int collapsedWidth: root.barHeight
  readonly property int panelWidth: 360

  implicitWidth: morph.implicitWidth
  implicitHeight: morph.implicitHeight
  width: morph.width
  height: morph.height
  z: 2
  clip: false

  GlobalShortcut {
    name: "toggleLauncher"
    description: "Toggle app launcher"
    onPressed: root.open = !root.open
  }

  HyprlandFocusGrab {
    id: focusGrab
    windows: root.ownerWindow ? [root.ownerWindow] : []
    onCleared: {
      if (MorphTune.visible)
        return
      if (root.open)
        root.open = false
    }
  }

  Connections {
    target: MorphTune
    function onVisibleChanged() {
      if (MorphTune.visible) {
        grabTimer.stop()
        focusGrab.active = false
      } else if (root.open) {
        grabTimer.restart()
      }
    }
  }

  onOpenChanged: {
    if (open) {
      grabTimer.restart()
      manager.resetTransientState()
      manager.focusSearch()
    } else {
      grabTimer.stop()
      focusGrab.active = false
      manager.resetTransientState()
    }
  }

  Timer {
    id: grabTimer
    interval: 80
    onTriggered: {
      if (!MorphTune.visible)
        focusGrab.active = true
    }
  }

  MorphBubble {
    id: morph
    open: root.open
    barHeight: root.barHeight
    collapsedWidth: root.collapsedWidth
    panelWidth: root.panelWidth
    panelHeight: manager.panelHeight
    pillRadius: Colors.barRadius
    expandDirection: "right"

    panelContent: ArchPanel {
      id: manager
      anchors.fill: parent
      onAppLaunched: root.open = false
    }

    Text {
      anchors.fill: parent
      text: "apps"
      color: Colors.accent
      font.family: Icons.fontFamily
      font.pixelSize: 22
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.open = !root.open
    }
  }
}
