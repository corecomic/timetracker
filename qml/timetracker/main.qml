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
        visible: true
        Item {}
        ToolIcon {
            platformIconId: "toolbar-add"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: appWindow.pageStack.push(Qt.resolvedUrl("ProjectPage.qml"))
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }


        // TODO: Add new project icon.
    }

    ToolBarLayout {
        id: topLevelTools
        visible: false

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: appWindow.pageStack.pop()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("About")
                onClicked: appWindow.pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }
}

