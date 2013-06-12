#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QDate>
#include <QVariant>
#include <QStringList>
#include <QFile>
#include <QtCore/QDir>


// ---------------------------------------------------------------------------
// Project
// ---------------------------------------------------------------------------
class Project : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int index READ index WRITE setIndex)
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(QString description READ description WRITE setDescription)
    Q_PROPERTY(int active READ active WRITE setActive)

public:
    Project(QObject* parent=0);
    ~Project();

    int index() const;
    void setIndex(const int);

    QString name() const;
    void setName(const QString);

    QString description() const;
    void setDescription(const QString);

    int active() const;
    void setActive(const int);

public:
    int m_id;
    QString m_name;
    QString m_description;
    int m_active;
};


// ---------------------------------------------------------------------------
// Timesheet
// ---------------------------------------------------------------------------
class Timesheet : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int index READ index WRITE setIndex)
    Q_PROPERTY(int pindex READ pindex WRITE setPindex)
    Q_PROPERTY(QDateTime starttime READ starttime WRITE setStarttime)
    Q_PROPERTY(QDateTime endtime READ endtime WRITE setEndtime)
    Q_PROPERTY(QTime runtime READ runtime WRITE setRuntime)

public:
    Timesheet(QObject* parent=0);
    ~Timesheet();

    int index() const;
    void setIndex(const int);

    int pindex() const;
    void setPindex(const int);

    QDateTime starttime() const;
    void setStarttime(const QDateTime);

    QDateTime endtime() const;
    void setEndtime(const QDateTime);

    QTime runtime() const;
    void setRuntime(const QTime);

public:
    int m_id;
    int m_pid;
    QDateTime m_starttime;
    QDateTime m_endtime;
    QTime m_runtime;
};


// ---------------------------------------------------------------------------
// DatabaseManager
// ---------------------------------------------------------------------------
class DatabaseManager : public QObject
{
    Q_OBJECT

public:
    DatabaseManager(QObject *parent = 0);
    ~DatabaseManager();
    
public:
    Q_INVOKABLE void open();
    Q_INVOKABLE void close();
    Q_INVOKABLE bool deleteDB();
    Q_INVOKABLE QSqlError lastError();

    // Project table
    Q_INVOKABLE QVariant insertProject(const QVariant& name,
                                       const QVariant& description);
    Q_INVOKABLE QVariant updateProject(const QVariant& id,
                                       const QVariant& name,
                                       const QVariant& description);
    Q_INVOKABLE QVariant updateProjectActive(const QVariant& id,
                                             const QVariant& active);
    Q_INVOKABLE void deleteProject(const int id);
    Q_INVOKABLE QObject* project(const int id);
    Q_INVOKABLE QList<int> countProject();

    // Timesheet table
    Q_INVOKABLE QVariant insertTimesheet(const QVariant& pid,
                                         const QVariant& starttime,
                                         const QVariant& endtime);
    Q_INVOKABLE QVariant insertStarttime(const QVariant& pid,
                                         const QVariant& starttime);
    Q_INVOKABLE QVariant updateTimesheet(const QVariant& id,
                                         const QVariant& pid,
                                         const QVariant& starttime,
                                         const QVariant& endtime);
    Q_INVOKABLE QVariant updateEndtime(const QVariant& id,
                                       const QVariant& endtime);
    Q_INVOKABLE void deleteTimesheet(const int id);
    Q_INVOKABLE QObject* timesheet(const int id);
    Q_INVOKABLE QList<int> countTimesheet(const int id);
    Q_INVOKABLE int selectTotalTime(const int id);



    
private:
    bool openDB();
    bool initDB();
    bool createProjectTable();
    bool createTimeSheetTable();
    QSqlDatabase db;
    
};

#endif // DATABASEMANAGER_H
