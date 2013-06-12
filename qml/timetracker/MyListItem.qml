import QtQuick 1.1
import com.nokia.meego 1.0

import "UIConstants.js" as UIConstants

// Start Time
Item {
    id: item

    property alias title: titleLabel
    property alias subtitle: subtitleLable
    property alias iconVisible: icon.visible
    property alias icon: icon.source

    signal clicked
    signal pressAndHold

    height: UIConstants.LIST_ITEM_HEIGHT_DEFAULT
    width: parent.width

    Rectangle {
        radius: 8
        anchors.fill: parent
        opacity: 0.7
        color: "lightsteelblue"
        visible: itemMouseArea.pressed
    }

    MouseArea {
        id: itemMouseArea
        anchors.fill: parent
        onClicked: {
            item.clicked();
        }
        onPressAndHold: {
            item.pressAndHold();
        }
    }

    Label {
        id: titleLabel

        anchors {
            left: parent.left
            leftMargin: 10
            rightMargin: 10
            topMargin: 7
            top: parent.top
        }

        color: UIConstants.COLOR_FOREGROUND
        font {
            family: UIConstants.FONT_FAMILY
            pixelSize: UIConstants.FONT_DEFAULT
            bold: true
        }

        text: "-"
    }

    Label {
        id: subtitleLable

        anchors {
            top:  titleLabel.bottom
            topMargin: 5
            left: parent.left
            leftMargin: 10
            rightMargin: 10
            right: icon.left
        }

        color: UIConstants.COLOR_SECONDARY_FOREGROUND
        font {
            family: UIConstants.FONT_FAMILY
            pixelSize: UIConstants.FONT_SMALL
        }

        text: ""

    }

    Image {
        id: icon

        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        height: sourceSize.height
        width: sourceSize.width
        source: "image://theme/meegotouch-combobox-indicator" + platformStyle.__invertedString
    }
}
