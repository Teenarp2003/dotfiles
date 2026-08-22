import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland
import QtQuick

Item {
  id: root

  property var ownerWindow
  property bool open: false
  property int barHeight: 40
  property var adapter: Bluetooth.defaultAdapter
  property bool bluetoothEnabled: !!root.adapter && root.adapter.enabled
  property var connectedDevice: root.bluetoothEnabled
    ? Bluetooth.devices.values.find(device => device.connected)
    : null
  property alias panel: bubble
  readonly property int collapsedWidth: compactRow.implicitWidth + 24
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

  function batteryIcon(level) {
    if (level <= 0.2)
      return "󰁻"
    if (level <= 0.5)
      return "󰁾"
    if (level <= 0.8)
      return "󰂁"
    return "󰁹"
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
    } else {
      grabTimer.stop()
      focusGrab.active = false
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
    width: root.open ? root.panelWidth : root.collapsedWidth
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

    BluetoothManager {
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
      anchors.centerIn: parent
      height: 24
      spacing: 5

      Text {
        text: root.bluetoothEnabled ? "󰂯" : "󰂲"
        height: 24
        color: root.bluetoothEnabled ? "#1793d1" : Colors.muted
        font.family: "Iosevka Nerd Font"
        font.pixelSize: 18
        verticalAlignment: Text.AlignVCenter
      }

      Text {
        visible: root.bluetoothEnabled && !!root.connectedDevice && root.connectedDevice.batteryAvailable
        text: visible ? root.batteryIcon(root.connectedDevice.battery) : ""
        height: 24
        color: Colors.battery_bluetooth
        font.family: "Iosevka Nerd Font"
        font.pixelSize: 18
        verticalAlignment: Text.AlignVCenter
      }
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.open = !root.open
    }
  }
}
