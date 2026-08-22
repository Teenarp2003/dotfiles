pragma Singleton

import Quickshell
import QtQuick

Singleton {{
  property real windowOpacity: .80
  readonly property color backgroundBase: "{background}"
  readonly property color background: withOpacity(backgroundBase)
  readonly property color surface: withOpacity(backgroundBase)
  readonly property color surfaceRaised: withOpacity(Qt.lighter(backgroundBase, 1.35))
  readonly property color surfaceContainer: withOpacity(Qt.lighter(backgroundBase, 1.7))
  readonly property color surfaceInteractive: withOpacity(Qt.lighter(backgroundBase, 2.1))
  readonly property color surfaceConnected: withOpacity(Qt.lighter(backgroundBase, 2.6))
  readonly property color surfaceWarning: withOpacity(Qt.lighter(backgroundBase, 2.1))
  readonly property color surfaceDanger: withOpacity(Qt.lighter(backgroundBase, 2.1))

  readonly property color foreground: "{foreground}"
  readonly property color surfaceText: "{foreground}"
  readonly property color textSecondary: "{color15}"
  readonly property color muted: "{color8}"
  readonly property color outline: "{color7}"

  readonly property color accent: "{color3}"
  readonly property color primary: "{color4}"
  readonly property color primaryStrong: "{color12}"
  readonly property color volume: "{color9}"
  readonly property color brightness: "#FFC107"
  readonly property color temperature: "#FF5722"
  readonly property color disk: "#00BCD4"
  readonly property color cpu: "#2196F3"
  readonly property color memory: "#9C27B0"
  readonly property color battery: "#4CAF50"
  readonly property color battery_bluetooth: "{color1}"
  readonly property color bluetooth: "{color12}"
  readonly property color network: "{color1}"

  readonly property color workspace1: "#00BCD4"
  readonly property color workspace2: "#FF9800"
  readonly property color workspace3: "#2196F3"
  readonly property color workspace4: "#F44336"
  readonly property color workspace5: "#4CAF50"
  readonly property color workspace6: "#9C27B0"
  readonly property color workspace7: "#FFC107"
  readonly property color workspace8: "#03A9F4"
  readonly property color workspace9: "#E91E63"
  readonly property color workspace10: "#607D8B"

  readonly property int barRadius: 17
  readonly property int panelRadius: 18
  readonly property int controlRadius: 14

  function withOpacity(base) {{
    return Qt.rgba(base.r, base.g, base.b, windowOpacity)
  }}
}}
