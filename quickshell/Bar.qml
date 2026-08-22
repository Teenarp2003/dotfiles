import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      required property var modelData
      screen: modelData
      color: "transparent"
      WlrLayershell.namespace: "quickshell"

      property int barHeight: 40
      property int pillRadius: 17
      property var occupiedWorkspaceIds: []
      property var workspaceIcons: ["", "", "", "", "", "", "", "", "", ""]
      property int workspaceCount: modelData.name === "eDP-1" ? 10 : 5
      property int workspaceCellWidth: 37

        function dispatchWorkspace(workspace) {
          if (Hyprland.usingLua)
            Hyprland.dispatch('hl.dsp.focus({ workspace = "' + workspace + '" })')
          else
            Hyprland.dispatch("workspace " + workspace)
        }

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: barHeight + 12 + 560
      exclusiveZone: barHeight + 12
      focusable: wifiPill.open || bluetoothWidget.open || pillWidget.open
      mask: Region {
        x: 0
        y: 0
        width: bar.width
        height: bar.barHeight + 12
        Region {
          item: pillWidget
        }
        Region {
          item: bluetoothWidget
        }
        Region {
          item: bluetoothWidget.panel
        }
        Region {
          item: wifiPill
        }
        Region {
          item: wifiPill.panel
        }
      }
      HyprlandWindow.visibleMask: mask

      margins {
        top: 3
        left: 3
        right: 15
      }

      Process {
        id: occupiedWorkspaceProcess
        command: ["sh", "-c", "hyprctl workspaces -j"]
        running: true

        stdout: StdioCollector {
          onStreamFinished: {
            try {
              bar.occupiedWorkspaceIds = JSON.parse(text).map(workspace => workspace.id)
            } catch (error) {
              bar.occupiedWorkspaceIds = []
            }
          }
        }
      }

      Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: occupiedWorkspaceProcess.running = true
      }

      Rectangle {
        id: leftPill
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 7
        width: leftContent.implicitWidth + 20
        height: barHeight
        radius: pillRadius
        color: "transparent"

        Row {
          id: leftContent
          anchors.centerIn: parent
          spacing: 6

          Rectangle {
            width: clock.implicitWidth + 35
            height: barHeight
            radius: pillRadius
            color: Colors.background

            ClockWidget {
              id: clock
              anchors.centerIn: parent
            }
          }

          Row {
            spacing: 0

            Repeater {
              model: bar.workspaceCount

              delegate: Text {
                required property int index
                property bool occupied: Hyprland.workspaces.values.some(workspace => workspace.id === index + 1) || bar.occupiedWorkspaceIds.indexOf(index + 1) !== -1
                property bool active: Hyprland.focusedWorkspace?.id === index + 1
                property var workspaceColors: [Colors.workspace1, Colors.workspace2, Colors.workspace3, Colors.workspace4, Colors.workspace5, Colors.workspace6, Colors.workspace7, Colors.workspace8, Colors.workspace9, Colors.workspace10]
                text: bar.workspaceIcons[index]
                width: bar.workspaceCellWidth
                height: barHeight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: workspaceColors[index]
                opacity: active ? 1 : occupied ? 0.93 : 0.50
                scale: active ? 1.12 : occupied ? 1 : 0.86
                font.family: "Iosevka Nerd Font"
                font.pixelSize: active ? 25 : occupied ? 22 : 17

                Behavior on color {
                  ColorAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                  }
                }

                Behavior on opacity {
                  NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                  }
                }

                Behavior on scale {
                  NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutBack
                  }
                }

                Behavior on font.pixelSize {
                  NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                  }
                }

                MouseArea {
                  anchors.fill: parent
                  onClicked: bar.dispatchWorkspace(String(index + 1))
                  onWheel: wheel => {
                    if (wheel.angleDelta.y > 0)
                      bar.dispatchWorkspace("+1")
                    else if (wheel.angleDelta.y < 0)
                      bar.dispatchWorkspace("-1")
                  }
                }
              }
            }
          }
        }
      }

      PillWidget {
        id: pillWidget
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 7
        barHeight: bar.barHeight
        ownerWindow: bar
        onOpenChanged: {
          if (open) {
            wifiPill.open = false
            bluetoothWidget.open = false
          }
        }
      }

      Rectangle {
        id: rightPill
        anchors.right: bluetoothWidget.left
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 7
        width: rightContent.implicitWidth + 24
        height: barHeight
        radius: pillRadius
        color: Colors.background

        Row {
          id: rightContent
          anchors.centerIn: parent
          height: 24
          spacing: 14

          StatusItem {
            command: ["sh", "-c", "muted=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null); vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk 'NR==1 {gsub(/%/, \"\", $5); print $5}'); if echo \"$muted\" | grep -q yes; then printf 'mute|%s%%\\n' \"${vol:---}\"; else printf 'on|%s%%\\n' \"${vol:---}\"; fi"]
            interval: 25
            fallback: "--%"
            splitIcon: true
            icon: "󰓃"
            mutedIcon: "󰓄"
            iconColor: Colors.volume
            clickCommand: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"]
            rightClickCommand: ["pavucontrol"]
            wheelUpCommand: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+1%"]
            wheelDownCommand: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-1%"]
          }
          StatusItem {
            command: ["sh", "-c", "brightnessctl -m 2>/dev/null | awk -F, '{print \$4}'"]
            interval: 25
            fallback: "--%"
            icon: "󰃠"
            iconColor: Colors.brightness
            wheelUpCommand: ["brightnessctl", "set", "5%+"]
            wheelDownCommand: ["brightnessctl", "set", "5%-"]
          }
          StatusItem {
            command: ["sh", "-c", "awk '{printf \"%d°C\", $1/1000}' /sys/class/hwmon/hwmon5/temp1_input 2>/dev/null"]
            interval: 2000
            fallback: "--°C"
            icon: ""
            iconColor: Colors.temperature
          }
          StatusItem {
            command: ["sh", "-c", "df -P /home | awk 'NR==2 {gsub(/%/, \"\", $5); print $5 \"%\"}'"]
            interval: 30000
            fallback: "--%"
            icon: "󰋊"
            iconColor: Colors.disk
          }
          StatusItem {
            command: ["sh", "-c", "top -bn1 | awk '/Cpu/ {printf \"%.0f%%\", 100-$8; exit}'"]
            interval: 500
            fallback: "--%"
            icon: ""
            iconColor: Colors.cpu
            clickCommand: ["alacritty", "-e", "btop"]
          }
          StatusItem {
            command: ["sh", "-c", "free -m | awk 'NR==2 {print $3 \" MB\"}'"]
            interval: 500
            fallback: "-- MB"
            icon: ""
            iconColor: Colors.memory
            clickCommand: ["alacritty", "-e", "htop"]
          }
          StatusItem {
            command: ["sh", "-c", "upower -i \$(upower -e | grep battery | head -n 1) 2>/dev/null | awk '/percentage/ {if ($2 != \"100%\") print $2; exit}'"]
            interval: 2000
            fallback: "--%"
            useFallbackOnEmpty: false
            icon: ""
            iconColor: Colors.battery
          }
        }
      }

      BluetoothWidget {
        id: bluetoothWidget
        anchors.right: wifiPill.left
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 7
        z: 2
        ownerWindow: bar
        onOpenChanged: {
          if (open) {
            wifiPill.open = false
            pillWidget.open = false
          }
        }
      }

      WifiWidget {
        id: wifiPill
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 7
        z: 2
        ownerWindow: bar
        onOpenChanged: {
          if (open) {
            bluetoothWidget.open = false
            pillWidget.open = false
          }
        }
      }
    }
  }
}

