#include "databasemanager.h"
#include <QDebug>
#include <QDesktopServices>


// ---------------------------------------------------------------------------
// Project
// ---------------------------------------------------------------------------
Project::Project(QObject* parent) : QObject(parent)
{
    m_id = 0;

}
Project::~Project() { }

int Project::index() const
{
    return m_id;
}

void Project::setIndex(const int index)
{
    m_id = index;
}

QString Project::name() const
{
    return m_name;
}

void Project::setName(const QString name)
{
    m_name = name;
}

QString Project::description() const
{
    return m_description;
}

void Project::setDescription(const QString description)
{
    m_description = description;
}

int Project::active() const
{
    return m_active;
}

void Project::setActive(const int active)
{
    m_active = active;
}


// ---------------------------------------------------------------------------
// Timesheet
// ---------------------------------------------------------------------------
Timesheet::Timesheet(QObject* parent) : QObject(parent)
{
    m_id = 0;
    m_pid = 0;

}
Timesheet::~Timesheet() { }

int Timesheet::index() const
{
    return m_id;
}

void Timesheet::setIndex(const int index)
{
    m_id = index;
}

int Timesheet::pindex() const
{
    return m_pid;
}

void Timesheet::setPindex(const int pindex)
{
    m_pid = pindex;
}

QDateTime Timesheet::starttime() const
{
    return m_starttime;
}

void Timesheet::setStarttime(const QDateTime starttime)
{
    m_starttime = starttime;
}

QDateTime Timesheet::endtime() const
{
    return m_endtime;
}

void Timesheet::setEndtime(const QDateTime endtime)
{
    m_endtime = endtime;
}

QTime Timesheet::runtime() const
{
    return m_runtime;
}

void Timesheet::setRuntime(const QTime runtime)
{
    m_runtime = runtime;
}


// ---------------------------------------------------------------------------
// DatabaseManager
// ---------------------------------------------------------------------------
DatabaseManager::DatabaseManager(QObject *parent) :
    QObject(parent)
{
}

DatabaseManager::~DatabaseManager()
{
    close();
}

void DatabaseManager::open()
{
    openDB();
    initDB();
}

void DatabaseManager::close()
{
    if(db.isOpen())
        db.close();
}

bool DatabaseManager::openDB()
{
    // Find QSLite driver
    db = QSqlDatabase::addDatabase("QSQLITE");
    QDir rootdir(QDir::root());

    QString newpath(QDesktopServices::storageLocation(QDesktopServices::DataLocation));
    newpath.append(QDir::separator()).append("timetracker");
    qDebug() << "SQL DataLocation..:" << newpath;
    rootdir.mkpath(newpath);
    newpath.append(QDir::separator()).append("timetracker_0.1.db.sqlite");
    newpath = QDir::toNativeSeparators(newpath);

    QString path(QDir::home().path());
    path.append(QDir::separator()).append("timetracker_0.1.db.sqlite");
    path = QDir::toNativeSeparators(path);

    db.setDatabaseName(newpath);

    // Open databasee
    return db.open();
}

QSqlError DatabaseManager::lastError()
{
    // If opening database has failed user can ask
    // error description by QSqlError::text()
    return db.lastError();
}

bool DatabaseManager::initDB()
{
    bool ret = true;

    // Create tables
    if (createProjectTable()) {
        createTimeSheetTable();
    }

    // Check that tables exists
    if (db.tables().count() != 2)
        ret = false;

    return ret;
}

bool DatabaseManager::deleteDB()
{
    // Close database
    db.close();

    QString path(QDir::home().path());
    path.append(QDir::separator()).append("time-tracker.db.sqlite");
    path = QDir::toNativeSeparators(path);

    return QFile::remove(path);
}


/* PROJECT */
bool DatabaseManager::createProjectTable()
{
    // Create project table
    bool ret = false;
    if (db.isOpen()) {
        QSqlQuery query;
        ret = query.exec("CREATE TABLE project "
                         "(id INTEGER PRIMARY KEY AUTOINCREMENT, "
                         "name VARCHAR(60) NOT NULL, "
                         "description VARCHAR(200), "
                         "creation_date TIMESTAMP, "
                         "active_flag INTEGER DEFAULT(-1), "
                         "salary FLOAT)");
        if (!ret){
            qDebug() << "SQL Error..:" << query.lastError();
            qDebug() << "SQL Error..:" << query.lastError().driverText();
        }
    }
    return ret;
}

