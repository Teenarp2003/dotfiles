import QtQuick

Item {
  id: root

  property bool open: false
  property bool peeking: false
  property int barHeight: 40
  property int collapsedWidth: 40
  property int panelWidth: 360
  property int panelHeight: 200
  property int peekPanelHeight: 88
  property int neckHeight: MorphTune.neckHeight
  property real blendK: MorphTune.blendK
  property bool gooey: true
  property bool sequentialMorph: false
  property int panelRadius: 18
  property int pillRadius: 17
  property string expandDirection: "right"
  property color fillColor: Colors.background
  property real stretchHeight: 0
  property real stretchWidth: 0
  property int heightTarget: 200

  default property alias compactData: compactSlot.data
  property alias panelContent: panelSlot.data
  property alias panel: silhouette

  readonly property int liveNeck: Math.round(root.stretchHeight * root.neckHeight)
  readonly property int livePanelH: Math.round(root.stretchHeight * root.heightTarget)
  readonly property int livePanelW: Math.round(root.collapsedWidth + root.stretchWidth * Math.max(0, Math.max(root.panelWidth, root.collapsedWidth) - root.collapsedWidth))
  readonly property int blobX: {
    if (root.expandDirection === "left")
      return root.collapsedWidth - root.livePanelW
    if (root.expandDirection === "center")
      return Math.round((root.collapsedWidth - root.livePanelW) / 2)
    return 0
  }
  readonly property int rTop: Math.max(1, Math.min(root.pillRadius, Math.floor(root.collapsedWidth / 2), Math.floor(root.barHeight / 2)))
  readonly property int rBot: Math.max(1, Math.min(root.panelRadius, Math.floor(root.livePanelW / 2), Math.floor(Math.max(1, root.livePanelH) / 2)))
  readonly property int shadePad: 36
  readonly property int padLeft: (!root.gooey || root.expandDirection === "right") ? 0 : root.shadePad
  readonly property int padRight: (!root.gooey || root.expandDirection === "left") ? 0 : root.shadePad
  readonly property bool showBlob: root.livePanelH > 0

  width: root.collapsedWidth
  implicitWidth: root.collapsedWidth
  height: root.barHeight + root.liveNeck + root.livePanelH
  implicitHeight: height
  clip: false

  onPanelHeightChanged: {
    if (root.open)
      root.heightTarget = root.panelHeight
  }
  onPeekPanelHeightChanged: {
    if (root.peeking && !root.open)
      root.heightTarget = root.peekPanelHeight
  }
  onOpenChanged: root.applyMorph()
  onPeekingChanged: root.applyMorph()
  Component.onCompleted: {
    if (root.open || root.peeking)
      root.applyMorph()
  }

  function applyMorph() {
    openAnim.stop()
    sequentialOpenAnim.stop()
    peekAnim.stop()
    closeAnim.stop()
    if (root.open) {
      root.heightTarget = root.panelHeight
      if (root.sequentialMorph)
        sequentialOpenAnim.start()
      else
        openAnim.start()
    } else if (root.peeking) {
      root.heightTarget = root.peekPanelHeight
      peekAnim.start()
    } else {
      closeAnim.start()
    }
  }

  SequentialAnimation {
    id: sequentialOpenAnim
    NumberAnimation {
      target: root
      property: "stretchHeight"
      to: 1
      duration: 220
      easing.type: Easing.OutCubic
    }
    NumberAnimation {
      target: root
      property: "stretchWidth"
      to: 1
      duration: 260
      easing.type: Easing.OutCubic
    }
  }

  ParallelAnimation {
    id: openAnim
    NumberAnimation {
      target: root
      property: "stretchHeight"
      to: 1
      duration: 200
      easing.type: Easing.OutCubic
    }
    NumberAnimation {
      target: root
      property: "stretchWidth"
      to: 1
      duration: 340
      easing.type: Easing.OutCubic
    }
  }

  ParallelAnimation {
    id: peekAnim
    NumberAnimation {
      target: root
      property: "stretchWidth"
      to: 0
      duration: 280
      easing.type: Easing.OutCubic
    }
    NumberAnimation {
      target: root
      property: "stretchHeight"
      to: 1
      duration: 180
      easing.type: Easing.OutCubic
    }
  }

  ParallelAnimation {
    id: closeAnim
    NumberAnimation {
      target: root
      property: "stretchWidth"
      to: 0
      duration: 280
      easing.type: Easing.InCubic
    }
    NumberAnimation {
      target: root
      property: "stretchHeight"
      to: 0
      duration: 170
      easing.type: Easing.InCubic
    }
  }

  Item {
    id: silhouette
    x: Math.min(0, root.blobX) - root.padLeft
    y: 0
    width: Math.max(1, root.livePanelW + Math.max(0, -root.blobX)) + root.padLeft + root.padRight
    height: Math.max(1, root.height) + (root.gooey ? root.shadePad : 0)
    z: 0
    visible: root.showBlob

    ShaderEffect {
      anchors.fill: parent
      visible: root.gooey
      property real srcWidth: width
      property real srcHeight: height
      property vector4d fillColor: Qt.vector4d(root.fillColor.r, root.fillColor.g, root.fillColor.b, root.fillColor.a)
      property real pillR: root.rTop
      property real panelR: root.rBot
      property real blendK: root.blendK
      property vector4d pillRect: Qt.vector4d(root.padLeft + Math.max(0, -root.blobX), 0, root.collapsedWidth, root.barHeight)
      property vector4d panelRect: Qt.vector4d(root.padLeft + root.blobX - Math.min(0, root.blobX), root.barHeight + root.liveNeck, root.livePanelW, Math.max(1, root.livePanelH))
      fragmentShader: Qt.resolvedUrl("MorphBlob.frag.qsb")
    }

    Rectangle {
      visible: !root.gooey
      x: root.blobX - silhouette.x
      y: root.barHeight + root.liveNeck
      width: root.livePanelW
      height: root.livePanelH
      radius: root.panelRadius
      color: root.fillColor
    }
  }

  Item {
    id: blob
    x: root.blobX
    y: root.barHeight + root.liveNeck
    width: root.livePanelW
    height: root.livePanelH
    clip: true
    visible: root.showBlob
    z: 1

    Item {
      id: panelSlot
      anchors.fill: parent
    }
  }

  Rectangle {
    id: pill
    x: 0
    y: 0
    width: root.collapsedWidth
    height: root.barHeight
    radius: root.pillRadius
    color: (root.gooey && root.showBlob) ? "transparent" : root.fillColor
    z: 3

    Item {
      id: compactSlot
      anchors.fill: parent
    }
  }
}
