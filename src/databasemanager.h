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
// Renter
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
    Q_INVOKABLE void deleteProject(const int id);
    Q_INVOKABLE QObject* project(const int id);
    Q_INVOKABLE QList<int> countProject();
    
private:
    bool openDB();
    bool initDB();
    bool createProjectTable();
    bool createTimeSheetTable();
    QSqlDatabase db;
    
};

#endif // DATABASEMANAGER_H
