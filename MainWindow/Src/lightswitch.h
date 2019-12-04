#ifndef LIGHTSWITCH_H
#define LIGHTSWITCH_H

#include <QObject>

class LightSwitch : public QObject
{
    Q_OBJECT
public:
    explicit LightSwitch(QObject *parent = nullptr);

signals:

public slots:
    QString getSwitchPos();
    int getStep();
    void moveStep(double step);

    void setStep(QString value);
    void setSwitchPos(QString value);
    void setWaitPosition(QStringList value);
    QStringList getWaitPosition();

    QStringList getMotionConf();
     void setMotionConf(QStringList value);




    QString getCurPos(int index);
};

#endif // LIGHTSWITCH_H
