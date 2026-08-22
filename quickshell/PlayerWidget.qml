import Quickshell.Io
import QtQuick

Item {
  id: root

  property string artist: ""
  property string title: ""
  property string playerState: ""
  property bool available: root.playerState === "Playing" || root.playerState === "Paused" || root.playerState === "Stopped"

  visible: root.available
  implicitWidth: root.available ? content.implicitWidth : 0
  implicitHeight: root.available ? 24 : 0
  height: implicitHeight

  Row {
    id: content
    anchors.verticalCenter: parent.verticalCenter
    height: 24
    spacing: 6

    Text {
      text: root.artist || "Unknown artist"
      height: 24
      color: Colors.foreground
      font.family: "Cascadia Code NF"
      font.pixelSize: 16
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
      text: root.title || "No media"
      height: 24
      color: Colors.foreground
      font.family: "Cascadia Code NF"
      font.pixelSize: 16
      font.weight: Font.DemiBold
      elide: Text.ElideRight
      maximumLineCount: 1
      verticalAlignment: Text.AlignVCenter
    }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    onClicked: mouse => {
      if (mouse.button === Qt.LeftButton)
        playPause.running = true
      else if (mouse.button === Qt.RightButton)
        next.running = true
      else if (mouse.button === Qt.MiddleButton)
        previous.running = true
    }
  }

  Process {
    id: artistProcess
    command: ["sh", "-c", "playerctl -p spotify metadata artist 2>/dev/null | cut -c1-14"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.artist = text.trim()
    }
  }

  Process {
    id: titleProcess
    command: ["sh", "-c", "playerctl -p spotify metadata title 2>/dev/null | cut -c1-18"]
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