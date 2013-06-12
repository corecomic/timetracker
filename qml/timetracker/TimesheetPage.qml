import QtQuick 1.1
import com.nokia.meego 1.0 // MeeGo 1.2 Harmattan components

import "../harmattan-datepicker"
import "UIConstants.js" as UIConstants

Sheet {
    id: projectPage

    property int timesheetID: -1
    property int projectID
    property date startTime: new Date()
    property date endTime: new Date()

    /**
     * Adds or updates the rent data into the database.
     */
    function addTimesheetToDatabase()
    {
        // TODO: check validity of startTime and endTime
        if (timesheetID !== -1) {
            db.updateTimesheet(timesheetID, projectID, startTime, endTime);
        }
        else {
            db.insertTimesheet(projectID, startTime, endTime);
        }
    }

    // Page Header
    acceptButtonText: "Save"
    rejectButtonText: "Cancel"

    onAccepted: {
        projectPage.addTimesheetToDatabase();
        detailsPage.fillListModel();
        detailsPage.setTotalTime();
    }
    onRejected: { }


    // Formular
    content: Flickable {
        id: flickable
        anchors.fill: parent
        clip: true
        contentWidth: parent.width
        contentHeight: content.height

        Item {
            id: content
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: UIConstants.DEFAULT_MARGIN
            }

            // Start Time
            SectionHeader {
                id: startHeader
                section: "Start"
            }
            MyListItem {
                id: starttimeItem

                anchors.top: startHeader.bottom

                title.text: "Time"
                subtitle.text: Qt.formatDateTime(startTime, "hh:mm")

                onClicked: {
                    timeItemStart.hour = startTime.getHours();
                    timeItemStart.minute = startTime.getMinutes();
                    timeItemStart.show();
                }
            }
            TimeItem {
                id: timeItemStart
                opacity: 0
                onTimeChanged: {
                    var newTime = startTime;
                    newTime.setHours(hour);
                    newTime.setMinutes(minute);
                    startTime = newTime;
                }
            }
            MyListItem {
                id: startdateItem

                anchors.top: starttimeItem.bottom

                title.text: "Date"
                subtitle.text: Qt.formatDateTime(startTime, "dd.MM.yy")

                onClicked: {
                    calendarItemStart.day = startTime.getDate();
                    calendarItemStart.month = startTime.getMonth()+1;
                    calendarItemStart.year = startTime.getFullYear();
                    calendarItemStart.show();
                }
            }
            CalendarItem {
                id: calendarItemStart
                opacity: 0
                onDateChanged: {
                    var newDate = startTime;
                    newDate.setFullYear(year);
                    newDate.setMonth(month-1);
                    newDate.setDate(day);
                    startTime = newDate;
                }
            }

            // End Time
            SectionHeader {
                id: endHeader
                anchors.top: startdateItem.bottom
                section: "End"
            }
            MyListItem {
                id: endtimeItem

                anchors.top: endHeader.bottom

                title.text: "Time"
                subtitle.text: (endTime.toString() !== "Invalid Date") ? Qt.formatDateTime(endTime, "hh:mm") : Qt.formatDateTime(new Date(), "hh:mm")

                onClicked: {
                    timeItemEnd.hour = endTime.getHours();
                    timeItemEnd.minute = endTime.getMinutes();
                    timeItemEnd.show();
                }
            }
            TimeItem {
                id: timeItemEnd
                opacity: 0
                onTimeChanged: {
                    var newTime = endTime;
                    newTime.setHours(hour);
                    newTime.setMinutes(minute);
                    endTime = newTime;
                }
            }
            MyListItem {
                id: enddateItem

                anchors.top: endtimeItem.bottom

                title.text: "Date"
                subtitle.text: (endTime.toString() !== "Invalid Date") ? Qt.formatDateTime(endTime, "dd.MM.yy") : Qt.formatDateTime(new Date(), "dd.MM.yy")

                onClicked: {
                    calendarItemEnd.day = endTime.getDate();
                    calendarItemEnd.month = endTime.getMonth()+1;
                    calendarItemEnd.year = endTime.getFullYear();
                    calendarItemEnd.show();
                }
            }
            CalendarItem {
                id: calendarItemEnd
                opacity: 0
                onDateChanged: {
                    var newDate = endTime;
                    newDate.setFullYear(year);
                    newDate.setMonth(month-1);
                    newDate.setDate(day);
                    endTime = newDate;
                }
            }
        } // Item
    } // Flickable
}