QVariant DatabaseManager::insertProject(const QVariant& name,
                                        const QVariant& description)
{
    // Insert new project into table
    bool ret = false;
    if (db.isOpen()){
        QSqlQuery query;
        ret = query.prepare("INSERT INTO project (name, description, creation_date) "
                            "VALUES (:name, :description, DATETIME('now','localtime'))");
        if (ret) {
            query.bindValue(":name", name.toString());
            query.bindValue(":description", description.toString());
            ret = query.exec();
        }
        if (!ret){
            qDebug() << "SQL Error..:" << query.lastError();
            qDebug() << "SQL Error..:" << query.lastError().driverText();
        }
    }
    return QVariant(ret);
}

QVariant DatabaseManager::updateProject(const QVariant& id,
                                        const QVariant& name,
                                        const QVariant& description)
{
    // Update project
    bool ret = false;
    QSqlQuery query;
    ret = query.prepare("UPDATE project SET name = :name, description = :description WHERE id = :id");
    if (ret) {
        query.bindValue(":name", name);
        query.bindValue(":description", description);
        query.bindValue(":id", id);
        ret = query.exec();
    }
    if (!ret){
        qDebug() << "SQL Error..:" << query.lastError();
        qDebug() << "SQL Error..:" << query.lastError().driverText();
    }
    return QVariant(ret);
}

QVariant DatabaseManager::updateProjectActive(const QVariant& id,
                                              const QVariant& active)
{
    // Update project
    bool ret = false;
    QSqlQuery query;
    ret = query.prepare("UPDATE project SET active_flag = :active WHERE id = :id");
    if (ret) {
        query.bindValue(":active", active);
        query.bindValue(":id", id);
        ret = query.exec();
    }
    if (!ret){
        qDebug() << "SQL Error..:" << query.lastError();
        qDebug() << "SQL Error..:" << query.lastError().driverText();
    }
    return QVariant(ret);
}

void DatabaseManager::deleteProject(const int id)
{
    QSqlQuery query;
    query.exec(QString("DELETE FROM project WHERE id = %1").arg(id));
    query.exec(QString("DELETE FROM timesheet WHERE project_id = %1").arg(id));
}

QObject* DatabaseManager::project(const int id)
{
    Project* project = new Project(this);
    QSqlQuery query(QString("SELECT * FROM project WHERE id = %1").arg(id));
    if (query.next()) {
        project->m_id = query.value(0).toInt();
        project->m_name = query.value(1).toString();
        project->m_description = query.value(2).toString();
        project->m_active = query.value(4).toInt();
    }
    return project;
}

QList<int> DatabaseManager::countProject()
{
    QList<int> itemList;
    QSqlQuery query(QString("SELECT id FROM project"));
    while (query.next()) {
        int item = query.value(0).toInt();
        itemList.append(item);
    }
    return itemList;
}

/* TIMESHEET */
bool DatabaseManager::createTimeSheetTable()
{
    // Create timesheet table
    bool ret = false;
    if (db.isOpen()) {
        QSqlQuery query;
        ret = query.exec("CREATE TABLE timesheet "
                         "(id INTEGER PRIMARY KEY AUTOINCREMENT, "
                         "project_id INTEGER KEY NOT NULL, "
                         "start_time DATETIME, "
                         "end_time DATETIME, "
                         "run_time TIME)");
        if (!ret){
            qDebug() << "SQL Error..:" << query.lastError();
            qDebug() << "SQL Error..:" << query.lastError().driverText();
        }
    }
    return ret;
}

QVariant DatabaseManager::insertTimesheet(const QVariant& pid,
                                          const QVariant& starttime,
                                          const QVariant& endtime)
{
    // Insert new timesheet entry into table
    bool ret = false;
    QTime zerotime;

    if (db.isOpen()){
        QSqlQuery query;
        ret = query.prepare("INSERT INTO timesheet (project_id, start_time, end_time, run_time) "
                            "VALUES (:project_id, :start_time, :end_time, :run_time)");
        if (ret) {
            query.bindValue(":project_id", pid.toInt());
            query.bindValue(":start_time", starttime.toDateTime());
            query.bindValue(":end_time", endtime.toDateTime());
            query.bindValue(":run_time", zerotime.addSecs(starttime.toDateTime().secsTo(endtime.toDateTime())));
            query.exec();
        }
        if (!ret){
            qDebug() << "SQL Error..:" << query.lastError();
            qDebug() << "SQL Error..:" << query.lastError().driverText();
        }
    }
    return QVariant(ret);
}

