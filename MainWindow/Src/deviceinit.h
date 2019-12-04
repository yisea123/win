#ifndef DEVICEINIT_H
#define DEVICEINIT_H
#include <QObject>
#include <QRunnable>
#include <QThreadPool>
#include <QEventLoop>

class DeviceInit : public QObject
{
    Q_OBJECT
public:
    explicit DeviceInit(QObject *parent = nullptr);
    ~DeviceInit();


    static int isEXIT;

public Q_SLOTS:
    void exitApp();

    void initDone();

    void initCamera();//-1.all failed 0.all succeed  1.camera1 succeed 2.camera2 succeed
    void initA3200();
    void initGTS();
    void initLaser();



Q_SIGNALS:

    void cameraInitCompleted(bool code);
    void a3200InitCompleted(bool code);
    void gtsInitCompleted(bool code);
    void laserInitCompleted(bool code,QString error);
    void laserStartWait(int second);

private:

    QThreadPool pool;

};

class CameraInit : public QObject, public QRunnable
{
    Q_OBJECT
public:
    explicit CameraInit(QObject *parent = nullptr);


signals:

    void _CameraInitDone(bool isSucceed);

private:


    void run();


};

class LaserInit : public QObject, public QRunnable
{
    Q_OBJECT
public:
    explicit LaserInit(QObject *parent = nullptr);


signals:
    void _LaserWaitStart(int msecond);
    void _LaserInitDone(bool isSucceed);

private:

    void run();


};


class A3200Init : public QObject, public QRunnable
{
    Q_OBJECT
public:
    explicit A3200Init(QObject *parent = nullptr);

signals:
    void _A3200InitDone(bool isSucceed);
    bool isHome(QString str);

private:

    void run();
};


class GtsInit : public QObject, public QRunnable
{
    Q_OBJECT
public:
    explicit GtsInit(QObject *parent = nullptr);
signals:
    void _GtsInitDone(bool isSucceed);
private:
    void run();

};

#endif // DEVICEINIT_H
