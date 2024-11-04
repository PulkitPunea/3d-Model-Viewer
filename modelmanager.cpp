#include "modelmanager.h"
#include <QCoreApplication>
#include <QProcess>
#include <QStringList>
#include <QDebug>
#include <QDir>
#include <QFileInfoList>
#include <QFileInfo>

ModelManager::ModelManager(QObject *parent)
    : QObject{parent}
{}

void ModelManager::setInputFilePathC(QString s){}
void ModelManager::setoutputDirectoryC(QString s){}

int ModelManager::processModel(QString inputFilePath, QString outputDirectory) {

    //QString balsam = "D:/QTTest/Balsam/balsam.exe"; // Path to the Balsam executable
    QString installRootDirectory = QCoreApplication::applicationDirPath();
    QString balsam = installRootDirectory +"/balsam.exe";
    qDebug() << "cpp:" << "Balsam.exe directory " <<balsam;
    QFileInfo fileInfo(inputFilePath);
    QString fileName = fileInfo.baseName();

    inputFilePathC = inputFilePath.remove(0,8);
    qDebug() << "cpp: inputFilePathC :" << inputFilePathC;

    outputDirectoryC = outputDirectory.remove(0, 8);

    //outputDirectoryC += "/" + fileName + "/";
    qDebug() << "cpp: FileName :" << fileName;
    outputDirectoryC += "/" + fileName;
    qDebug() << "cpp: outputDirectoryC :" << outputDirectoryC;
    //qDebug() << "cpp: outputDirectoryC :" << outputDirectoryC;

    // Prepare arguments for the process
    QStringList arguments = {inputFilePathC, "-o", outputDirectoryC};

    // Create a QProcess with 'this' as the parent for proper memory management
    QProcess *processModel = new QProcess(this);

    processModel->start(balsam, arguments);

    // Wait for the process to start
    if (!processModel->waitForStarted()) {
        qDebug() << "Error starting process:" << processModel->errorString();
        return -1; // Error while starting the process
    }

    // Wait for the process to finish
    processModel->waitForFinished();

    // Check exit code to determine success
    int exitCode = processModel->exitCode();

    if (exitCode == 0) {
        qDebug() << "cpp: Model processed successfully!";

        // List the files in the output directory
        QDir outputDir((outputDirectoryC + "/meshes/"));
        QStringList filters;
        filters << "*.mesh"; // Filter for .mesh files
        QFileInfoList files = outputDir.entryInfoList(filters, QDir::Files | QDir::NoDotAndDotDot);

        // Check if there is exactly one file
        if (files.size() == 1) {
            QString generatedMeshFile = files.first().absoluteFilePath(); // Get the absolute file path
            emit modelProcessed(generatedMeshFile); // Emit the signal with the file path
            qDebug() << "cpp: onModelProcessed signal emitted with path:" << generatedMeshFile;
        } else {
            qDebug() << "Error: Expected one .mesh file, found:" << files.size();
        }
    } else {
        qDebug() << "Model processing failed with exit code:" << exitCode;
    }

    // Clean up
    processModel->deleteLater();
    return exitCode;

}
