import QtQuick 1.1
import com.nokia.meego 1.0 // MeeGo 1.2 Harmattan components

import "UIConstants.js" as UIConstants

Page {
    id: detailsPage
    tools: topLevelTools

    property int projectID
    property string projectName
    property string projectDescription
    property int projectActive

    /**
     * Fill list model with database values
     */
    function fillListModel()
    {
        listView.model = emptyListModel;
        listModel.clear();

        // Get timesheets
        var timesheetIdList = db.countTimesheet(projectID);
        //console.debug("DetailsPage.qml: timesheetIdList:", timesheetIdList);

        for (var i = 0; i < timesheetIdList.length; i++){
            var timesheetData = db.timesheet(timesheetIdList[i]);
            listModel.append({ "starttime": timesheetData.starttime,
                               "endtime": timesheetData.endtime,
                               "runtime": timesheetData.runtime,
                               "projectID": timesheetData.pindex,
                               "timesheetID": timesheetData.index});
        }

        if (listModel.count < 1) {
            //addResourcesBtn.opacity = 1;
            listView.opacity = 0;
        }
        else {
            //addResourcesBtn.opacity = 0;
            listView.opacity = 1;
        }

        listView.model = listModel;
    }


//    /**
//     * Displays the delete query dialog.
//     */
//    function showDeleteDialog(index, name)
//    {
//        if (!deleteDialog) {
//            deleteDialog = deleteDialogComponent.createObject(mainPage);
//        }

//        deleteDialog.message = "Do you realy want to delete the project: " + name + "?";
//        deleteDialog.open();

//        pIndex = index;
//    }

//    /**
//     * Deletes the project from the database.
//     */
//    function deleteProjectFromDatabase()
//    {
//        if (pIndex !== -1){
//            db.deleteProject(pIndex);
//        }
//        appWindow.pageStack.pop();
//        fillListModel();
//    }

//    // Delete dialog
//    Component {
//        id: deleteDialogComponent

//        QueryDialog {
//            titleText: "Delete?"
//            message: ""
//            acceptButtonText: "Delete"
//            rejectButtonText: "Cancel"
//            onAccepted: deleteProjectFromDatabase();
//        }
//    }

    // Update page data on page PageStatus.Activating state
    onStatusChanged: {
        if (status === PageStatus.Activating) {
            fillListModel();
        }
        //console.debug("DetailsPage.qml: onStatusChanged:", status);
    }

    // Page content
    ScrollDecorator {
        flickableItem: listView
    }

    // Page Header
    PageHeader {
        id: appTitleRect
        text: projectName
    }

    // Total Time
    Item {
        id: timeHeader
        height: UIConstants.FIELD_DEFAULT_HEIGHT

        anchors {
            top: appTitleRect.bottom
            left: parent.left
            right: parent.right
            topMargin: UIConstants.SMALL_MARGIN
        }

        Text {
            anchors.centerIn: parent
            color: UIConstants.COLOR_FOREGROUND

            font {
                family: UIConstants.FONT_FAMILY
                pixelSize: UIConstants.FONT_DEFAULT
            }

            text: {
                var totalSecs = db.selectTotalTime(projectID);
                var date = new Date(((totalSecs % 86400)-3600) * 1e3);
                if (totalSecs >= 2*86400) {
                    return "Total time: " + (totalSecs - (totalSecs % 86400))/86400 + " days, " + Qt.formatDateTime(date, 'hh:mm:ss');
                }
                else if (totalSecs >= 86400) {
                    return "Total time: " + (totalSecs - (totalSecs % 86400))/86400 + " day, " + Qt.formatDateTime(date, 'hh:mm:ss');
                }

                else {
                    return "Total time: " + Qt.formatDateTime(date, 'hh:mm:ss');
                }


            }
        }

//        Rectangle {
//          height: 1
//          width: parent.width
//          anchors.top: parent.bottom
//          anchors.topMargin: 1
//          color: "white"
//        }
    }

    // Page Content - List
    ListView {
        id: listView
        anchors {
            top: timeHeader.bottom
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
            property int timesheetID: model.timesheetID
            property date starttime: model.starttime
            property date endtime: model.endtime
            property variant runtime: model.runtime

            height: UIConstants.LIST_ITEM_HEIGHT_DEFAULT
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

                Column {
                    id: columnComponent
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        color: UIConstants.COLOR_FOREGROUND

                        font {
                            family: UIConstants.FONT_FAMILY
                            pixelSize: UIConstants.FONT_DEFAULT
                            bold: false
                        }


                        text: {
                            if (model.runtime.toString()) {
                                return model.runtime;
                            }
                            else {
                                return "Running..."
                            }
                        }


                        MouseArea {
                            id: itemMouseArea
                            //anchors.fill: parent
                            width: columnComponent.width
                            height: UIConstants.LIST_ITEM_HEIGHT_DEFAULT
                            onPressAndHold: {
                                listView.currentIndex = index;
                                contextMenu.open();
                            }
                        }
                    }
                    Text {
                        color: "steelblue"

                        font {
                            family: UIConstants.FONT_FAMILY
                            pixelSize: UIConstants.FONT_XSMALL
                        }

                        text: {
                            if (model.endtime.toString() !== "Invalid Date") {
                                return Qt.formatDateTime(model.starttime, 'dd.MM.yy | hh:mm') + " - " + Qt.formatDateTime(model.endtime, 'hh:mm');
                            }
                            else {
                                return Qt.formatDateTime(model.starttime, 'dd.MM.yy | hh:mm');
                            }
                        }
                        width: listView.width
                    }

                }
            }
        }
    }
}
