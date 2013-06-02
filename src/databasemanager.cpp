#include "databasemanager.h"
#include <QDebug>


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

    QString path(QDir::home().path());
    path.append(QDir::separator()).append("time-tracker.db.sqlite");
    path = QDir::toNativeSeparators(path);
    db.setDatabaseName(path);

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
                         "active_flag INTEGER DEFAULT(0))");
    }
    return ret;
}

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
        ret = query.prepare("INSERT INTO project (name, description, creation_date)"
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
    return QVariant(ret);
}

void DatabaseManager::deleteProject(const int id)
{
    QSqlQuery query;
    query.exec(QString("DELETE FROM project WHERE id = %1").arg(id));
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