QVariant DatabaseManager::insertStarttime(const QVariant& pid,
                                          const QVariant& starttime)
{
    // Insert new starttime entry into table
    bool ret = false;
    QVariant retval;
    if (db.isOpen()){
        QSqlQuery query;
        ret = query.prepare("INSERT INTO timesheet (project_id, start_time) "
                            "VALUES (:project_id, :start_time)");
        if (ret) {
            query.bindValue(":project_id", pid.toInt());
            query.bindValue(":start_time", starttime.toDateTime());
            query.exec();
        }
        if (!ret){
            qDebug() << "SQL Error..:" << query.lastError();
            qDebug() << "SQL Error..:" << query.lastError().driverText();
        }
        QSqlQuery query2(QString("SELECT last_insert_rowid()"));
        if (query2.next()){
            retval = query2.value(0);
        }
    }
    return retval;
}

QVariant DatabaseManager::updateTimesheet(const QVariant& id,
                                          const QVariant& pid,
                                          const QVariant& starttime,
                                          const QVariant& endtime)
{
    bool ret = false;
    QTime zerotime;

    // Update timesheet entry
    QSqlQuery query2;
    ret = query2.prepare("UPDATE timesheet SET project_id = :pid, start_time = :start_time, "
                         "end_time = :end_time, run_time = :run_time WHERE id = :id");
    if (ret) {
        query2.bindValue(":pid", pid.toInt());
        query2.bindValue(":start_time", starttime.toDateTime());
        query2.bindValue(":end_time", endtime.toDateTime());
        query2.bindValue(":run_time", zerotime.addSecs(starttime.toDateTime().secsTo(endtime.toDateTime())));
        query2.bindValue(":id", id.toInt());
        query2.exec();
    }
    if (!ret){
        qDebug() << "SQL Error..:" << query2.lastError();
        qDebug() << "SQL Error..:" << query2.lastError().driverText();
    }
    return QVariant(ret);
}


QVariant DatabaseManager::updateEndtime(const QVariant& id,
                                        const QVariant& endtime)
{
    bool ret = false;
    QDateTime starttime;
    QTime zerotime;

    // Get starttime
    QSqlQuery query(QString("SELECT start_time FROM timesheet WHERE id=%1").arg(id.toInt()));
    if (query.next()) {
        starttime = query.value(0).toDateTime();
    }
    //qDebug() << "SQL updateEndtime - runtime:" << zerotime.addSecs(starttime.secsTo(endtime.toDateTime()));

    // Update endtime entry in table
    QSqlQuery query2;
    ret = query2.prepare("UPDATE timesheet SET end_time = :end_time, run_time = :run_time WHERE id = :id");
    if (ret) {
        query2.bindValue(":end_time", endtime.toDateTime());
        query2.bindValue(":run_time", zerotime.addSecs(starttime.secsTo(endtime.toDateTime())));
        query2.bindValue(":id", id.toInt());
        query2.exec();
    }
    if (!ret){
        qDebug() << "SQL Error..:" << query2.lastError();
        qDebug() << "SQL Error..:" << query2.lastError().driverText();
    }
    return QVariant(ret);
}

void DatabaseManager::deleteTimesheet(const int id)
{
    QSqlQuery query;
    query.exec(QString("DELETE FROM timesheet WHERE id = %1").arg(id));
}

QObject* DatabaseManager::timesheet(const int id)
{
    Timesheet* timesheet = new Timesheet(this);
    QSqlQuery query(QString("SELECT * FROM timesheet WHERE id = %1").arg(id));
    if (query.next()) {
        timesheet->m_id = query.value(0).toInt();
        timesheet->m_pid = query.value(1).toInt();
        timesheet->m_starttime = query.value(2).toDateTime();
        timesheet->m_endtime = query.value(3).toDateTime();
        timesheet->m_runtime = query.value(4).toTime();
    }
    return timesheet;
}

QList<int> DatabaseManager::countTimesheet(const int id)
{
    QList<int> itemList;
    QSqlQuery query(QString("SELECT id FROM timesheet WHERE project_id = %1 ORDER BY start_time DESC").arg(id));
    while (query.next()) {
        int item = query.value(0).toInt();
        itemList.append(item);
    }
    return itemList;
}

int DatabaseManager::selectTotalTime(const int id)
{
    int sum = 0;
    QSqlQuery query(QString("SELECT SUM(strftime('%s', run_time) "
                            "- strftime('%s', '00:00:00')) "
                            "FROM timesheet WHERE project_id = %1").arg(id));
    if (query.next()) {
        sum = query.value(0).toInt();
    }
    return sum;
}



