import QtQuick 1.1
import com.nokia.meego 1.0 // MeeGo 1.2 Harmattan components

import "UIConstants.js" as UIConstants


Sheet {
    id: projectPage

    property int projectID: -1
    property string projectName: ""
    property string projectDescription: ""

    /**
     * Adds or updates the rent data into the database.
     */
    function addProjectToDatabase()
    {
        if (projectID !== -1) {
            db.updateProject(projectID, nameField.text, descriptionField.text);
        }
        else {
            db.insertProject(nameField.text, descriptionField.text);
        }
    }


    // Page content
    acceptButtonText: "Save"
    rejectButtonText: "Cancel"

    onAccepted: {
        projectPage.addProjectToDatabase();
        mainPage.fillListModel();
    }
    onRejected: {
    }

    // Formular
    content: Flickable {
        id: flickable
        anchors.fill: parent
        clip: true
        contentWidth: parent.width
        contentHeight: grid.height

        Grid {
            id: grid

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: UIConstants.DEFAULT_MARGIN
            }

            columns: projectPage.width > projectPage.height ? 2 : 1
            spacing: 10

            // Project name information
            Text {
                id: nameText
                width: parent.width * 0.25
                height: nameField.height
                color: UIConstants.COLOR_FOREGROUND
                verticalAlignment: Text.AlignVCenter

                font {
                    family: UIConstants.FONT_FAMILY
                    pixelSize: UIConstants.FONT_DEFAULT
                }

                text: "Project name:"
            }
            TextField {
                id: nameField
                width: (grid.columns == 1) ?
                           parent.width : parent.width - nameText.width - grid.spacing;
                placeholderText: "Enter name"
                text: projectName
                focus: true
            }

            // Project description information
            Text {
                id: descriptionText
                width: nameText.width
                height: nameText.height
                color: UIConstants.COLOR_FOREGROUND
                verticalAlignment: Text.AlignVCenter

                font {
                    family: UIConstants.FONT_FAMILY
                    pixelSize: UIConstants.FONT_DEFAULT
                }

                text: "Project description:"
            }
            TextArea {
                id: descriptionField
                width: nameField.width
                height: 3*nameField.height
                placeholderText: "Enter project description..."
                text: projectDescription
            }
        } // Grid
    } // Flickable
}
