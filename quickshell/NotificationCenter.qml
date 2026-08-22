pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
  id: root

  property var items: []
  readonly property int count: root.items.length

  function forget(notification) {
    root.items = root.items.filter(item => item !== notification)
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
      root.items = root.items.concat([notification])
    }
  }
}
