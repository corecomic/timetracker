// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: aboutPage
    tools: topLevelTools

//    Component.onCompleted: theme.inverted = true
//    Component.onDestruction: theme.inverted = false

//    PageHeader {
//        id: appTitleRect
//        text: "Timetracker"
//    }


    // Content
    property string aboutText:
        "<p>Timetracker is a simple time tracker application that allows "+
        "to keep track of the time spent on different projects."+
        "</p>" +
        "<p>The UI is implemented using Qt Quick components 1.1 library "+
        "and the application follows the harmattan design guidelines. "+
        "The data is stored into a SQLite database." +
        "</p>" +
        "<p>For more information about the project see the " +
        "<a href=\"https://projects.developer.nokia.com/timetracker\">" +
        "Timetracker project page</a>"+
        "</p>" +
        "<h3>Instructions</h3>" +
        "<p>" +
        "When the application is first installed, the database is empty. "+
        "The user can then start defining projects he wants to track. "+
        "After one or more projects have been created, the time spent on each "+
        "is tracked by switching it on/off. A tracking period is maximal 24 hours." +
        "</p>";

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: textContainer.height
        clip: true

        Item {
            id: textContainer
            height: text.height + anchors.margins * 2

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 20
            }

            Text {
                id: text
                width: parent.width
                color: "black"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                style: Text.Raised
                styleColor: "white"
                font.pixelSize: width * 0.05
                text: "<h2>Timetracker " + appversion + "</h2>" + aboutText;
                onLinkActivated: Qt.openUrlExternally(link);
            }
        }
    }

    ScrollDecorator {
        flickableItem: flickable
    }

}

