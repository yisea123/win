#ifndef ADVANCESETTING_H
#define ADVANCESETTING_H

#include <QObject>
#include <QProcess>

class AdvanceSetting : public QObject
{
    Q_OBJECT
public:
    explicit AdvanceSetting(QObject *parent = nullptr);
    ~AdvanceSetting();

signals:

public slots:

   bool openStCamera();
   bool openAVCamera();

   bool openA3200();

private:
   QProcess* stCamera;
    QProcess* avCamera;
   QProcess* a3200;
};

#endif // ADVANCESETTING_H
