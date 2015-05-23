import QtQuick 1.1
import com.nokia.meego 1.0

import "UIConstants.js" as UIConstants

Item {
    id: timeHeader

    property alias text: timeHeaderText.text
    property alias showArrows: leftArrow.visible

    height: UIConstants.FIELD_DEFAULT_HEIGHT

    Item {
        id: leftArrow
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: 100
        visible: false

        Image {
            id: leftArrowImage
            anchors {
                left: parent.left
                leftMargin: (timeHeader.width / 7) / 2 - (width / 2)
                verticalCenter: parent.verticalCenter
            }
            width: height
            source: "image://theme/meegotouch-datepicker-monthgrid-previousbutton"
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                leftArrowImage.source = "image://theme/meegotouch-datepicker-monthgrid-previousbutton-pressed"
            }
            onReleased: {
                leftArrowImage.source = "image://theme/meegotouch-datepicker-monthgrid-previousbutton"
                //previousMonthAnimation.start()
                //dateModel.showPrevious()
            }
        }
    }

    Text {
        id: timeHeaderText
        anchors.centerIn: parent
        color: UIConstants.COLOR_FOREGROUND

        font {
            family: UIConstants.FONT_FAMILY
            pixelSize: UIConstants.FONT_DEFAULT
        }

        text: ""
    }

    Item {
        id: rightArrow
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: 100
        visible: leftArrow.visible

        Image {
            id: rightArrowImage
            anchors {
                right: parent.right
                rightMargin: (timeHeader.width / 7) / 2 - (width / 2)
                verticalCenter: parent.verticalCenter
            }
            width: height
            source: "image://theme/meegotouch-datepicker-monthgrid-nextbutton"
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                rightArrowImage.source = "image://theme/meegotouch-datepicker-monthgrid-nextbutton-pressed"
            }
            onReleased: {
                rightArrowImage.source = "image://theme/meegotouch-datepicker-monthgrid-nextbutton"
                //nextMonthAnimation.start()
                //dateModel.showNext()
            }
        }
    }
}
