#ifndef EXPORTMANAGER_H
#define EXPORTMANAGER_H

#include <QObject>
#include <QAbstractListModel>
#include <QDeclarativeListReference>
#include <QDate>
#include <QVariant>
#include <QStringList>
#include <QFile>
#include <QtCore/QDir>


// ---------------------------------------------------------------------------
// TimesheetModel
// ---------------------------------------------------------------------------
class TimesheetModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum TimesheetRoles {
        StarttimeRole = Qt::UserRole + 1,
        EndtimeRole,
        RuntimeRole,
        PidRole,
        TidRole,
        HeaderRole
    };

    TimesheetModel(QObject *parent = 0);
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
};


// ---------------------------------------------------------------------------
// ExportManager
// ---------------------------------------------------------------------------
class ExportManager : public QObject
{
    Q_OBJECT

public:
    explicit ExportManager(QObject *parent = 0);
    ~ExportManager();

    Q_INVOKABLE void csvExport(QObject *model);

signals:
    
public slots:
    
};

#endif // EXPORTMANAGER_H
