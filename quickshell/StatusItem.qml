import Quickshell.Io
import QtQuick

Item {
  id: root

  property var command: []
  property int interval: 1000
  property string fallback: "--"
  property string value: fallback
  property string icon: ""
  property string mutedIcon: ""
  property bool muted: false
  property bool splitIcon: false
  property color iconColor: Colors.foreground
  property bool useFallbackOnEmpty: true
  property var clickCommand: []
  property var rightClickCommand: []
  property var middleClickCommand: []
  property var wheelUpCommand: []
  property var wheelDownCommand: []

  implicitWidth: content.implicitWidth
  implicitHeight: 24
  height: 24

  Row {
    id: content
    anchors.verticalCenter: parent.verticalCenter
    height: 24
    spacing: root.icon.length > 0 ? 3 : 0

    Text {
      text: root.muted && root.mutedIcon.length > 0 ? root.mutedIcon : root.icon
      height: 24
      color: root.iconColor
      font.family: "Iosevka Nerd Font"
      font.pixelSize: 18
      verticalAlignment: Text.AlignVCenter
    }

    Text {
      id: label
      visible: !root.muted
      text: visible ? root.value : ""
      height: 24
      color: Colors.foreground
      font.family: "Cascadia Code NF"
      font.pixelSize: 16
      font.weight: Font.DemiBold
      verticalAlignment: Text.AlignVCenter
    }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    onClicked: mouse => {
      if (mouse.button === Qt.LeftButton && root.clickCommand.length > 0)
        clickProcess.running = true
      else if (mouse.button === Qt.RightButton && root.rightClickCommand.length > 0)
        rightClickProcess.running = true
      else if (mouse.button === Qt.MiddleButton && root.middleClickCommand.length > 0)
        middleClickProcess.running = true
    }

  }

  WheelHandler {
    target: null
    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    grabPermissions: PointerHandler.CanTakeOverFromAnything

    onWheel: wheel => {
      wheel.accepted = true
      const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.pixelDelta.y

      if (delta > 0 && root.wheelUpCommand.length > 0) {
        if (wheelUpProcess.running)
          wheelUpProcess.running = false
        wheelUpProcess.running = true
      } else if (delta < 0 && root.wheelDownCommand.length > 0) {
        if (wheelDownProcess.running)
          wheelDownProcess.running = false
        wheelDownProcess.running = true
      }
    }
  }

  Process {
    id: clickProcess
    command: root.clickCommand
    running: false
  }

  Process {
    id: rightClickProcess
    command: root.rightClickCommand
    running: false
  }

  Process {
    id: middleClickProcess
    command: root.middleClickCommand
    running: false
  }

  Process {
    id: wheelUpProcess
    command: root.wheelUpCommand
    running: false
  }

  Process {
    id: wheelDownProcess
    command: root.wheelDownCommand
    running: false
  }

  Process {
    id: process
    command: root.command
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const line = text.trim()
        if (root.splitIcon) {
          const sep = line.indexOf("|")
          if (sep !== -1) {
            root.muted = line.slice(0, sep) === "mute"
            root.value = line.slice(sep + 1) || (root.useFallbackOnEmpty ? root.fallback : "")
            return
          }
        }

        root.value = line || (root.useFallbackOnEmpty ? root.fallback : "")
      }
    }
  }

  Timer {
    interval: root.interval
    running: true
    repeat: true
    onTriggered: process.running = true
  }
}