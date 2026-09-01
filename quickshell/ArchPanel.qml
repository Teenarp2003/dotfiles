import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Controls

Item {
  id: root

  readonly property int maxPanelHeight: 560
  readonly property int panelHeight: root.maxPanelHeight
  property string query: searchField.text

  signal appLaunched()

  implicitHeight: root.panelHeight
  clip: true

  function matches(entry, q) {
    if (!entry || !q)
      return true
    if ((entry.name || "").toLowerCase().includes(q))
      return true
    if ((entry.genericName || "").toLowerCase().includes(q))
      return true
    const keywords = entry.keywords || []
    for (let i = 0; i < keywords.length; i++) {
      if ((keywords[i] || "").toLowerCase().includes(q))
        return true
    }
    return false
  }

  function launch(entry) {
    if (!entry)
      return
    entry.execute()
    root.appLaunched()
  }

  function launchFirst() {
    const list = appModel.values
    if (list && list.length > 0)
      root.launch(list[0])
  }

  function resetTransientState() {
    searchField.text = ""
  }

  function focusSearch() {
    focusTimer.restart()
  }

  function profileActive(profile) {
    return PowerProfiles.profile === profile
  }

  Timer {
    id: focusTimer
    interval: 120
    onTriggered: {
      searchField.forceActiveFocus()
      searchField.cursorPosition = searchField.text.length
    }
  }

  ScriptModel {
    id: appModel
    values: {
      const q = root.query.trim().toLowerCase()
      const list = [...DesktopEntries.applications.values].sort((a, b) => (a.name || "").localeCompare(b.name || ""))
      if (!q)
        return list
      return list.filter(entry => root.matches(entry, q))
    }
  }

  Column {
    id: chrome
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 16
    spacing: 12

    Row {
      width: parent.width
      spacing: 10

      Text {
        text: "apps"
        color: Colors.accent
        font.family: Icons.fontFamily
        font.pixelSize: 22
        verticalAlignment: Text.AlignVCenter
        height: 34
      }

      Column {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Text {
          text: "Launcher"
          color: Colors.foreground
          font.family: "Cascadia Code NF"
          font.pixelSize: 18
          font.weight: Font.DemiBold
        }

        Text {
          text: appModel.values.length + " apps"
          color: Colors.muted
          font.family: "Cascadia Code NF"
          font.pixelSize: 12
        }
      }
    }

    TextField {
      id: searchField
      width: parent.width
      height: 34
      color: Colors.foreground
      font.family: "Cascadia Code NF"
      font.pixelSize: 13
      placeholderText: "Search apps"
      placeholderTextColor: Colors.muted
      selectByMouse: true
      leftPadding: 10
      rightPadding: 10
      background: Rectangle {
        radius: 10
        color: Colors.surfaceContainer
      }
      Keys.onEscapePressed: root.appLaunched()
      Keys.onReturnPressed: root.launchFirst()
      Keys.onEnterPressed: root.launchFirst()
    }
  }

  ListView {
    id: appList
    anchors.top: chrome.bottom
    anchors.topMargin: 8
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: powerChrome.top
    anchors.bottomMargin: 8
    anchors.leftMargin: 16
    anchors.rightMargin: 16
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    spacing: 4
    model: appModel

    delegate: Rectangle {
      required property var modelData
      property var entry: modelData
      width: appList.width
      height: 44
      radius: 13
      color: appHover.containsMouse ? Colors.surfaceInteractive : Colors.surfaceRaised

      Row {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 10

        Image {
          anchors.verticalCenter: parent.verticalCenter
          width: 28
          height: 28
          fillMode: Image.PreserveAspectFit
          source: entry && entry.icon ? Quickshell.iconPath(entry.icon, true) : ""
        }

        Column {
          anchors.verticalCenter: parent.verticalCenter
          width: parent.width - 38
          spacing: 1

          Text {
            text: (entry && entry.name) || "Unknown"
            width: parent.width
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 13
            font.weight: Font.DemiBold
            elide: Text.ElideRight
          }

          Text {
            visible: !!(entry && entry.genericName)
            text: (entry && entry.genericName) || ""
            width: parent.width
            color: Colors.muted
            font.family: "Cascadia Code NF"
            font.pixelSize: 11
            elide: Text.ElideRight
          }
        }
      }

      MouseArea {
        id: appHover
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.launch(entry)
      }
    }
  }

  Column {
    id: powerChrome
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 16
    spacing: 10

    Text {
      text: "Power"
      color: Colors.foreground
      font.family: "Cascadia Code NF"
      font.pixelSize: 13
      font.weight: Font.DemiBold
    }

    Row {
      width: parent.width
      spacing: 6

      Repeater {
        model: {
          const items = [
            { label: "Saver", profile: PowerProfile.PowerSaver },
            { label: "Balanced", profile: PowerProfile.Balanced }
          ]
          if (PowerProfiles.hasPerformanceProfile)
            items.push({ label: "Perf", profile: PowerProfile.Performance })
          return items
        }

        delegate: Rectangle {
          required property var modelData
          width: Math.floor((powerChrome.width - (PowerProfiles.hasPerformanceProfile ? 12 : 6)) / (PowerProfiles.hasPerformanceProfile ? 3 : 2))
          height: 30
          radius: 13
          color: root.profileActive(modelData.profile) ? Colors.accent : Colors.surfaceInteractive

          Text {
            anchors.centerIn: parent
            text: modelData.label
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 11
            font.weight: Font.DemiBold
          }

          MouseArea {
            anchors.fill: parent
            onClicked: PowerProfiles.profile = modelData.profile
          }
        }
      }
    }

    Row {
      width: parent.width
      spacing: 6

      Repeater {
        model: [
          { icon: "lock", action: "lock" },
          { icon: "bedtime", action: "suspend" },
          { icon: "restart_alt", action: "reboot" },
          { icon: "power_settings_new", action: "shutdown" },
          { icon: "logout", action: "logout" }
        ]

        delegate: Rectangle {
          required property var modelData
          width: Math.floor((powerChrome.width - 24) / 5)
          height: 34
          radius: 13
          color: Colors.surfaceInteractive

          Text {
            anchors.centerIn: parent
            text: modelData.icon
            color: Colors.foreground
            font.family: Icons.fontFamily
            font.pixelSize: 16
          }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              if (modelData.action === "lock")
                lockProc.running = true
              else if (modelData.action === "suspend")
                suspendProc.running = true
              else if (modelData.action === "reboot")
                rebootProc.running = true
              else if (modelData.action === "shutdown")
                shutdownProc.running = true
              else if (modelData.action === "logout")
                Hyprland.dispatch("exit")
              root.appLaunched()
            }
          }
        }
      }
    }
  }

  Process {
    id: lockProc
    command: ["hyprlock"]
    running: false
  }

  Process {
    id: suspendProc
    command: ["systemctl", "suspend"]
    running: false
  }

  Process {
    id: rebootProc
    command: ["systemctl", "reboot"]
    running: false
  }

  Process {
    id: shutdownProc
    command: ["systemctl", "poweroff"]
    running: false
  }
}
