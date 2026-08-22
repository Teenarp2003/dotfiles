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
  property alias panel: bubble
  readonly property int collapsedWidth: (root.connected ? compactRow.implicitWidth : offIcon.implicitWidth) + 24
  readonly property int panelWidth: 360
  readonly property int expandedInnerHeight: manager.panelHeight
  readonly property int bubbleGap: 8

  implicitWidth: root.collapsedWidth
  implicitHeight: height
  width: root.collapsedWidth
  height: root.barHeight + (root.open ? root.bubbleGap + root.expandedInnerHeight : 0)
  z: 2
  clip: false

  Behavior on height {
    NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
  }

  function signalPercent(network) {
    const value = Number(network?.signalStrength)
    if (Number.isNaN(value) || value <= 0)
      return 0
    return value <= 1 ? Math.round(value * 100) : Math.round(Math.min(value, 100))
  }

  function signalIcon() {
    const percent = root.activeNetwork ? root.signalPercent(root.activeNetwork) : 0
    if (percent >= 80)
      return "󰤥"
    if (percent >= 60)
      return "󰤢"
    if (percent >= 35)
      return "󰤟"
    if (percent > 0)
      return "󰤯"
    return "󰤯"
  }

  HyprlandFocusGrab {
    id: focusGrab
    windows: root.ownerWindow ? [root.ownerWindow] : []
    onCleared: {
      if (root.open)
        root.open = false
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
    onTriggered: focusGrab.active = true
  }

  Rectangle {
    id: bubble
    anchors.right: parent.right
    anchors.top: compact.bottom
    anchors.topMargin: root.open ? root.bubbleGap : 0
    width: root.open ? Math.max(root.panelWidth, root.collapsedWidth) : root.collapsedWidth
    height: root.open ? root.expandedInnerHeight : 0
    radius: 16
    color: Colors.background
    clip: true
    opacity: root.open ? 1 : 0
    z: 2

    Behavior on width {
      NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
    }

    Behavior on height {
      NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
    }

    Behavior on opacity {
      NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
    }

    WifiManager {
      id: manager
      anchors.fill: parent
    }
  }

  Rectangle {
    id: compact
    anchors.right: parent.right
    width: root.collapsedWidth
    height: root.barHeight
    radius: Colors.barRadius
    color: Colors.background
    z: 3

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
        font.family: "Iosevka Nerd Font"
        font.pixelSize: 18
        verticalAlignment: Text.AlignVCenter
      }
    }

    Text {
      id: offIcon
      visible: !root.connected
      anchors.centerIn: parent
      text: "󰤭 "
      color: Colors.network
      font.family: "Iosevka Nerd Font"
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
