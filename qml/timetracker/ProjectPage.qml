import QtQuick 1.1
import com.nokia.meego 1.0 // MeeGo 1.2 Harmattan components

import "UIConstants.js" as UIConstants

Page {
    id: projectPage

    property int projectID: -1
    property string projectName
    property string projectDescription

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

        appWindow.pageStack.pop();
    }


    // Page content
    ScrollDecorator {
        flickableItem: flickable
    }

    // Page Header
    PageHeader {
        id: appTitleRect
        text: ""

        ToolBarLayout {
            Item { width: UIConstants.SMALL_MARGIN } // Make margins
            ToolButton {
                id: cancelButtonEdit
                flat: false
                text: "Cancel"
                onClicked: appWindow.pageStack.pop();
            }
            Item { width: UIConstants.SMALL_MARGIN } // Space between
            ToolButton {
                id: saveButtonEdit
                flat: false
                text: "Save"
                onClicked: projectPage.addProjectToDatabase();
            }
            Item { width: UIConstants.SMALL_MARGIN } // Make margins
        }

    }


    // Formular
    Flickable {
        id: flickable

        anchors {
            top: appTitleRect.bottom
            left: parent.left
            right: parent.right
            margins: 10
        }

        flickableDirection: Flickable.VerticalFlick
        //contentHeight: (grid.columns == 1) ? nameText.height * 6 + 70 : nameText.height * 4 + 50;


        Grid {
            id: grid
            width: parent.width - anchors.margins * 2

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 5
            }

            columns: projectPage.width > projectPage.height ? 2 : 1
            spacing: 10

            // Project name information
            Text {
                id: nameText
                width: parent.width * 0.15
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
