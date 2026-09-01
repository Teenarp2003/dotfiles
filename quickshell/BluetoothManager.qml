import Quickshell
import Quickshell.Bluetooth
import QtQuick

Item {
  id: root

  property var adapter: Bluetooth.defaultAdapter
  property var pendingForget
  property var savedDevices: Bluetooth.devices.values.filter(device => device.paired || device.bonded)
  property var displayedDiscovered: []
  property bool clearingDiscovered: false
  property int pendingDiscoveredLeaves: 0
  property var discoveredDevices: Bluetooth.devices.values.filter(device => !device.paired && !device.bonded)
  readonly property int maxPanelHeight: 560
  readonly property int panelHeight: {
    const needed = Math.ceil(body.implicitHeight) + 40
    const minimum = root.pendingForget ? 180 : 88
    return Math.min(root.maxPanelHeight, Math.max(minimum, needed))
  }

  implicitHeight: root.panelHeight
  clip: true

  function snapshotList(list) {
    const out = []
    for (let i = 0; i < list.length; i++)
      out.push(list[i])
    return out
  }

  function beginStopScan() {
    if (!root.adapter)
      return
    if (root.clearingDiscovered)
      return
    if (root.displayedDiscovered.length === 0)
      root.displayedDiscovered = root.snapshotList(root.discoveredDevices)
    if (root.displayedDiscovered.length === 0) {
      root.adapter.discovering = false
      return
    }
    root.pendingDiscoveredLeaves = root.displayedDiscovered.length
    root.clearingDiscovered = true
    root.adapter.discovering = false
  }

  function finishDiscoveredLeave() {
    root.pendingDiscoveredLeaves = Math.max(0, root.pendingDiscoveredLeaves - 1)
    if (root.pendingDiscoveredLeaves > 0)
      return
    root.displayedDiscovered = []
    root.clearingDiscovered = false
  }

  onDiscoveredDevicesChanged: {
    if (root.clearingDiscovered)
      return
    if (root.adapter?.discovering)
      root.displayedDiscovered = root.snapshotList(root.discoveredDevices)
  }

  Flickable {
    id: deviceList
    anchors.fill: parent
    anchors.margins: 16
    contentWidth: width
    contentHeight: body.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    Column {
      id: body
      width: deviceList.width
      spacing: 12

      Row {
        width: parent.width
        spacing: 10

        Column {
          width: parent.width - powerButton.width - scanButton.width - 20
          spacing: 2

          Text {
            text: "Bluetooth"
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 18
            font.weight: Font.DemiBold
          }

          Text {
            text: root.adapter ? (root.adapter.enabled ? "Ready to connect" : "Bluetooth is off") : "No adapter found"
            color: Colors.battery_bluetooth
            font.family: "Cascadia Code NF"
            font.pixelSize: 12
          }
        }

        Rectangle {
          id: powerButton
          width: 76
          height: 34
          radius: 13
          color: root.adapter?.enabled ? Colors.battery_bluetooth : Colors.surfaceInteractive

          Text {
            anchors.centerIn: parent
            text: root.adapter?.enabled ? "On" : "Off"
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 13
            font.weight: Font.DemiBold
          }

          MouseArea {
            anchors.fill: parent
            enabled: !!root.adapter
            onClicked: root.adapter.enabled = !root.adapter.enabled
          }
        }

        Rectangle {
          id: scanButton
          width: 36
          height: 34
          radius: 13
          color: root.adapter?.discovering ? Colors.bluetooth : Colors.surfaceInteractive

          Text {
            anchors.centerIn: parent
            text: root.adapter?.discovering ? "close" : "search"
            color: Colors.foreground
            font.family: Icons.fontFamily
            font.pixelSize: 17
          }

          MouseArea {
            anchors.fill: parent
            enabled: !!root.adapter && root.adapter.enabled && !root.clearingDiscovered
            onClicked: {
              if (root.adapter.discovering)
                root.beginStopScan()
              else
                root.adapter.discovering = true
            }
          }
        }
      }

      Text {
        visible: root.savedDevices.length > 0
        text: "Saved devices"
        color: Colors.foreground
        font.family: "Cascadia Code NF"
        font.pixelSize: 14
        font.weight: Font.DemiBold
      }

      Column {
        visible: root.savedDevices.length > 0
        width: parent.width
        spacing: 6

        Repeater {
          model: root.savedDevices

          delegate: Rectangle {
            required property var modelData
            property var device: modelData
            property string stateText: BluetoothDeviceState.toString(device.state)
            property bool transitioning: device.pairing || stateText === "Connecting" || stateText === "Disconnecting"
            property bool confirming: root.pendingForget === device
            width: parent ? parent.width : 0
            height: 52
            radius: 13
            color: confirming ? Colors.surfaceWarning : device.connected ? Colors.surfaceConnected : transitioning ? Colors.surfaceWarning : Colors.surfaceRaised

            Column {
              anchors.left: parent.left
              anchors.leftMargin: 12
              anchors.verticalCenter: parent.verticalCenter
              width: parent.width - actions.width - 24
              spacing: 2

              Text {
                text: device.deviceName || device.name || "Unknown device"
                color: Colors.foreground
                font.family: "Cascadia Code NF"
                font.pixelSize: 13
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                width: parent.width
              }

              Row {
                spacing: 4
                width: parent.width

                Text {
                  visible: device.connected
                  text: "bluetooth_connected"
                  color: Colors.battery_bluetooth
                  font.family: Icons.fontFamily
                  font.pixelSize: 14
                  verticalAlignment: Text.AlignVCenter
                }

                Text {
                  text: device.connected ? "Connected" : device.pairing ? "Pairing..." : stateText
                  color: device.connected ? Colors.battery_bluetooth : transitioning ? Colors.accent : Colors.muted
                  font.family: "Cascadia Code NF"
                  font.pixelSize: 11
                }
              }
            }

            Row {
              id: actions
              anchors.right: parent.right
              anchors.rightMargin: 8
              anchors.verticalCenter: parent.verticalCenter
              spacing: 6

              Rectangle {
                width: 34
                height: 30
                radius: 13
                color: confirming ? Colors.battery_bluetooth : Colors.surfaceDanger

                Text {
                  anchors.centerIn: parent
                  text: confirming ? "close" : "delete"
                  color: Colors.foreground
                  font.family: Icons.fontFamily
                  font.pixelSize: 17
                }

                MouseArea {
                  anchors.fill: parent
                  onClicked: root.pendingForget = confirming ? null : device
                }
              }

              Rectangle {
                width: 34
                height: 30
                radius: 13
                color: confirming ? Colors.surfaceDanger : device.connected ? Colors.surfaceDanger : Colors.battery_bluetooth

                Text {
                  anchors.centerIn: parent
                  text: confirming ? "check" : transitioning ? "sync" : device.connected ? "link_off" : "link"
                  color: Colors.foreground
                  font.family: Icons.fontFamily
                  font.pixelSize: 17
                }

                MouseArea {
                  anchors.fill: parent
                  enabled: confirming || !transitioning
                  onClicked: {
                    if (confirming) {
                      device.forget()
                      root.pendingForget = null
                    } else {
                      device.connected ? device.disconnect() : device.connect()
                    }
                  }
                }
              }
            }
          }
        }
      }

      Text {
        visible: root.displayedDiscovered.length > 0
        text: "Discovered devices"
        color: Colors.foreground
        font.family: "Cascadia Code NF"
        font.pixelSize: 14
        font.weight: Font.DemiBold
      }

      Column {
        visible: root.displayedDiscovered.length > 0
        width: parent.width
        spacing: 6

        Repeater {
          model: root.displayedDiscovered

          delegate: Item {
            id: discoveredSlot
            required property var modelData
            property var device: modelData
            property string stateText: BluetoothDeviceState.toString(device.state)
            property bool transitioning: device.pairing || stateText === "Connecting" || stateText === "Disconnecting"
            width: parent ? parent.width : 0
            height: 52
            implicitHeight: height
            clip: true

            Connections {
              target: root
              function onClearingDiscoveredChanged() {
                if (!root.clearingDiscovered)
                  return
                discoveredSlot.height = discoveredSlot.height
                discoveredLeaveAnim.start()
              }
            }

            SequentialAnimation {
              id: discoveredLeaveAnim
              ParallelAnimation {
                NumberAnimation {
                  target: discoveredCard
                  property: "x"
                  to: discoveredSlot.width + 24
                  duration: 280
                  easing.type: Easing.OutCubic
                }
                NumberAnimation {
                  target: discoveredCard
                  property: "opacity"
                  to: 0
                  duration: 220
                  easing.type: Easing.OutCubic
                }
              }
              NumberAnimation {
                target: discoveredSlot
                property: "height"
                to: 0
                duration: 280
                easing.type: Easing.OutCubic
              }
              ScriptAction {
                script: root.finishDiscoveredLeave()
              }
            }

            Rectangle {
              id: discoveredCard
              width: parent.width
              height: 52
              radius: 12
              color: Colors.surfaceRaised

            Column {
              anchors.left: parent.left
              anchors.leftMargin: 12
              anchors.verticalCenter: parent.verticalCenter
              width: parent.width - pairButton.width - 24
              spacing: 2

              Text {
                text: device.deviceName || device.name || "Unknown device"
                color: Colors.foreground
                font.family: "Cascadia Code NF"
                font.pixelSize: 13
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                width: parent.width
              }

              Text {
                text: device.pairing ? "Pairing..." : stateText
                color: transitioning ? Colors.accent : Colors.muted
                font.family: "Cascadia Code NF"
                font.pixelSize: 11
              }
            }

            Rectangle {
              id: pairButton
              anchors.right: parent.right
              anchors.rightMargin: 8
              anchors.verticalCenter: parent.verticalCenter
              width: 34
              height: 30
              radius: 15
              color: Colors.bluetooth

              Text {
                anchors.centerIn: parent
                text: device.pairing || transitioning ? "sync" : "link"
                color: Colors.foreground
                font.family: Icons.fontFamily
                font.pixelSize: 17
              }

              MouseArea {
                anchors.fill: parent
                enabled: (!transitioning || device.pairing) && !root.clearingDiscovered
                onClicked: device.pairing ? device.cancelPair() : device.pair()
              }
            }
            }
          }
        }
      }
    }
  }
}
