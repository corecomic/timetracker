import QtQuick 1.1
import com.nokia.meego 1.0 // MeeGo 1.2 Harmattan components

import "UIConstants.js" as UIConstants

Page {
    id: detailsPage
    tools: detailTools

    property int projectID
    property string projectName
    property string projectDescription
    property int projectActive

    // viewIndex: 0-All, 1-Today, 2-Week, 3-Month
    property int viewIndex: 0

    property QueryDialog deleteDialog
    property int pIndex: -1

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
            var dateTime = new Date();
            var sectionString = "";
            if (Qt.formatDate(timesheetData.starttime) == Qt.formatDate(dateTime)) {
                sectionString = "Today";
            }
            else{
                sectionString = "Older";
            }

            listModel.append({ "starttime": timesheetData.starttime,
                               "endtime": timesheetData.endtime,
                               "runtime": timesheetData.runtime,
                               "projectID": timesheetData.pindex,
                               "timesheetID": timesheetData.index,
                               "header": sectionString
                             });
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

    /**
     * Get total time
     */
    function setTotalTime()
    {
        var totalSecs = db.selectTotalTime(projectID);
        var date = new Date(((totalSecs % 86400)-3600) * 1e3);
        if (totalSecs >= 2*86400) {
            timeHeaderText.text = "Total time: " + (totalSecs - (totalSecs % 86400))/86400 + " days, " + Qt.formatDateTime(date, 'hh:mm:ss');
        }
        else if (totalSecs >= 86400) {
            timeHeaderText.text = "Total time: " + (totalSecs - (totalSecs % 86400))/86400 + " day, " + Qt.formatDateTime(date, 'hh:mm:ss');
        }

        else {
            timeHeaderText.text = "Total time: " + Qt.formatDateTime(date, 'hh:mm:ss');
        }
    }


    /**
     * Displays the delete query dialog.
     */
    function showDeleteDialog(index)
    {
        if (!deleteDialog) {
            deleteDialog = deleteDialogComponent.createObject(detailsPage);
        }

        deleteDialog.message = "Do you realy want to delete the time entry?";
        deleteDialog.open();

        pIndex = index;
    }

    /**
     * Deletes the project from the database.
     */
    function deleteTimesheetFromDatabase()
    {
        if (pIndex !== -1){
            db.deleteTimesheet(pIndex);
        }
        fillListModel();
        setTotalTime();
    }

    // Delete dialog
    Component {
        id: deleteDialogComponent

        QueryDialog {
            titleText: "Delete?"
            message: ""
            acceptButtonText: "Delete"
            rejectButtonText: "Cancel"
            onAccepted: deleteTimesheetFromDatabase();
        }
    }

    // Update page data on page PageStatus.Activating state
    onStatusChanged: {
        if (status === PageStatus.Activating) {
            fillListModel();
            setTotalTime();
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
        icon: true
        onClicked: {
            selectViewDialog.open();
        }
    }

    // Total Time
    Item {
        id: timeHeader
        height: UIConstants.FIELD_SMALL_HEIGHT

        anchors {
            top: appTitleRect.bottom
            left: parent.left
            right: parent.right
            topMargin: UIConstants.SMALL_MARGIN
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

        section.property: "header"
        section.criteria: ViewSection.FullString
        section.delegate: sectionHeader
    }
    Component {
        id: sectionHeader
        SectionHeader {
            text: section
            height: 32
        }
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

            MyListItem {
                id: listItemContent
                anchors.fill: parent

                title {
                    text: {
                        if (model.runtime.toString()) {
                            return model.runtime;
                        }
                        else {
                            return "Running..."
                        }
                    }
                    font.bold: false
                }
                subtitle {
                    text: {
                        if (model.endtime.toString() !== "Invalid Date") {
                            return Qt.formatDateTime(model.starttime, 'dd.MM.yy | hh:mm') + " - " + Qt.formatDateTime(model.endtime, 'hh:mm');
                        }
                        else {
                            return Qt.formatDateTime(model.starttime, 'dd.MM.yy | hh:mm');
                        }
                    }
                    color: "steelblue"
                    font.pixelSize: UIConstants.FONT_XSMALL
                }

                onPressAndHold: {
                    listView.currentIndex = index;
                    contextMenu.open();
                }
                iconVisible: false
            }
        }
    }
    SelectionDialog {
        id: selectViewDialog
        titleText: "Select view"
        selectedIndex: viewIndex

        model: ListModel {
            ListElement { name: "All data" }
            ListElement { name: "Today" }
            ListElement { name: "This week" }
            ListElement { name: "This month" }
        }

        onClicked: {
            viewIndex = selectedIndex;
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
                    timesheetPage.projectID = listModelItem.projectID;
                    timesheetPage.timesheetID = listModelItem.timesheetID;
                    timesheetPage.startTime = listModelItem.starttime;
                    timesheetPage.endTime = listModelItem.endtime;
                    timesheetPage.open();
                }
            }
            MenuItem {
                text: "Delete"
                onClicked: {
                    var currIndex = listView.currentIndex;
                    var listModelItem = listModel.get(currIndex);
                    detailsPage.showDeleteDialog(listModelItem.timesheetID);
                }
            }
        }
    }
    ToolBarLayout {
        id: detailTools
        visible: false
        Item {}
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: appWindow.pageStack.pop()
        }
        ToolIcon {
            platformIconId: "toolbar-add"
            anchors.centerIn: (parent === undefined) ? undefined : parent
            onClicked: {
                timesheetPage.projectID = projectID;
                timesheetPage.startTime = new Date();
                timesheetPage.endTime = new Date();
                timesheetPage.open();
            }
        }
    }
    TimesheetPage {
        id: timesheetPage
    }
}
