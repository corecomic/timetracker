#include <QtGui/QApplication>
#include <QDeclarativeComponent> // qmlRegisterType
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"

#include "src/databasemanager.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;

    // Setting database Qt class handle to QML
    DatabaseManager* db = new DatabaseManager();
    db->open();
    viewer.rootContext()->setContextProperty("db", db);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/timetracker/main.qml"));
    viewer.showExpanded();

    int ret = app->exec();
    delete db;
    return ret;
}
