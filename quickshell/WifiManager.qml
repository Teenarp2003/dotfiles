import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Controls

Item {
  id: root

  property var wifiDevice: Networking.devices.values.find(device => device.type === DeviceType.Wifi)
  property var pendingForget
  property var pendingPassword
  property var savedNetworks: {
    const device = root.wifiDevice
    if (!device)
      return []
    return device.networks.values.filter(network => network.known)
  }
  property var displayedDiscovered: []
  property bool clearingDiscovered: false
  property int pendingDiscoveredLeaves: 0
  property var discoveredNetworks: {
    const device = root.wifiDevice
    if (!device)
      return []
    return device.networks.values.filter(network => !network.known)
  }
  readonly property int maxPanelHeight: 560
  readonly property int panelHeight: {
    const listH = Math.ceil(body.implicitHeight)
    const chromeH = Math.ceil(chrome.implicitHeight)
    const needed = chromeH + (listH > 0 ? listH + 12 : 0) + 40
    const minimum = (root.pendingForget || root.pendingPassword) ? 200 : 88
    return Math.min(root.maxPanelHeight, Math.max(minimum, needed))
  }

  implicitHeight: root.panelHeight
  clip: true

  function signalPercent(network) {
    const value = Number(network?.signalStrength)
    if (Number.isNaN(value) || value <= 0)
      return 0
    return value <= 1 ? Math.round(value * 100) : Math.round(Math.min(value, 100))
  }

  function signalIcon(percent) {
    return Icons.wifi(percent)
  }

  function needsPassword(network) {
    if (!network || network.known)
      return false
    const security = network.security
    return security !== WifiSecurityType.Open && security !== WifiSecurityType.Owe && security !== WifiSecurityType.Unknown
  }

  function connectNetwork(network) {
    if (network.stateChanging)
      return
    if (network.connected) {
      network.disconnect()
      return
    }
    if (root.needsPassword(network)) {
      root.pendingForget = null
      root.pendingPassword = network
      pskInput.text = ""
      return
    }
    network.connect()
  }

  function submitPassword() {
    if (!root.pendingPassword || pskInput.text.length === 0)
      return
    root.pendingPassword.connectWithPsk(pskInput.text)
    root.pendingPassword = null
    pskInput.text = ""
  }

  function statusText() {
    if (!root.wifiDevice)
      return "No adapter found"
    if (!Networking.wifiEnabled)
      return "Wi-Fi is off"
    const active = root.wifiDevice.networks.values.find(network => network.connected)
    if (active)
      return "Connected to " + (active.name || "network")
    return "Ready to connect"
  }

  function snapshotList(list) {
    const out = []
    for (let i = 0; i < list.length; i++)
      out.push(list[i])
    return out
  }

  function beginStopScan() {
    if (!root.wifiDevice)
      return
    if (root.clearingDiscovered)
      return
    if (root.displayedDiscovered.length === 0)
      root.displayedDiscovered = root.snapshotList(root.discoveredNetworks)
    if (root.displayedDiscovered.length === 0) {
      root.wifiDevice.scannerEnabled = false
      return
    }
    root.pendingDiscoveredLeaves = root.displayedDiscovered.length
    root.clearingDiscovered = true
    root.wifiDevice.scannerEnabled = false
  }

  function finishDiscoveredLeave() {
    root.pendingDiscoveredLeaves = Math.max(0, root.pendingDiscoveredLeaves - 1)
    if (root.pendingDiscoveredLeaves > 0)
      return
    root.displayedDiscovered = []
    root.clearingDiscovered = false
  }

  onDiscoveredNetworksChanged: {
    if (root.clearingDiscovered)
      return
    if (root.wifiDevice?.scannerEnabled)
      root.displayedDiscovered = root.snapshotList(root.discoveredNetworks)
  }

  function resetTransientState() {
    root.pendingForget = null
    root.pendingPassword = null
    pskInput.text = ""
    root.displayedDiscovered = []
    root.clearingDiscovered = false
    root.pendingDiscoveredLeaves = 0
    if (root.wifiDevice)
      root.wifiDevice.scannerEnabled = false
  }

  Timer {
    id: focusTimer
    interval: 120
    onTriggered: {
      pskInput.forceActiveFocus()
      pskInput.cursorPosition = pskInput.text.length
    }
  }

  onPendingPasswordChanged: {
    if (root.pendingPassword)
      focusTimer.restart()
    else
      focusTimer.stop()
  }

  Item {
    id: shell
    anchors.fill: parent
    anchors.margins: 16

    Column {
      id: chrome
      width: parent.width
      spacing: 12

      Row {
        width: parent.width
        spacing: 10

        Column {
          width: parent.width - powerButton.width - scanButton.width - 20
          spacing: 2

          Text {
            text: "Wi-Fi"
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 18
            font.weight: Font.DemiBold
          }

          Text {
            text: root.statusText()
            color: Colors.muted
            font.family: "Cascadia Code NF"
            font.pixelSize: 12
          }
        }

        Rectangle {
          id: powerButton
          width: 76
          height: 34
          radius: 13
          color: Networking.wifiEnabled ? Colors.network : Colors.surfaceInteractive

          Text {
            anchors.centerIn: parent
            text: Networking.wifiEnabled ? "On" : "Off"
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 13
            font.weight: Font.DemiBold
          }

          MouseArea {
            anchors.fill: parent
            enabled: !!root.wifiDevice && Networking.wifiHardwareEnabled
            onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
          }
        }

        Rectangle {
          id: scanButton
          width: 36
          height: 34
          radius: 13
          color: root.wifiDevice?.scannerEnabled ? Colors.network : Colors.surfaceInteractive

          Text {
            anchors.centerIn: parent
            text: root.wifiDevice?.scannerEnabled ? "close" : "search"
            color: Colors.foreground
            font.family: Icons.fontFamily
            font.pixelSize: 17
          }

          MouseArea {
            anchors.fill: parent
            enabled: !!root.wifiDevice && Networking.wifiEnabled && !root.clearingDiscovered
            onClicked: {
              if (root.wifiDevice.scannerEnabled)
                root.beginStopScan()
              else
                root.wifiDevice.scannerEnabled = true
            }
          }
        }
      }

      Rectangle {
        visible: !!root.pendingPassword
        width: parent.width
        implicitHeight: passwordBody.implicitHeight + 24
        radius: 13
        color: Colors.surfaceRaised

        Column {
          id: passwordBody
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.margins: 12
          spacing: 8

          Text {
            text: "Enter password"
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 13
            font.weight: Font.DemiBold
          }

          Text {
            text: root.pendingPassword ? root.pendingPassword.name : ""
            color: Colors.muted
            font.family: "Cascadia Code NF"
            font.pixelSize: 11
            elide: Text.ElideRight
            width: parent.width
          }

          TextField {
            id: pskInput
            width: parent.width
            height: 34
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 13
            echoMode: TextInput.Password
            placeholderText: "Password"
            placeholderTextColor: Colors.muted
            selectByMouse: true
            activeFocusOnPress: true
            focus: visible
            leftPadding: 10
            rightPadding: 10
            background: Rectangle {
              radius: 10
              color: Colors.surfaceContainer
            }
            Keys.onEscapePressed: {
              root.pendingPassword = null
              pskInput.text = ""
            }
            onAccepted: root.submitPassword()
          }

          Row {
            anchors.right: parent.right
            spacing: 8

            Rectangle {
              width: 76
              height: 28
              radius: 14
              color: Colors.surfaceContainer

              Text { anchors.centerIn: parent; text: "Cancel"; color: Colors.foreground; font.pixelSize: 11 }
              MouseArea {
                anchors.fill: parent
                onClicked: {
                  root.pendingPassword = null
                  pskInput.text = ""
                }
              }
            }

            Rectangle {
              width: 76
              height: 28
              radius: 14
              color: Colors.network

              Text { anchors.centerIn: parent; text: "Connect"; color: Colors.foreground; font.pixelSize: 11 }
              MouseArea { anchors.fill: parent; onClicked: root.submitPassword() }
            }
          }
        }
      }
    }

    Flickable {
      id: networkList
      anchors.top: chrome.bottom
      anchors.topMargin: chrome.height > 0 ? 12 : 0
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      contentWidth: width
      contentHeight: body.implicitHeight
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      interactive: !root.pendingPassword

      Column {
        id: body
        width: networkList.width
        spacing: 12

        Text {
          visible: root.savedNetworks.length > 0
          text: "Saved networks"
          color: Colors.foreground
          font.family: "Cascadia Code NF"
          font.pixelSize: 14
          font.weight: Font.DemiBold
        }

        Column {
          visible: root.savedNetworks.length > 0
          width: parent.width
          spacing: 6

          Repeater {
            model: root.savedNetworks

            delegate: Rectangle {
              required property var modelData
              property var network: modelData
              property string stateText: ConnectionState.toString(network.state)
              property bool transitioning: network.stateChanging
              property int percent: root.signalPercent(network)
              property bool confirming: root.pendingForget === network
              width: parent ? parent.width : 0
              height: 52
              radius: 13
              color: confirming ? Colors.surfaceWarning : network.connected ? Colors.surfaceConnected : transitioning ? Colors.surfaceWarning : Colors.surfaceRaised

              Connections {
                target: network
                function onConnectionFailed(reason) {
                  if (reason === ConnectionFailReason.NoSecrets)
                    root.pendingPassword = network
                }
              }

              Column {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - actions.width - 24
                spacing: 2

                Text {
                  text: network.name || "Unknown network"
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
                    visible: !transitioning
                    text: root.signalIcon(percent)
                    color: network.connected ? Colors.network : Colors.muted
                    font.family: Icons.fontFamily
                    font.pixelSize: 14
                    verticalAlignment: Text.AlignVCenter
                  }

                  Text {
                    text: network.connected ? "Connected" : transitioning ? "Connecting..." : (percent > 0 ? percent + "%" : stateText)
                    color: network.connected ? Colors.network : transitioning ? Colors.accent : Colors.muted
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
                  color: confirming ? Colors.surfaceContainer : Colors.surfaceDanger

                  Text {
                    anchors.centerIn: parent
                    text: confirming ? "close" : "delete"
                    color: Colors.foreground
                    font.family: Icons.fontFamily
                    font.pixelSize: 17
                  }

                  MouseArea {
                    anchors.fill: parent
                    onClicked: {
                      root.pendingPassword = null
                      root.pendingForget = confirming ? null : network
                    }
                  }
                }

                Rectangle {
                  width: 34
                  height: 30
                  radius: 13
                  color: confirming ? Colors.surfaceDanger : network.connected ? Colors.surfaceDanger : Colors.network

                  Text {
                    anchors.centerIn: parent
                    text: confirming ? "check" : transitioning ? "sync" : network.connected ? "link_off" : "link"
                    color: Colors.foreground
                    font.family: Icons.fontFamily
                    font.pixelSize: 17
                  }

                  MouseArea {
                    anchors.fill: parent
                    enabled: confirming || !transitioning
                    onClicked: {
                      if (confirming) {
                        network.forget()
                        root.pendingForget = null
                      } else {
                        root.connectNetwork(network)
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
          text: "Available networks"
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
              property var network: modelData
              property string stateText: ConnectionState.toString(network.state)
              property bool transitioning: network.stateChanging
              property int percent: root.signalPercent(network)
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
                color: transitioning ? Colors.surfaceWarning : Colors.surfaceRaised

              Connections {
                target: network
                function onConnectionFailed(reason) {
                  if (reason === ConnectionFailReason.NoSecrets)
                    root.pendingPassword = network
                }
              }

              Column {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - pairButton.width - 24
                spacing: 2

                Text {
                  text: network.name || "Unknown network"
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
                    visible: !transitioning
                    text: root.signalIcon(percent)
                    color: Colors.muted
                    font.family: Icons.fontFamily
                    font.pixelSize: 14
                    verticalAlignment: Text.AlignVCenter
                  }

                  Text {
                    text: transitioning ? "Connecting..." : (percent > 0 ? percent + "%" : WifiSecurityType.toString(network.security))
                    color: transitioning ? Colors.accent : Colors.muted
                    font.family: "Cascadia Code NF"
                    font.pixelSize: 11
                  }
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
                color: Colors.network

                Text {
                  anchors.centerIn: parent
                  text: transitioning ? "sync" : "link"
                  color: Colors.foreground
                  font.family: Icons.fontFamily
                  font.pixelSize: 17
                }

                MouseArea {
                  anchors.fill: parent
                  enabled: !transitioning && !root.clearingDiscovered
                  onClicked: root.connectNetwork(network)
                }
              }
              }
            }
          }
        }
      }
    }
  }
}
