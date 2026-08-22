pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property string playerState: ""
  property var levels: []
  readonly property bool spotifyRunning: root.playerState === "Playing" || root.playerState === "Paused" || root.playerState === "Stopped"

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
    onTriggered: stateProcess.running = true
  }

  Process {
    id: cavaProcess
    running: root.spotifyRunning
    command: ["cava", "-p", Quickshell.shellDir + "/cava-pill.ini"]
    stdout: SplitParser {
      onRead: data => {
        const parts = data.trim().split(/[;]+/).filter(part => part.length > 0)
        if (parts.length === 0)
          return
        root.levels = parts.map(part => Number(part))
      }
    }
  }
}
