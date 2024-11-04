#ifndef MODELMANAGER_H
#define MODELMANAGER_H

#include <QObject>

class ModelManager : public QObject
{
    Q_OBJECT
public:
    explicit ModelManager(QObject *parent = nullptr);

    Q_INVOKABLE int processModel(QString inputFilePath="", QString outputDirectory="");
    Q_INVOKABLE void setInputFilePathC(QString s="");
    Q_INVOKABLE void setoutputDirectoryC(QString s="");
private:
    QString inputFilePathC = "";
    QString outputDirectoryC = "";

signals:
    void modelProcessed(QString modelMeshPath);
};

#endif // MODELMANAGER_H
