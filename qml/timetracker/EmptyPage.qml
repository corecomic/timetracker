import QtQuick 1.1
import com.nokia.meego 1.0

import "UIConstants.js" as UIConstants

Item {
    function addProject() {
        projectSheet.open();
    }

    ProjectPage {
        id: projectSheet
    }

    // Empty mouse area to prevent click-through!
    MouseArea {
        anchors.fill: parent
    }

    Image {
        anchors.fill: parent
        source: (screen.currentOrientation === Screen.Landscape) ?
                    "image://theme/meegotouch-empty-application-background-black-landscape" :
                    "image://theme/meegotouch-empty-application-background-black-portrait"
    }

    Label {
        id: infoLabel

        anchors {
            left: parent.left
            leftMargin: UIConstants.DEFAULT_MARGIN
            right: parent.right
            rightMargin: UIConstants.DEFAULT_MARGIN
            top: parent.top
            topMargin: (screen.currentOrientation === Screen.Landscape) ? 100 : 200
        }

        text: "Manage your timesheets with\n Time Tracker"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: UIConstants.FONT_XXLARGE
        wrapMode: Text.Wrap
        color: UIConstants.COLOR_INVERTED_SECONDARY_FOREGROUND
    }

    Button {
        id: createButton

        Component.onCompleted: {
            // Change the color of this button
            platformStyle.inverted = true;
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 100
        }

        text: "Add project"
        onClicked: addProject()
    }
}
