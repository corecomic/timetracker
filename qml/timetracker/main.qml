import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    ToolBarLayout {
        id: commonTools
        visible: false
        Item {}
        ToolIcon {
            platformIconId: "toolbar-add"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: {
                projectSheet.projectName = "";
                projectSheet.projectDescription = "";
                projectSheet.open()
            }
        }
        ToolIcon {
            platformIconId: "toolbar-refresh"
            anchors.centerIn: (parent === undefined) ? undefined : parent
            onClicked: mainPage.fillListModel()
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }

    }
    ProjectPage {
        id: projectSheet
    }

    ToolBarLayout {
        id: topLevelTools
        visible: false

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: appWindow.pageStack.pop()
        }
    }

    // Delete dialog
    QueryDialog {
        id: deleteDialog
        titleText: "Delete database?"
        message: "Do you realy want to delete the whole database, all data will be lost!"
        acceptButtonText: "Delete"
        rejectButtonText: "Cancel"
        onAccepted: {
            db.deleteDB()
            endDialog.open()
        }
    }

    // End dialog
    QueryDialog {
        id: endDialog
        titleText: "Close application!"
        message: "The application will now be closed. To create a new database just reopen the application."
        acceptButtonText: "Ok"
        onAccepted: {
            Qt.quit()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Delete database")
                onClicked: deleteDialog.open()
            }
            MenuItem {
                text: qsTr("About")
                onClicked: appWindow.pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }

    // Watch orientation changes
    onOrientationChangeStarted: {
        showStatusBar = (screen.currentOrientation !== Screen.Landscape);
    }
}

