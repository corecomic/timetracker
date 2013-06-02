// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: aboutPage
//    Component.onCompleted: theme.inverted = true
//    Component.onDestruction: theme.inverted = false

//    PageHeader {
//        id: appTitleRect
//        text: "Timetracker"
//    }

    tools: topLevelTools

    Column {
        id: column
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 12
        spacing: 25

        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            text: "A simple time tracker application that allows to keep track of the time spent on different projects."
        }
    }

}

