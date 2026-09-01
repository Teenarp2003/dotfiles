import Quickshell.Services.UPower
import QtQuick

Item {
  id: root

  readonly property var displayDevice: UPower.displayDevice
  readonly property var packs: {
    const list = UPower.devices ? UPower.devices.values : []
    return list.filter(device => device && device.isLaptopBattery && device.isPresent)
  }
  readonly property int percent: {
    const device = root.displayDevice
    if (!device || !device.ready)
      return 0
    const value = device.percentage
    return Math.round(value <= 1 ? value * 100 : value)
  }
  readonly property bool shown: root.packs.length > 0
  readonly property bool showPercent: root.shown && root.percent !== 100

  visible: root.shown
  implicitWidth: root.shown ? content.implicitWidth : 0
  implicitHeight: 24
  height: 24
  width: implicitWidth

  function packPercent(device) {
    if (!device)
      return 0
    const value = device.percentage
    return Math.round(value <= 1 ? value * 100 : value)
  }

  function packCharging(device) {
    if (!device)
      return false
    return device.state === UPowerDeviceState.Charging || device.state === UPowerDeviceState.PendingCharge
  }

  function levelIcon(percent) {
    return Icons.battery(percent)
  }

  Row {
    id: content
    anchors.verticalCenter: parent.verticalCenter
    height: 24
    spacing: 3

    Repeater {
      model: root.packs

      delegate: Text {
        required property var modelData
        property var device: modelData
        text: root.packCharging(device) && root.packPercent(device) !== 100 ? "bolt" : root.levelIcon(root.packPercent(device))
        height: 24
        color: Colors.battery
        font.family: Icons.fontFamily
        font.pixelSize: 18
        verticalAlignment: Text.AlignVCenter
      }
    }

    Text {
      visible: root.showPercent
      text: root.percent + "%"
      height: 24
      color: Colors.foreground
      font.family: "Cascadia Code NF"
      font.pixelSize: 16
      font.weight: Font.DemiBold
      verticalAlignment: Text.AlignVCenter
    }
  }
}
