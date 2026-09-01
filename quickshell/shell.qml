import Quickshell
import Quickshell.Hyprland
import QtQuick

Scope {
  Connections {
    target: Quickshell
    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup()
    }
  }

  GlobalShortcut {
    name: "toggleMorphTune"
    description: "Toggle morph neck/blend editor"
    onPressed: MorphTune.toggle()
  }

  Bar {}
  MorphTunePanel {}
}
