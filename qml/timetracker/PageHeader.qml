import QtQuick 1.1
import com.nokia.meego 1.0

import "UIConstants.js" as UIConstants

Rectangle {
    id: root

    property alias text: appTitle.text
    property alias busy: busyIndicator.running
    property alias icon: icon.visible

    signal clicked

    height: (screen.currentOrientation === Screen.Landscape) ?
                UIConstants.HEADER_DEFAULT_HEIGHT_LANDSCAPE :
                UIConstants.HEADER_DEFAULT_HEIGHT_PORTRAIT
    color: "steelblue"
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: icon.visible
        onClicked: {
            root.clicked();
        }
    }

    Label {
        id: appTitle
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: UIConstants.DEFAULT_MARGIN
            right: icon.visible ? icon.left : parent.right
            rightMargin: UIConstants.DEFAULT_MARGIN
        }
        font.pixelSize: UIConstants.FONT_XLARGE
        color: "white"
        width: implicitWidth
        elide: Text.ElideRight
    }

    Image {
        id: icon
        anchors {
            right: parent.right
            rightMargin: UIConstants.DEFAULT_MARGIN
            verticalCenter: parent.verticalCenter
        }
        height: sourceSize.height
        width: sourceSize.width
        source: "image://theme/meegotouch-combobox-indicator-inverted"
        visible: false
    }

    Rectangle {
      height: 1
      width: parent.width
      anchors.bottom: parent.bottom
      color: "white"
    }

    BusyIndicator {
        id: busyIndicator
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: UIConstants.DEFAULT_MARGIN
        opacity: running ? 1.0 : 0.0
        running: false
    }

}
