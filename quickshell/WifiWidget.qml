import Quickshell
import Quickshell.Networking
import Quickshell.Hyprland
import QtQuick

Item {
  id: root

  property var ownerWindow
  property bool open: false
  property int barHeight: 40
  property var wifiDevice: Networking.devices.values.find(device => device.type === DeviceType.Wifi)
  property var activeNetwork: root.wifiDevice ? root.wifiDevice.networks.values.find(network => network.connected) : null
  property bool wifiEnabled: Networking.wifiEnabled
  property bool connected: root.wifiEnabled && !!root.activeNetwork
  property alias panel: morph.panel
  readonly property int collapsedWidth: (root.connected ? compactRow.implicitWidth : offIcon.implicitWidth) + 24
  readonly property int panelWidth: 360

  implicitWidth: morph.implicitWidth
  implicitHeight: morph.implicitHeight
  width: morph.width
  height: morph.height
  z: 2
  clip: false

  function signalPercent(network) {
    const value = Number(network?.signalStrength)
    if (Number.isNaN(value) || value <= 0)
      return 0
    return value <= 1 ? Math.round(value * 100) : Math.round(Math.min(value, 100))
  }

  function signalIcon() {
    return Icons.wifi(root.activeNetwork ? root.signalPercent(root.activeNetwork) : 0)
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
      manager.pendingForget = null
      manager.pendingPassword = null
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
    expandDirection: "left"

    panelContent: WifiManager {
      id: manager
      anchors.fill: parent
    }

    Row {
      id: compactRow
      visible: root.connected
      anchors.centerIn: parent
      spacing: 8

      Text {
        text: root.activeNetwork?.name || ""
        height: 24
        color: Colors.foreground
        font.family: "Cascadia Code NF"
        font.pixelSize: 15
        font.weight: Font.DemiBold
        elide: Text.ElideRight
        maximumLineCount: 1
        verticalAlignment: Text.AlignVCenter
      }

      Text {
        text: root.signalIcon()
        height: 24
        color: Colors.network
        font.family: Icons.fontFamily
        font.pixelSize: 18
        verticalAlignment: Text.AlignVCenter
      }
    }

    Text {
      id: offIcon
      visible: !root.connected
      anchors.centerIn: parent
      text: "wifi_off"
      color: Colors.network
      font.family: Icons.fontFamily
      font.pixelSize: 18
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.open = !root.open
    }
  }
}
