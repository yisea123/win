#ifndef PROGRAMIO_H
#define PROGRAMIO_H

#include <QString>
#include <QHash>
#include <QObject>

enum ParaType { A3200Code=0,Flow_Focus_Y,Flow_Focus_Z,Flow_checkTube,Flow_useGas,Flow_closeDoor,Flow_processLength,Flow_processCount};


class ProgramIO: public QObject
{
     Q_OBJECT

public:
    explicit ProgramIO(QObject *parent = nullptr);

    QHash<long long, QString> hashInfo;

    bool readFile(const QString &filePath);
    bool writeFile(const QString &filePath);

public slots:


};


#endif // PROGRAMIO_H
