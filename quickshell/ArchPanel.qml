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
  property int selectedIndex: 0
  readonly property bool browsingGrid: root.query.trim().length === 0
  readonly property int gridColumns: 4

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

  function launchSelected() {
    const list = appModel.values
    if (!list || list.length === 0)
      return
    const i = Math.max(0, Math.min(list.length - 1, root.selectedIndex))
    root.launch(list[i])
  }

  function moveSelection(delta) {
    const count = appModel.values.length
    if (count <= 0)
      return
    root.selectedIndex = Math.max(0, Math.min(count - 1, root.selectedIndex + delta))
    root.ensureSelectedVisible()
  }

  function ensureSelectedVisible() {
    if (root.browsingGrid)
      appGrid.positionViewAtIndex(root.selectedIndex, GridView.Contain)
    else
      appList.positionViewAtIndex(root.selectedIndex, ListView.Contain)
  }

  function resetTransientState() {
    searchField.text = ""
    root.selectedIndex = 0
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

  onQueryChanged: root.selectedIndex = 0

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
      Keys.onReturnPressed: root.launchSelected()
      Keys.onEnterPressed: root.launchSelected()
      Keys.onPressed: event => {
        if (event.key === Qt.Key_Down) {
          root.moveSelection(root.browsingGrid ? root.gridColumns : 1)
          event.accepted = true
        } else if (event.key === Qt.Key_Up) {
          root.moveSelection(root.browsingGrid ? -root.gridColumns : -1)
          event.accepted = true
        } else if (root.browsingGrid && event.key === Qt.Key_Left) {
          root.moveSelection(-1)
          event.accepted = true
        } else if (root.browsingGrid && event.key === Qt.Key_Right) {
          root.moveSelection(1)
          event.accepted = true
        }
      }
    }
  }

  GridView {
    id: appGrid
    visible: root.browsingGrid
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
    cellWidth: Math.max(1, Math.floor(width / root.gridColumns))
    cellHeight: 86
    model: appModel
    currentIndex: root.selectedIndex
    keyNavigationEnabled: false
    focus: false

    delegate: Item {
      required property var modelData
      required property int index
      property var entry: modelData
      width: appGrid.cellWidth
      height: appGrid.cellHeight

      Rectangle {
        anchors.fill: parent
        anchors.margins: 3
        radius: 13
        color: index === root.selectedIndex || gridHover.containsMouse ? Colors.surfaceInteractive : Colors.surfaceRaised
        border.width: index === root.selectedIndex ? 1 : 0
        border.color: Colors.accent

        Column {
          anchors.centerIn: parent
          spacing: 6
          width: parent.width - 8

          AppIcon {
            anchors.horizontalCenter: parent.horizontalCenter
            size: 32
            iconName: entry && entry.icon ? entry.icon : ""
          }

          Text {
            width: parent.width
            text: (entry && entry.name) || "Unknown"
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 11
            font.weight: Font.DemiBold
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            maximumLineCount: 1
          }
        }

        MouseArea {
          id: gridHover
          anchors.fill: parent
          hoverEnabled: true
          onEntered: root.selectedIndex = index
          onClicked: root.launch(entry)
        }
      }
    }
  }

  ListView {
    id: appList
    visible: !root.browsingGrid
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
    currentIndex: root.selectedIndex
    keyNavigationEnabled: false
    focus: false

    delegate: Rectangle {
      required property var modelData
      required property int index
      property var entry: modelData
      width: appList.width
      height: 44
      radius: 13
      color: index === root.selectedIndex || appHover.containsMouse ? Colors.surfaceInteractive : Colors.surfaceRaised
      border.width: index === root.selectedIndex ? 1 : 0
      border.color: Colors.accent

      Row {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 10

        AppIcon {
          anchors.verticalCenter: parent.verticalCenter
          size: 28
          iconName: entry && entry.icon ? entry.icon : ""
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
        onEntered: root.selectedIndex = index
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
