/**
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.0 // MeeGo 1.2 Harmattan components
import com.nokia.extras 1.1 // Extras

import "../harmattan-timepicker"
import "UIConstants.js" as UIConstants

Item {
    id: container

    property int hour:  0
    property int minute: 0

    signal timeChanged();

    function getCurrentTime()
    {
        var date = new Date();
        date.setHours(hour);
        date.setMinutes(minute);
        return date;
    }

    function show()
    {
        container.opacity = 1;
        dialog.hour = hour;
        dialog.minute = minute;
        dialog.open()
    }

    function setNow()
    {
        var date = new Date();
        hour = date.getHours()
        minute = date.getMinutes()
    }

//    function setNextDay()
//    {
//        var date = new Date();
//        date.setFullYear(year, month - 1, day); // year, month (0-based), day
//        date.setDate(date.getDate() + 1);

//        year = date.getFullYear();
//        month = date.getMonth() + 1;
//        day = date.getDate();

//        dateChanged();
//    }

//    function setPriorDay()
//    {
//        var date = new Date();
//        date.setFullYear(year, month - 1, day); // year, month (0-based), day
//        date.setDate(date.getDate() - 1);

//        year = date.getFullYear();
//        month = date.getMonth() + 1;
//        day = date.getDate();

//        dateChanged();
//    }

    function callbackFunction() {
        hour = dialog.hour;
        minute = dialog.minute;

        timeChanged();
    }

    Component.onCompleted: {
        setNow();
    }

    TimePickerDialog {
        id: dialog
        titleText: "Time"
        acceptButtonText: "Confirm"
        rejectButtonText: "Cancel"
        fields: DateTime.Hours | DateTime.Minutes

        onAccepted: {
            callbackFunction();
        }
        onRejected: { }
    }


    TimePicker {
        id: timePicker
        anchors.centerIn: parent
        opacity: 0

        function orientationSuffix() {
            if (screen.currentOrientation === Screen.Portrait || screen.currentOrientation === Screen.PortraitInverted )
                return "portrait"
            else
                return "landscape"
        }

        backgroundImage: "image://theme/meegotouch-timepicker-light-1-" + orientationSuffix()
        hourDotImage: "image://theme/meegotouch-timepicker-disc-hours-" + orientationSuffix()
        minutesDotImage: "image://theme/meegotouch-timepicker-disc-minutes-" + orientationSuffix()
    }
}
