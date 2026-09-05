pragma Singleton

import Quickshell
import QtQuick

Singleton {
  readonly property string fontFamily: "Material Icons"
  readonly property string telaRoot: "/usr/share/icons/Tela-circle"

  function iconBaseName(icon) {
    if (!icon)
      return ""
    let name = String(icon)
    if (name.startsWith("file://"))
      name = decodeURIComponent(name.slice(7))
    const slash = Math.max(name.lastIndexOf("/"), name.lastIndexOf("\\"))
    if (slash !== -1)
      name = name.slice(slash + 1)
    return name.replace(/\.(svg|png|xpm|jpg|jpeg)$/i, "")
  }

  function telaFileUrl(icon) {
    const name = iconBaseName(icon)
    if (!name)
      return ""
    return "file://" + telaRoot + "/scalable/apps/" + encodeURIComponent(name) + ".svg"
  }

  function battery(percent) {
    if (percent >= 90)
      return "battery_full"
    if (percent >= 65)
      return "battery_5_bar"
    if (percent >= 40)
      return "battery_4_bar"
    if (percent >= 15)
      return "battery_2_bar"
    return "battery_0_bar"
  }

  function batteryLevel(level) {
    return battery(Math.round(Number(level) * 100))
  }

  function wifi(percent) {
    if (percent >= 80)
      return "wifi"
    if (percent >= 60)
      return "wifi_2_bar"
    if (percent >= 35)
      return "wifi_1_bar"
    return "wifi_1_bar"
  }
}
