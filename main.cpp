#include <QtGui/QApplication>
#include <QDeclarativeComponent> // qmlRegisterType
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"

#include "src/databasemanager.h"
#include "src/exportmanager.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;

    // Setting database Qt class handle to QML
    DatabaseManager* db = new DatabaseManager();
    db->open();
    viewer.rootContext()->setContextProperty("db", db);

    // Setting export Qt class handle to QML
    ExportManager* em = new ExportManager();
    viewer.rootContext()->setContextProperty("em", em);

    // Set application version
    app->setApplicationVersion(APP_VERSION);
    viewer.rootContext()->setContextProperty("appversion",
                                           app->applicationVersion());

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/timetracker/main.qml"));
    viewer.showExpanded();

    int ret = app->exec();
    delete db;
    return ret;
}
