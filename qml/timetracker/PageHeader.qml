import QtQuick 1.1
import com.nokia.meego 1.0

import "UIConstants.js" as UIConstants

Rectangle {
    id: root

    property alias text: appTitle.text
    property alias busy: busyIndicator.running

    height: UIConstants.HEADER_DEFAULT_HEIGHT_PORTRAIT
    color: "steelblue"
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right


    Label {
        id: appTitle
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: UIConstants.DEFAULT_MARGIN
            right: parent.right
            rightMargin: UIConstants.DEFAULT_MARGIN
        }
        font.pixelSize: UIConstants.FONT_XLARGE
        color: "white"
        width: implicitWidth
        elide: Text.ElideRight
    }

    Rectangle {
      height: 1
      width: parent.width
      anchors.bottom: parent.bottom
      color: "#10000000"
    }

    Rectangle {
      height: 1
      width: parent.width
      anchors.top: parent.bottom
      anchors.topMargin: 1
      color: "white"
    }

    BusyIndicator {
        id: busyIndicator
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 12
        opacity: running ? 1.0 : 0.0
        running: false
    }

}
