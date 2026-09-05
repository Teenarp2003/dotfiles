//@ pragma IconTheme Tela-circle
//@ pragma Env QS_ICON_THEME = Tela-circle
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
