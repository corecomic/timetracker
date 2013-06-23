import QtQuick 1.1
import com.nokia.meego 1.0

import "UIConstants.js" as UIConstants

/**
 * Can be used with section.delegate in ListView to display Harmattan style section headers.
 *
 * Requires the text to be available as property 'section'
 */
Item {
    width: parent.width
    height: 40 // TODO UIConstants

    property alias text: headerLabel.text

    Text {
        id: headerLabel
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: UIConstants.DEFAULT_MARGIN
        anchors.bottomMargin: 2 // IMPROVE UIConstants
        font.bold: true
        font.pixelSize: UIConstants.FONT_XSMALL

        color: theme.inverted ? UIConstants.COLOR_INVERTED_SECONDARY_FOREGROUND : UIConstants.COLOR_SECONDARY_FOREGROUND
    }
    Image {
        anchors.right: headerLabel.left
        anchors.left: parent.left
        anchors.verticalCenter: headerLabel.verticalCenter
        anchors.rightMargin: 24 // IMPROVE UIConstants
        source: "image://theme/meegotouch-groupheader" + (theme.inverted ? "-inverted" : "") + "-background"
    }
}
