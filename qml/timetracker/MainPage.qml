import QtQuick 1.1
import com.nokia.meego 1.0

import "UIConstants.js" as UIConstants


Page {
    id: mainPage
    tools: commonTools

    property QueryDialog deleteDialog
    property int pIndex: -1

    /**
     * Fill list model with database values
     */
    function fillListModel()
    {
        listView.model = emptyListModel;
        listModel.clear();

        // Get projects
        var projectIdList = db.countProject();

        for (var i = 0; i < projectIdList.length; i++){
            var projectData = db.project(projectIdList[i]);
            listModel.append({ "titleText": projectData.name,
                               "name": projectData.name,
                               "description": projectData.description,
                               "projectID": projectData.index,
                               "active": projectData.active});
        }



        if (listModel.count < 1) {
            addResourcesBtn.opacity = 1;
            listView.opacity = 0;
        }
        else {
            addResourcesBtn.opacity = 0;
            listView.opacity = 1;
        }

        listView.model = listModel;
    }


    /**
     * Displays the delete query dialog.
     */
    function showDeleteDialog(index, name)
    {
        if (!deleteDialog) {
            deleteDialog = deleteDialogComponent.createObject(mainPage);
        }

        deleteDialog.message = "Do you realy want to delete the project: " + name + "?";
        deleteDialog.open();

        pIndex = index;
    }

    /**
     * Deletes the project from the database.
     */
    function deleteProjectFromDatabase()
    {
        if (pIndex !== -1){
            db.deleteProject(pIndex);
        }
        appWindow.pageStack.pop();
        fillListModel();
    }

    // Delete dialog
    Component {
        id: deleteDialogComponent

        QueryDialog {
            titleText: "Delete?"
            message: ""
            acceptButtonText: "Delete"
            rejectButtonText: "Cancel"
            onAccepted: deleteProjectFromDatabase();
        }
    }




    // Update page data on page PageStatus.Activating state
    onStatusChanged: {
        if (status === PageStatus.Activating) {
            fillListModel();
        }
        //console.debug("MainPage.qml: onStatusChanged:", status);
    }

    // Page Header
    PageHeader {
        id: appTitleRect
        text: "Time Tracker"
    }

    ScrollDecorator {
        flickableItem: listView
    }

    // Page Content - List
    ListView {
        id: listView
        anchors {
            top: appTitleRect.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: UIConstants.HALF_DEFAULT_MARGIN
        }

        clip: true
        delegate: listDelegate
        model: listModel
        focus: true
        spacing: 2
    }

    ListModel {
        id: listModel
    }

    ListModel {
        id: emptyListModel
    }

    Component {
        id: listDelegate

        Item {
            id: listItem

            property int projectID: model.projectID
            property string projectName: model.name
            property string projectDescription: model.description
            property int projectActive: model.active

            height: UIConstants.LIST_ITEM_HEIGHT_LARGE
            width: listView.width

            // Transparent overlay on clicked
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
                    listView.currentIndex = index;
                    pageStack.push(Qt.resolvedUrl("DetailsPage.qml"),
                                   { projectID: listItem.projectID,
                                     projectName: listItem.projectName,
                                     projectDescription: listItem.projectDescription,
                                     projectActive: listItem.projectActive
                                   });
                }
                onPressAndHold: {
                    listView.currentIndex = index;
                    contextMenu.open();
                }
            }

            Row {
                id: rowComponent
                spacing: 20
                anchors {
                    fill: parent
                    leftMargin: UIConstants.HALF_DEFAULT_MARGIN
                    rightMargin: UIConstants.HALF_DEFAULT_MARGIN
                }

                Switch {
                    id: switchComponent
                    anchors.verticalCenter: parent.verticalCenter
                    checked: (listItem.projectActive === -1) ? false : true

                    onCheckedChanged: {
                        //console.debug("MainPage.qml: onCheckedChanged fired with projectActive:", listItem.projectActive);
                        if (listItem.projectActive !== -1 && !checked){
                            db.updateEndtime(listItem.projectActive, new Date());
                            db.updateProjectActive(listItem.projectID, -1);
                            listItem.projectActive = -1;
                        }
                        else if (listItem.projectActive === -1 && checked) {
                            var insertID = db.insertStarttime(listItem.projectID, new Date());
                            db.updateProjectActive(listItem.projectID, insertID);
                            listItem.projectActive = insertID;
                        }
                    }
                }

                Column {
                    id: columnComponent
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - switchComponent.width -
                           iconComponent.width - 2*rowComponent.spacing

                    Text {
                        color: UIConstants.COLOR_FOREGROUND

                        font {
                            family: UIConstants.FONT_FAMILY
                            pixelSize: UIConstants.FONT_DEFAULT
                            bold: true
                        }

                        text: model.titleText
                        width: parent.width
                        elide: Text.ElideRight
                    }
                    Text {
                        color: UIConstants.COLOR_SECONDARY_FOREGROUND

                        font {
                            family: UIConstants.FONT_FAMILY
                            pixelSize: UIConstants.FONT_SMALL
                        }

                        text: {
                            if (true) {
                                return model.description;
                            }
                            else {
                                return "Available";
                            }
                        }
                        width: parent.width
                        elide: Text.ElideRight
                    }
                }

                Image {
                    id: iconComponent
                    anchors.verticalCenter: parent.verticalCenter
                    height: sourceSize.height
                    width: sourceSize.width
                    source: "image://theme/icon-m-common-drilldown-arrow" + platformStyle.__invertedString
                }
            }
            // Divider
            Image {
                id: image
                width: parent.width
                height: sourceSize.height
                anchors.top: parent.bottom
                source: "image://theme/meegotouch-groupheader" + (theme.inverted ? "-inverted" : "") + "-background"
            }
        }
    }


    Item {
        id: addResourcesBtn
        anchors.centerIn: parent
        opacity: 0

        Text {
            id: textid
            anchors.centerIn: parent
            color: UIConstants.COLOR_FOREGROUND

            font {
                family: UIConstants.FONT_FAMILY
                pixelSize: UIConstants.FONT_DEFAULT
            }

            text: "No projects"
        }

        Button {
            text: "Add"

            anchors {
                top: textid.bottom
                horizontalCenter: textid.horizontalCenter
                topMargin: 20
            }

            onClicked: projectSheet.open();
        }
    }


    ContextMenu {
        id: contextMenu

        MenuLayout {
            MenuItem {
                text: "Edit"
                onClicked: {
                    var currIndex = listView.currentIndex;
                    var listModelItem = listModel.get(currIndex);
                    projectSheet.projectID  = listModelItem.projectID;
                    projectSheet.projectName = listModelItem.name;
                    projectSheet.projectDescription = listModelItem.description;
                    projectSheet.open()
                }
            }
            MenuItem {
                text: "Delete"
                onClicked: {
                    var currIndex = listView.currentIndex;
                    var listModelItem = listModel.get(currIndex);
                    mainPage.showDeleteDialog(listModelItem.projectID,listModelItem.name);
                }
            }
        }
    }
    ProjectPage {
        id: projectSheet
    }

}
