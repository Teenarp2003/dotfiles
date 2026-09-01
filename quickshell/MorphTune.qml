pragma Singleton

import Quickshell
import QtQuick

Singleton {
  property bool visible: false
  property int neckHeight: 10
  property real blendK: 52.5

  function toggle() {
    visible = !visible
  }
}
