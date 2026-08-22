import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Item {
  id: root

  property var ownerWindow
  property int barHeight: 40
  property bool open: false
  property string artist: ""
  property string title: ""
  property string playerState: ""
  property bool available: root.playerState === "Playing" || root.playerState === "Paused" || root.playerState === "Stopped"
  readonly property var notifications: NotificationCenter.items
  readonly property int notifCount: NotificationCenter.count
  readonly property bool hasContent: root.available || root.notifCount > 0
  readonly property string compactNotifTitle: {
    if (root.notifCount <= 0)
      return ""
    const notification = root.notifications[0]
    return notification.summary || notification.appName || "Notification"
  }
  readonly property int compactMusicTextWidth: Math.max(180, Math.ceil(musicMetrics.averageCharacterWidth * 20))
  readonly property int collapsedWidth: {
    if (root.available)
      return compactMusic.implicitWidth + 36
    if (root.notifCount > 0)
      return compactNotif.implicitWidth + 36
    return 0
  }
  readonly property int expandedInnerHeight: Math.min(560, Math.max(88, Math.ceil(expandedBody.implicitHeight) + 28))
  readonly property int liveWidth: root.open ? Math.max(360, root.collapsedWidth) : root.collapsedWidth
  readonly property int liveHeight: root.barHeight + (root.open ? root.expandedInnerHeight : 0)
  property string lastNotifTitle: ""
  property int lastCollapsedWidth: 196
  property bool keepVisible: false
  readonly property bool dismissing: !root.hasContent && (root.keepVisible || root.opacity > 0.01)

  visible: root.hasContent || root.dismissing
  opacity: root.hasContent || root.keepVisible ? 1 : 0
  width: {
    if (root.hasContent)
      return root.liveWidth
    if (root.dismissing)
      return root.open ? Math.max(360, root.lastCollapsedWidth) : root.lastCollapsedWidth
    return 0
  }
  height: {
    if (root.hasContent)
      return root.liveHeight
    if (root.dismissing)
      return root.open ? root.barHeight + root.expandedInnerHeight : root.barHeight
    return 0
  }
  implicitWidth: width
  implicitHeight: height
  z: 3
  clip: true

  Behavior on opacity {
    NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
  }

  Behavior on width {
    enabled: root.hasContent || root.keepVisible
    NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
  }

  Behavior on height {
    enabled: root.hasContent || root.keepVisible
    NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
  }

  HyprlandFocusGrab {
    id: focusGrab
    windows: root.ownerWindow ? [root.ownerWindow] : []
    onCleared: {
      if (root.open)
        root.open = false
    }
  }

  onCollapsedWidthChanged: {
    if (root.collapsedWidth > 0)
      root.lastCollapsedWidth = root.collapsedWidth
  }

  onCompactNotifTitleChanged: {
    if (root.compactNotifTitle.length > 0)
      root.lastNotifTitle = root.compactNotifTitle
  }

  onHasContentChanged: {
    if (root.hasContent) {
      root.keepVisible = false
      fadeAfterCloseTimer.stop()
      return
    }
    root.keepVisible = true
    if (root.open) {
      root.open = false
      fadeAfterCloseTimer.restart()
    } else {
      root.keepVisible = false
    }
  }

  Timer {
    id: fadeAfterCloseTimer
    interval: 280
    onTriggered: root.keepVisible = false
  }

  onOpenChanged: {
    if (open)
      grabTimer.restart()
    else {
      grabTimer.stop()
      focusGrab.active = false
    }
  }

  Timer {
    id: grabTimer
    interval: 80
    onTriggered: focusGrab.active = true
  }

  FontMetrics {
    id: musicMetrics
    font.family: "Cascadia Code NF"
    font.pixelSize: 15
    font.weight: Font.DemiBold
  }

  Rectangle {
    id: shell
    anchors.fill: parent
    radius: Colors.barRadius
    color: Colors.background
  }

  Item {
    id: compact
    width: parent.width
    height: root.barHeight

    Text {
      id: artistMeasure
      visible: false
      text: root.artist || "Spotify"
      font.family: "Cascadia Code NF"
      font.pixelSize: 15
      font.weight: Font.DemiBold
    }

    Text {
      id: titleMeasure
      visible: false
      text: root.title || "Now playing"
      font.family: "Cascadia Code NF"
      font.pixelSize: 15
      font.weight: Font.DemiBold
    }

    Row {
      id: compactMusic
      visible: root.available
      anchors.centerIn: parent
      height: 24
      spacing: 5

      Text {
        text: root.artist || "Spotify"
        width: Math.min(artistMeasure.implicitWidth, root.compactMusicTextWidth)
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
        text: root.playerState === "Playing" ? "" : ""
        height: 24
        color: Colors.accent
        font.family: "Iosevka Nerd Font"
        font.pixelSize: 17
        verticalAlignment: Text.AlignVCenter
      }

      Text {
        text: root.title || "Now playing"
        width: Math.min(titleMeasure.implicitWidth, root.compactMusicTextWidth)
        height: 24
        color: Colors.foreground
        font.family: "Cascadia Code NF"
        font.pixelSize: 15
        font.weight: Font.DemiBold
        elide: Text.ElideRight
        maximumLineCount: 1
        verticalAlignment: Text.AlignVCenter
      }
    }

    Text {
      id: notifTitleMeasure
      visible: false
      text: root.compactNotifTitle || root.lastNotifTitle
      font.family: "Cascadia Code NF"
      font.pixelSize: 15
      font.weight: Font.DemiBold
    }

    Row {
      id: compactNotif
      visible: !root.available && (root.notifCount > 0 || root.dismissing)
      anchors.centerIn: parent
      height: 24
      spacing: 8

      Text {
        text: "󰂚"
        height: 24
        color: Colors.accent
        font.family: "Iosevka Nerd Font"
        font.pixelSize: 17
        verticalAlignment: Text.AlignVCenter
      }

      Text {
        text: root.compactNotifTitle || root.lastNotifTitle
        width: Math.min(notifTitleMeasure.implicitWidth, root.compactMusicTextWidth)
        height: 24
        color: Colors.foreground
        font.family: "Cascadia Code NF"
        font.pixelSize: 15
        font.weight: Font.DemiBold
        elide: Text.ElideRight
        maximumLineCount: 1
        verticalAlignment: Text.AlignVCenter
      }
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.open = !root.open
    }
  }

  Item {
    id: expanded
    anchors.top: compact.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: Math.max(0, root.height - root.barHeight)
    clip: true
    opacity: root.open ? 1 : 0

    Behavior on opacity {
      NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
    }

    Flickable {
      anchors.fill: parent
      anchors.margins: 14
      contentWidth: width
      contentHeight: expandedBody.implicitHeight
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      interactive: expandedBody.implicitHeight > height

      Column {
        id: expandedBody
        width: parent.width
        spacing: 12

        Column {
          visible: root.available
          width: parent.width
          spacing: 8

          Text {
            text: "Now playing"
            color: Colors.foreground
            font.family: "Cascadia Code NF"
            font.pixelSize: 13
            font.weight: Font.DemiBold
          }

          Rectangle {
            width: parent.width
            height: 72
            radius: 13
            color: Colors.surfaceRaised

            Column {
              anchors.left: parent.left
              anchors.leftMargin: 12
              anchors.verticalCenter: parent.verticalCenter
              width: parent.width - 132
              spacing: 2

              Text {
                text: root.title || "Unknown title"
                width: parent.width
                color: Colors.foreground
                font.family: "Cascadia Code NF"
                font.pixelSize: 14
                font.weight: Font.DemiBold
                elide: Text.ElideRight
              }

              Text {
                text: root.artist || "Unknown artist"
                width: parent.width
                color: Colors.muted
                font.family: "Cascadia Code NF"
                font.pixelSize: 12
                elide: Text.ElideRight
              }
            }

            Row {
              anchors.right: parent.right
              anchors.rightMargin: 10
              anchors.verticalCenter: parent.verticalCenter
              spacing: 6

              Rectangle {
                width: 34
                height: 30
                radius: 13
                color: Colors.surfaceInteractive

                Text {
                  anchors.centerIn: parent
                  text: "󰒮"
                  color: Colors.foreground
                  font.family: "Iosevka Nerd Font"
                  font.pixelSize: 16
                }

                MouseArea {
                  anchors.fill: parent
                  onClicked: previous.running = true
                }
              }

              Rectangle {
                width: 34
                height: 30
                radius: 13
                color: Colors.accent

                Text {
                  anchors.centerIn: parent
                  text: root.playerState === "Playing" ? "" : ""
                  color: Colors.foreground
                  font.family: "Iosevka Nerd Font"
                  font.pixelSize: 16
                }

                MouseArea {
                  anchors.fill: parent
                  onClicked: playPause.running = true
                }
              }

              Rectangle {
                width: 34
                height: 30
                radius: 13
                color: Colors.surfaceInteractive

                Text {
                  anchors.centerIn: parent
                  text: "󰒭"
                  color: Colors.foreground
                  font.family: "Iosevka Nerd Font"
                  font.pixelSize: 16
                }

                MouseArea {
                  anchors.fill: parent
                  onClicked: next.running = true
                }
              }
            }
          }

          CavaWaveform {
            width: parent.width
          }
        }

        Text {
          visible: root.notifCount > 0
          text: "Notifications"
          color: Colors.foreground
          font.family: "Cascadia Code NF"
          font.pixelSize: 13
          font.weight: Font.DemiBold
        }

        Column {
          visible: root.notifCount > 0
          width: parent.width
          spacing: 6

            Repeater {
            model: NotificationCenter.items

            delegate: Rectangle {
              required property var modelData
              property var notification: modelData
              width: parent ? parent.width : 0
              implicitHeight: notifCol.implicitHeight + 20
              radius: 13
              color: Colors.surfaceRaised

              MouseArea {
                anchors.fill: parent
                onClicked: notification.dismiss()
              }

              Row {
                z: 1
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 10
                spacing: 10

                Image {
                  visible: notification.image && notification.image.length > 0
                  source: visible ? notification.image : ""
                  width: 36
                  height: 36
                  fillMode: Image.PreserveAspectCrop
                }

                Column {
                  id: notifCol
                  width: parent.width - (notification.image && notification.image.length > 0 ? 46 : 0)
                  spacing: 4

                  Text {
                    text: notification.appName || "Notification"
                    width: parent.width
                    color: Colors.muted
                    font.family: "Cascadia Code NF"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                  }

                  Text {
                    text: notification.summary || ""
                    width: parent.width
                    color: Colors.foreground
                    font.family: "Cascadia Code NF"
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    wrapMode: Text.Wrap
                  }

                  Text {
                    visible: notification.body && notification.body.length > 0
                    text: notification.body || ""
                    width: parent.width
                    color: Colors.muted
                    font.family: "Cascadia Code NF"
                    font.pixelSize: 12
                    wrapMode: Text.Wrap
                    maximumLineCount: 4
                    elide: Text.ElideRight
                  }

                  Flow {
                    visible: notification.actions && notification.actions.length > 0
                    width: parent.width
                    spacing: 6

                    Repeater {
                      model: notification.actions

                      delegate: Rectangle {
                        required property var modelData
                        property var action: modelData
                        height: 26
                        implicitWidth: actionLabel.implicitWidth + 16
                        radius: 12
                        color: Colors.surfaceInteractive

                        Text {
                          id: actionLabel
                          anchors.centerIn: parent
                          text: action.text || "Open"
                          color: Colors.foreground
                          font.family: "Cascadia Code NF"
                          font.pixelSize: 11
                        }

                        MouseArea {
                          anchors.fill: parent
                          onClicked: action.invoke()
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
    }
  }

  Process {
    id: artistProcess
    command: ["playerctl", "-p", "spotify", "metadata", "artist"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.artist = text.trim()
    }
  }

  Process {
    id: titleProcess
    command: ["playerctl", "-p", "spotify", "metadata", "title"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.title = text.trim()
    }
  }

  Process {
    id: stateProcess
    command: ["sh", "-c", "playerctl -p spotify status 2>/dev/null"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.playerState = text.trim()
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      artistProcess.running = true
      titleProcess.running = true
      stateProcess.running = true
    }
  }

  Process {
    id: playPause
    command: ["playerctl", "-p", "spotify", "play-pause"]
    running: false
  }

  Process {
    id: next
    command: ["playerctl", "-p", "spotify", "next"]
    running: false
  }

  Process {
    id: previous
    command: ["playerctl", "-p", "spotify", "previous"]
    running: false
  }
}
