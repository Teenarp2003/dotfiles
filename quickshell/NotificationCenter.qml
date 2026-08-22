pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
  id: root

  property list<var> items
  property var closing: []
  property bool silent: false
  property bool clearingAll: false
  readonly property int count: root.items.length

  signal incoming()

  function itemIndex(notification) {
    for (let i = 0; i < root.items.length; i++) {
      if (root.items[i] === notification)
        return i
    }
    return -1
  }

  function forget(notification) {
    const index = root.itemIndex(notification)
    if (index !== -1)
      root.items.splice(index, 1)
    root.closing = root.closing.filter(item => item !== notification)
    if (root.closing.length === 0)
      root.clearingAll = false
  }

  function isClosing(notification) {
    return root.closing.indexOf(notification) !== -1
  }

  function beginClose(notification) {
    if (!notification || root.isClosing(notification))
      return
    root.closing = root.closing.concat([notification])
  }

  function finishClose(notification) {
    if (!notification)
      return
    root.closing = root.closing.filter(item => item !== notification)

    if (root.clearingAll) {
      if (root.closing.length > 0)
        return
      const pending = []
      for (let i = 0; i < root.items.length; i++)
        pending.push(root.items[i])
      root.items = []
      root.clearingAll = false
      for (let i = 0; i < pending.length; i++) {
        const item = pending[i]
        if (item && item.tracked)
          item.dismiss()
      }
      return
    }

    if (notification.tracked)
      notification.dismiss()
  }

  function clearAll() {
    if (root.items.length === 0 || root.clearingAll)
      return
    const pending = []
    for (let i = 0; i < root.items.length; i++)
      pending.push(root.items[i])
    root.clearingAll = true
    root.closing = pending
  }

  NotificationServer {
    id: server
    keepOnReload: true
    persistenceSupported: true
    bodySupported: true
    bodyMarkupSupported: true
    actionsSupported: true
    imageSupported: true

    onNotification: notification => {
      notification.tracked = true
      notification.closed.connect(() => root.forget(notification))
      root.items.splice(0, 0, notification)
      if (!notification.lastGeneration)
        root.incoming()
    }
  }
}
