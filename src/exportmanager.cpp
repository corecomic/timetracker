#include "exportmanager.h"
#include <QDesktopServices>
#include <QDebug>


// ---------------------------------------------------------------------------
// TimesheetModel
// ---------------------------------------------------------------------------
TimesheetModel::TimesheetModel(QObject *parent)
    : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[StarttimeRole] = "starttime";
    roles[EndtimeRole] = "endtime";
    roles[RuntimeRole] = "runtime";
    roles[PidRole] = "projectID";
    roles[TidRole] = "timesheetID";
    roles[HeaderRole] = "header";
    setRoleNames(roles);
}

int TimesheetModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return 1;
}

QVariant TimesheetModel::data(const QModelIndex &index, int role) const
{

}

// ---------------------------------------------------------------------------
// ExportManager
// ---------------------------------------------------------------------------
ExportManager::ExportManager(QObject *parent) :
    QObject(parent)
{
}

ExportManager::~ExportManager()
{
}

void ExportManager::csvExport(QObject* model)
{
    QString path(QDesktopServices::storageLocation(QDesktopServices::DocumentsLocation));
    path.append(QDir::separator()).append("timetracker_export.csv");
    path = QDir::toNativeSeparators(path);

    //qDebug() << model.first()->findChildren<TimesheetModel*>();

    QVariantMap element;
    QVariant qele = QVariant::fromValue(element);
    qDebug() << QMetaObject::invokeMethod(model, "getElement", Qt::DirectConnection, Q_RETURN_ARG(QVariant, qele), Q_ARG(QVariant, 0));
    qDebug() << qele.type();

    //QVariant len = 0;
    //qDebug() << QMetaObject::invokeMethod(model, "getCount", Qt::DirectConnection, Q_RETURN_ARG(QVariant, len));
    //qDebug() << len;

    //qDebug() << model->children();
    /*
    int x = 0;
    QString exportdata;

    int w = 1;
    while (x < model->columnCount()){
        if (!ui->tableView->isColumnHidden(x)) {
            exportdata.append(model->headerData(x,Qt::Horizontal,Qt::DisplayRole).toString());

            if (model->columnCount() - w > counthidden)
                exportdata.append(";");
            else {
                exportdata.append("\n");
            }

            w++;
        }

        x++;
    }


    int z = 0;

    w = 1;
    while (z < model->rowCount()) {
        x = 0;
        w = 1;

        while (x < model->columnCount()) {
            if (!ui->tableView->isColumnHidden(x)) {
                exportdata.append(model->data(model->index(z,x),Qt::DisplayRole).toString());

                if (model->columnCount() - w > counthidden)
                    exportdata.append(";");
                else
                    exportdata.append("\n");
                w++;
            }
            x++;
        }
        z++;
    }
    */

    /*
    QFile file;

    file.setFileName(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QByteArray ttext;
    ttext.append(exportdata);
    file.write(ttext);
    */
}
