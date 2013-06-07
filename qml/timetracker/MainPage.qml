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
        text: "Timetracker"
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
            margins: UIConstants.DEFAULT_MARGIN
        }

        clip: true
        delegate: listDelegate
        model: listModel
        focus: true
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

            Rectangle {
                radius: 8
                anchors.fill: parent
                opacity: 0.7
                color: "lightsteelblue"
                visible: itemMouseArea.pressed
            }

            Row {
                spacing: 20
                anchors.fill: parent

                Switch {
                    anchors.verticalCenter: parent.verticalCenter
                    id: switchComponent
                    checked: (listItem.projectActive === -1) ? false : true

                    onCheckedChanged: {
                        //console.debug("MainPage.qml: onCheckedChanged fired with projectActive:", listItem.projectActive);
                        //console.debug("MainPage.qml: onCheckedChanged fired with checked:", checked);
                        if (listItem.projectActive !== -1 && !checked){
                            db.updateEndtime(listItem.projectActive, new Date());
                            db.updateProjectActive(listItem.projectID, -1);
                            listItem.projectActive = -1;
                            //fillListModel();
                        }
                        else if (listItem.projectActive === -1 && checked) {
                            var insertID = db.insertStarttime(listItem.projectID, new Date());
                            db.updateProjectActive(listItem.projectID, insertID);
                            listItem.projectActive = insertID;
                            //fillListModel();
                            //console.debug("MainPage.qml: insertStarttime projectID:", listItem.projectID);
                            //console.debug("MainPage.qml: insertStarttime time:", new Date());
                            //console.debug("MainPage.qml: insertStarttime insertID:", insertID);
                        }
                    }
                }

                Column {
                    id: columnComponent
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        color: UIConstants.COLOR_FOREGROUND

                        font {
                            family: UIConstants.FONT_FAMILY
                            pixelSize: UIConstants.FONT_DEFAULT
                            bold: true
                        }

                        text: model.titleText
                        MouseArea {
                            id: itemMouseArea
                            //anchors.fill: parent
                            width: columnComponent.width
                            height: UIConstants.LIST_ITEM_HEIGHT_LARGE

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
                        width: listView.width-switchComponent.width*2
                        elide: Text.ElideRight
                    }

                }
            }
            Rectangle {
              height: 1
              width: parent.width
              anchors.top: parent.bottom
              anchors.topMargin: 1
              color: "white"
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

            onClicked: pageStack.push(Qt.resolvedUrl("ProjectPage.qml"));
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
                    pageStack.push(Qt.resolvedUrl("ProjectPage.qml"),
                                   { projectID: listModelItem.projectID,
                                     projectName: listModelItem.name,
                                     projectDescription: listModelItem.description
                                   });
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
}
