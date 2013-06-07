import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    id: root

    property alias text: appTitle.text
    property alias busy: busyIndicator.running

    height: 72
    color: "steelblue"
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right


    Label {
        id: appTitle
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 16
        font.pixelSize: 32
        color: "white"
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
